package record

import (
	"context"
	"io"
	"mime/multipart"

	"cloud.google.com/go/storage"
	"google.golang.org/api/option"
)

// Upload uploads an image to Firebase Storage.
func (f *firebase) Upload(ctx context.Context, filePath string, file multipart.File) error {
	client, err := storage.NewClient(ctx, option.WithCredentialsFile("credentials.json"))
	if err != nil {
		return err
	}
	defer client.Close()

	bucket := client.Bucket(f.resource.ConfigFirebase.ProjectId)
	obj := bucket.Object("bills/" + filePath)
	writer := obj.NewWriter(ctx)

	imageData, err := io.ReadAll(file)
	if err != nil {
		return err
	}

	if _, err := writer.Write(imageData); err != nil {
		return err
	}

	if err := writer.Close(); err != nil {
		return err
	}

	return nil
}
