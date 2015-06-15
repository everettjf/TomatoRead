package controllers

import (
	"LSServer/models"
	"LSServer/utils"
	"encoding/json"
	"fmt"
	"github.com/astaxie/beego"
)

type UserController struct {
	BaseController
}

func (this *UserController) SignUp() {
	req := struct {
		Email    string
		Password string
		Code     string
	}{}

	if err := json.Unmarshal(this.Ctx.Input.RequestBody, &req); err != nil {
		this.ResponseError400(err, "empty email or password")
		return
	}

	beego.Info("email:", req.Email)
	beego.Info("password:", req.Password)
	beego.Info("code:", req.Code)
	if req.Email == "" || req.Password == "" {
		this.ResponseError400(fmt.Errorf("empty field"), "")
		return
	}
	if req.Code != "hello" {
		this.ResponseError400(fmt.Errorf("signup code incorrect"), "")
		return
	}

	user := models.NewUser(req.Email, req.Password)

	userManager := models.NewUserManager()
	err := userManager.Save(user)
	if err != nil {
		this.Ctx.Output.SetStatus(400)
		this.Ctx.Output.Body([]byte(err.Error()))
		beego.Info(this.Ctx.Input.RequestBody)
		beego.Warn(err.Error())
		return
	}

}

func (this *UserController) SignIn() {
	req := struct {
		Email    string
		Password string
	}{}

	if err := json.Unmarshal(this.Ctx.Input.RequestBody, &req); err != nil {
		this.ResponseError400(err, "empty email or password")
		return
	}
	userManager := models.NewUserManager()
	user, err := userManager.FindUser(req.Email)
	if err != nil {
		this.ResponseError400(err, "")
		return
	}

	if user.Password != utils.MakePassword(req.Password) {
		this.ResponseError400(fmt.Errorf("password incorrect"), "")
		return
	}

	this.SetSession("userinfo", utils.ToJson(user))
	this.SetSession("userid", user.ID)
}

func (this *UserController) UserStatus() {
	user := this.UserLoginSession()
	if user == nil {
		this.ResponseError400(fmt.Errorf("User not signin"), "")
		return
	}

	res := struct {
		UserID      int64
		UserEmail   string
		EmailStatus bool
	}{user.ID, user.Email, user.EmailStatus}

	this.Data["json"] = res
	this.ServeJson()
}

func (this *UserController) SignOut() {
	this.DelSession("userinfo")
	this.DelSession("userid")
}
func (this *UserController) SignOutView() {
	this.SignOut()
	this.RedirectToRouter("/")
}
