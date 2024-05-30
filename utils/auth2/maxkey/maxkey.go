package maxkey

import (
	"context"
	"errors"
	"fmt"
	"github.com/mindoc-org/mindoc/utils/auth2"
	"net/http"
	"net/url"
	"time"
)

const (
	AppName = "maxkey"

	callbackState = "mindoc"

	AuthorizeUrl = "/authz/oauth/v20/authorize"
	TokenUrl     = "/authz/oauth/v20/token"
	UserInfoUrl  = "/api/oauth/v20/me"
)

type BasicResponse struct {
	Message string `json:"errmsg"`
	Code    int    `json:"errcode"`
}

func (r *BasicResponse) Error() string {
	return fmt.Sprintf("errcode=%d, errmsg=%s", r.Code, r.Message)
}

func (r *BasicResponse) AsError() error {
	if r == nil {
		return nil
	}

	if r.Code != 0 || r.Message != "ok" {
		return r
	}
	return nil
}

type AccessToken struct {
	// 文档: https://open.dingtalk.com/document/orgapp/obtain-orgapp-token
	*BasicResponse

	AccessToken string `json:"access_token"`
	ExpireIn    int    `json:"expires_in"`

	createTime time.Time
}

func (a AccessToken) GetToken() string {
	return a.AccessToken
}

func (a AccessToken) GetExpireIn() time.Duration {
	return time.Duration(a.ExpireIn) * time.Second
}

func (a AccessToken) GetExpireTime() time.Time {
	return a.createTime.Add(a.GetExpireIn())
}

type UserAccessToken struct {
	// 文档: https://open.dingtalk.com/document/orgapp/obtain-user-token
	*BasicResponse // 此接口未返回错误代码信息，仅仅能检查HTTP状态码

	AccessToken string `json:"access_token"`
	TokenType   string `json:"token_type"`
	Scope       string `json:"scope"`
	ExpireIn    int    `json:"expires_in"`
}

type UserInfo struct {
	// 文档: https://open.dingtalk.com/document/orgapp/dingtalk-retrieve-user-information
	*BasicResponse

	Id       string `json:"id"`
	Username string `json:"username"`
}

func NewClient(endpoint string, clientId string, clientSecret string, redirectUri string) auth2.Client {
	return NewMaxkeyClient(endpoint, clientId, clientSecret, redirectUri)
}

func NewMaxkeyClient(endpoint string, clientId string, clientSecret string, redirectUri string) *MaxkeyClient {
	return &MaxkeyClient{Endpoint: endpoint, ClientId: clientId, ClientSecret: clientSecret, RedirectUri: redirectUri}
}

type MaxkeyClient struct {
	Endpoint     string
	ClientId     string
	ClientSecret string
	RedirectUri  string

	token auth2.IAccessToken
}

func (d *MaxkeyClient) GetAccessToken(ctx context.Context) (auth2.IAccessToken, error) {
	if d.token != nil {
		return d.token, nil
	}
	var token AccessToken
	return token, nil
}

func (d *MaxkeyClient) SetAccessToken(token auth2.IAccessToken) {
	d.token = token
}

func (d *MaxkeyClient) BuildURL(callback string, _ bool) string {
	v := url.Values{}
	v.Set("response_type", "code")
	v.Set("client_id", d.ClientId)
	v.Set("scope", "read write")
	v.Set("state", callbackState)
	v.Set("prompt", "auto")
	v.Set("redirect_uri", d.RedirectUri)
	return d.Endpoint + AuthorizeUrl + "?" + v.Encode()
}

func (d *MaxkeyClient) ValidateCallback(state string) error {
	if state != callbackState {
		return errors.New("auth2.state.wrong")
	}
	return nil
}

func (d *MaxkeyClient) getUserAccessToken(ctx context.Context, code string) (UserAccessToken, error) {
	v := url.Values{}
	v.Set("clientId", d.ClientId)
	v.Set("clientSecret", d.ClientSecret)
	v.Set("code", code)
	v.Set("grantType", "authorization_code")

	endpoint := d.Endpoint + TokenUrl + "?" + v.Encode()
	req, _ := http.NewRequestWithContext(ctx, http.MethodGet, endpoint, nil)
	var token UserAccessToken
	if err := auth2.Request(req, &token); err != nil {
		return token, err
	}
	return token, nil
}

func (d *MaxkeyClient) GetUserInfo(ctx context.Context, code string) (auth2.UserInfo, error) {
	var info auth2.UserInfo
	userToken, err := d.getUserAccessToken(ctx, code)
	if err != nil {
		return info, err
	}
	endpoint := fmt.Sprintf(d.Endpoint+UserInfoUrl+"?access_token=%s", userToken.AccessToken)
	req, _ := http.NewRequestWithContext(ctx, http.MethodGet, endpoint, nil)

	var user UserInfo
	if err := auth2.Request(req, &user); err != nil {
		return info, err
	}
	info.UserId = user.Id
	info.Name = user.Username
	return info, nil
}
