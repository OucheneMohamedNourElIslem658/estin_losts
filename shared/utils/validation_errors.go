package utils

import (
	"errors"
	"fmt"
	"log"
	"mime/multipart"
	"reflect"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/gin-gonic/gin/binding"
	"github.com/go-playground/validator/v10"
)

func ValidationErrorResponse(err error, dto any) gin.H {
	errors := make(gin.H)
	if validationErrors, ok := err.(validator.ValidationErrors); ok {
		for _, vErr := range validationErrors {
			errors["error"] = "invalid args"

			jsonTag := getJSONTag(dto, vErr.Field())

			switch vErr.Tag() {
			case "required":
				errors[jsonTag] = "required"
			case "oneof":
				allowedValues := vErr.Param()
				errors[jsonTag] = fmt.Sprintf("one of: %s", allowedValues)
			case "image": 
				errors[jsonTag] = "not image"
			default:
			}
		}
		return errors
	} else {
		return gin.H{
			"request": err.Error(),
		}
	}
}

func getJSONTag(v interface{}, fieldName string) string {
	t := reflect.TypeOf(v)

	field, found := t.FieldByName(fieldName)
	if !found {
		return fmt.Sprintf("Field %s not found in struct", fieldName)
	}

	tag := strings.Split(field.Tag.Get("json"), ",")[0]

	return tag
}

func validateImage(fl validator.FieldLevel) bool {
	file := fl.Field().Interface().(multipart.FileHeader)
	return isImage(file)
}

func isImage(fileHeader multipart.FileHeader) bool {
	contentType := fileHeader.Header.Get("Content-Type")
	return contentType == "image/jpeg" || contentType == "image/png"
}

func registerValidators() (err error) {
	if v, ok := binding.Validator.Engine().(*validator.Validate); !ok {
		return errors.New("validator initialization failed")
	} else {
		v.RegisterValidation("image", validateImage)
	}
	return nil
}

func InitValidators() {
	if err := registerValidators(); err != nil {
		log.Fatal(err)
	}
}