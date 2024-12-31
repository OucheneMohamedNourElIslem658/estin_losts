package realtime

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"time"

	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/database"
	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/database/models"
	filestorage "github.com/OucheneMohamedNourElIslem658/estin_losts/shared/file_storage"
	"github.com/lib/pq"
)

var Instance *Realtime

var databaseURL = database.Envs.GetDatabaseDSN()

type Realtime struct {
	database *sql.DB
}

func Init() {
	fmt.Println(databaseURL)
	database, err := sql.Open("postgres", databaseURL)
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}

	_, err = database.Exec(`
		CREATE OR REPLACE FUNCTION notify_table_change()
		RETURNS TRIGGER AS $$
		BEGIN
			PERFORM pg_notify(
				'table_changes',
				json_build_object(
					'table', TG_TABLE_NAME,
					'operation', TG_OP,
					'data', CASE
						WHEN TG_OP = 'DELETE' THEN row_to_json(OLD)
						ELSE row_to_json(NEW)
					END
				)::text
			);
			RETURN NEW;
		END;
		$$ LANGUAGE plpgsql;
	`)

	if err != nil {
		log.Fatalf("Failed to create trigger function: %v", err)
	}

	Instance = &Realtime{
		database: database,
	}

	Instance.deleteImageFromFileStorage()

	log.Println("Realtime initialized successfully!")
}

type SnapshotType string

const (
	Insert SnapshotType = "INSERT"
	Update SnapshotType = "UPDATE"
	Delete SnapshotType = "DELETE"
)

func (r *Realtime) Listen(tableName string, onTableChange func(snapshotType SnapshotType, payload map[string]interface{})) {
	triggerName := fmt.Sprintf("trigger_%s_change", tableName)

	// Check and create trigger if it doesn't exist
	_, err := r.database.Exec(fmt.Sprintf(`
		DO $$
		BEGIN
			IF NOT EXISTS (
				SELECT 1 FROM pg_trigger
				WHERE tgname = '%s'
			) THEN
				CREATE TRIGGER %s
				AFTER INSERT OR UPDATE OR DELETE
				ON %s
				FOR EACH ROW
				EXECUTE FUNCTION notify_table_change();
			END IF;
		END;
		$$;`, triggerName, triggerName, tableName))

	if err != nil {
		log.Fatalf("Failed to create trigger for table %s: %v", tableName, err)
	}

	go func() {
		listener := pq.NewListener(databaseURL, 10*time.Second, time.Minute, func(event pq.ListenerEventType, err error) {
			if err != nil {
				log.Printf("Listener event error: %v", err)
			}
		})

		err := listener.Listen("table_changes")
		if err != nil {
			log.Fatalf("Failed to start listening to table changes: %v", err)
		}

		for {
			select {
			case notification := <-listener.Notify:
				if notification == nil {
					continue
				}

				var payload map[string]interface{}
				err := json.Unmarshal([]byte(notification.Extra), &payload)
				if err != nil {
					log.Printf("Failed to parse notification: %v", err)
					continue
				}

				if table, ok := payload["table"].(string); ok && table == tableName {
					if operation, ok := payload["operation"].(string); ok {
						if data, ok := payload["data"].(map[string]interface{}); ok {
							onTableChange(SnapshotType(operation), data)
						} else {
							log.Printf("Failed to parse 'data' field in notification: %v", payload)
						}
					} else {
						log.Printf("Failed to parse 'operation' field in notification: %v", payload)
					}
				}
			case <-time.After(90 * time.Second):
				go func() {
					err := listener.Ping()
					if err != nil {
						log.Fatalf("Listener ping failed: %v", err)
					}
				}()
			}
		}
	}()
}

func (r *Realtime) deleteImageFromFileStorage() {
	r.Listen("images", func(snapshotType SnapshotType, payload map[string]interface{}) {
		if snapshotType == Delete {
			image := models.Image{
				Name:              payload["name"].(string),
				FileStorageFolder: payload["file_storage_folder"].(string),
			}
			filestorage.Instance.DeleteImage(image)
		}
	})
}
