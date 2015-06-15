package controllers

import (
	"LSServer/models"
	"LSServer/utils"
	"github.com/astaxie/beego"
)

type BaseController struct {
	beego.Controller
}

func (this *BaseController) ResponseError(httpStatus int, err error, message string) {
	this.Ctx.Output.SetStatus(httpStatus)
	this.Ctx.Output.Body([]byte(message + " " + err.Error()))
	// beego.Info(this.Ctx.Input.RequestBody)
	beego.Warn(message + " " + err.Error())
}
func (this *BaseController) ResponseError404(err error, message string) {
	this.ResponseError(404, err, message)
}

func (this *BaseController) ResponseError400(err error, message string) {
	this.ResponseError(400, err, message)
}

func (this *BaseController) RedirectToRouter(router string) {
	this.Ctx.Redirect(302, router)
}

func (this *BaseController) UserEnsureLogin() *models.User {
	user := this.UserLoginSession()
	if user == nil {
		this.Ctx.Redirect(302, "/login")
		return nil
	}
	return user
}

func (this *BaseController) UserLoginSession() *models.User {
	userInfo := this.GetSession("userinfo")
	if userInfo == nil {
		return nil
	}

	resUser := new(models.User)
	err := utils.JsonAs(userInfo.(string), resUser)
	if err != nil {
		return nil
	}
	return resUser
}
func (this *BaseController) IsUserReady() bool {
	return this.UserID() != 0
}

func (this *BaseController) UserID() int64 {
	userID := this.GetSession("userid")
	if userID == nil {
		return 0
	}
	return userID.(int64)
}

func (this *BaseController) PrepareUserData() {
	user := this.UserLoginSession()
	if user != nil {
		this.Data["userEmail"] = user.Email
	}
}
