package filestorage

import (
	"context"
	"fmt"
	"io"
	"log"
	"mime/multipart"

	"github.com/OucheneMohamedNourElIslem658/estin_losts/shared/database/models"
	"github.com/google/uuid"
	"github.com/minio/minio-go/v7"
	"github.com/minio/minio-go/v7/pkg/credentials"
)

type FileStorage struct {
	client     *minio.Client
	bucketName string
}

var Instance *FileStorage

func Init() {
	client, err := minio.New(envs.url, &minio.Options{
		Creds: credentials.NewStaticV4(
			envs.accessKey,
			envs.secretKey,
			"",
		),
		Secure: false,
		Region: "us-east-1",
	})

	if err != nil {
		log.Fatal(err.Error())
	}

	bucketExists, err := client.BucketExists(
		context.Background(),
		envs.bucketName,
	)

	if err != nil {
		log.Fatal(err.Error())
	}

	if !bucketExists {
		err := client.MakeBucket(
			context.Background(),
			envs.bucketName,
			minio.MakeBucketOptions{Region: ""},
		)
		if err != nil {
			log.Fatal(err.Error())
		}

	}

	Instance = &FileStorage{
		client:     client,
		bucketName: envs.bucketName,
	}

	log.Println("File Storage Connected Successfully!")
}

type progressReader struct {
	Reader     io.Reader
	TotalBytes int64
	BytesRead  int64
	OnProgress func(bytesRead, totalBytes int64)
}

func (pr *progressReader) Read(p []byte) (n int, err error) {
	n, err = pr.Reader.Read(p)
	pr.BytesRead += int64(n)
	if pr.OnProgress != nil {
		pr.OnProgress(pr.BytesRead, pr.TotalBytes)
	}
	return n, err
}

func (fs *FileStorage) UploadFile(fileHeader *multipart.FileHeader, folder string, uploadCallback func(bytesRead, totalBytes int64)) (uploadResult *models.Image, err error) {
	id := uuid.New().String()
	objectName := fmt.Sprintf("%s/%s/%s", folder, id, fileHeader.Filename)

	file, err := fileHeader.Open()
	if err != nil {
		return nil, err
	}
	defer file.Close()

	progressReader := &progressReader{
		Reader:     file,
		TotalBytes: fileHeader.Size,
		OnProgress: uploadCallback,
	}

	_, err = fs.client.PutObject(
		context.Background(),
		fs.bucketName,
		objectName,
		file,
		fileHeader.Size,
		minio.PutObjectOptions{
			Progress: progressReader,
			ContentType: fileHeader.Header.Get("Content-Type"),
	    },
	)

	fmt.Println(objectName)

	url := fmt.Sprintf("%s/%s/%s", envs.url, envs.bucketName, objectName)

	image := &models.Image{
		Name:          fileHeader.Filename,
		FileStorageID: objectName,
		URL:           url,
	}

	return image, nil
}

func (fs *FileStorage) UploadFiles(filesHeaders []*multipart.FileHeader, folder string, uploadCallback func(bytesRead, totalBytes int64)) (uploadedFiles []models.Image, err error) {
	totalBytesToUpload := int64(0)

	for _, fileHeader := range filesHeaders {
		totalBytesToUpload += fileHeader.Size
	}

	totalBytesRead := int64(0)

	for _, fileHeader := range filesHeaders {
		uploadedFile, err := fs.UploadFile(fileHeader, folder, func(bytesRead, _ int64) {
			uploadCallback(totalBytesRead+bytesRead, totalBytesToUpload)
		})

		totalBytesRead += fileHeader.Size

		if err != nil {
			for _, uploadedFile := range uploadedFiles {
				fs.DeleteFile(uploadedFile.FileStorageID)
			}
			return nil, err
		}

		uploadedFiles = append(uploadedFiles, *uploadedFile)
	}

	return uploadedFiles, nil
}

func (fs *FileStorage) DeleteFile(fileStorageID string) error {
	err := fs.client.RemoveObject(
		context.Background(),
		fs.bucketName,
		fileStorageID,
		minio.RemoveObjectOptions{},
	)
	return err
}
