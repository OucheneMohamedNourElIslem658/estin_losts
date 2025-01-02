package redis

import "github.com/redis/go-redis/v9"

var Instance *redis.Client

func Init() {
	Instance = redis.NewClient(&redis.Options{
		Addr:     envs.Host + ":" + envs.Port,
		Password: envs.Password,
		DB:       0,
	})
}