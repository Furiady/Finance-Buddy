package accessory

import (
	"context"
	"encoding/base64"
	"io/ioutil"
	"mime/multipart"

	"cloud.google.com/go/storage"
)

// GetImageFromFirebase retrieves an image from Firebase Storage.
func (r *repository) GetImageFromFirebase(ctx context.Context, bucketName, imageName string) (string, error) {
	client, err := storage.NewClient(ctx)
	if err != nil {
		return "", err
	}
	defer client.Close()

	bucket := client.Bucket(bucketName)
	obj := bucket.Object(imageName)
	reader, err := obj.NewReader(ctx)
	if err != nil {
		return "", err
	}
	defer reader.Close()

	imageData, err := ioutil.ReadAll(reader)
	if err != nil {
		return "", err
	}

	encodedImage := base64.StdEncoding.EncodeToString(imageData)
	return encodedImage, nil
}

// UploadImageToFirebase uploads an image to Firebase Storage.
func (r *repository) UploadImageToFirebase(ctx context.Context, bucketName, imageName string, file multipart.File) error {
	client, err := storage.NewClient(ctx)
	if err != nil {
		return err
	}
	defer client.Close()

	bucket := client.Bucket(bucketName)
	obj := bucket.Object(imageName)
	writer := obj.NewWriter(ctx)
	defer writer.Close()

	imageData, err := ioutil.ReadAll(file)
	if err != nil {
		return err
	}

	if _, err := writer.Write(imageData); err != nil {
		return err
	}

	return nil
}
