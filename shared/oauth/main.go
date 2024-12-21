package oauth

import (
	"golang.org/x/oauth2"
	"golang.org/x/oauth2/google"
)

type Provider struct {
	Config       *oauth2.Config
	UserInfoURL  string
	EmailInfoURL string
}

type Providers map[string]Provider

var Instance Providers

func Init() {
	Instance = Providers{
		"google": {
			Config: &oauth2.Config{
				ClientID:     envs.googleClientID,
				ClientSecret: envs.googleClientSecret,
				RedirectURL:  envs.redirectURL,
				Scopes:       []string{"https://www.googleapis.com/auth/userinfo.profile", "https://www.googleapis.com/auth/userinfo.email"},
				Endpoint:     google.Endpoint,
			},
			UserInfoURL: "https://www.googleapis.com/oauth2/v2/userinfo?alt=json",
		},
	}
}

func IsSupportedProvider(provider string) bool {
	_, exists := Instance[provider]
	return exists
}
