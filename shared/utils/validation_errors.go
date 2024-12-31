package utils

import (
	"errors"
	"fmt"
	"log"
	"mime/multipart"
	"reflect"
	"strings"
	"time"

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
			case "object_time":
				errors[jsonTag] = "invalid time: must be in the past and within the last year"
			case "min":
				errors[jsonTag] = fmt.Sprintf("min: %s", vErr.Param())
			case "max":
				errors[jsonTag] = fmt.Sprintf("max: %s", vErr.Param())
			case "required_with":
				paramTag := getJSONTag(dto, vErr.Param())
				errors[jsonTag] = fmt.Sprintf("required with: %s", paramTag)
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
		return strings.ToLower(fieldName)
	}

	tag := strings.Split(field.Tag.Get("json"), ",")[0]
	if tag == "" {
		tag = strings.Split(field.Tag.Get("form"), ",")[0]
	}

	return tag
}

func validateImage(fl validator.FieldLevel) bool {
	file := fl.Field().Interface().(multipart.FileHeader)
	return isImage(&file)
}

func isImage(fileHeader *multipart.FileHeader) bool {
	contentType := fileHeader.Header.Get("Content-Type")
	return contentType == "image/jpeg" || contentType == "image/png"
}

func validateObjectTime(fl validator.FieldLevel) bool {
	t := fl.Field().Interface().(time.Time)

	isPast := t.Before(time.Now())
	isWithinLastYear := t.After(time.Now().AddDate(-1, 0, 0))

	fmt.Println(isPast, isWithinLastYear)

	return isPast && isWithinLastYear
}

func registerValidators() (err error) {
	if v, ok := binding.Validator.Engine().(*validator.Validate); !ok {
		return errors.New("validator initialization failed")
	} else {
		v.RegisterValidation("image", validateImage)
		v.RegisterValidation("object_time", validateObjectTime)
	}
	return nil
}

func InitValidators() {
	if err := registerValidators(); err != nil {
		log.Fatal(err)
	}
}
