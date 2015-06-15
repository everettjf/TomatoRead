package controllers

import (
// "github.com/astaxie/beego"
)

type MainController struct {
	BaseController
}

func (this *MainController) My() {
	this.PrepareUserData()
	this.TplNames = "index.html"
	this.Render()
}

func (this *MainController) Welcome() {
	this.PrepareUserData()

	this.TplNames = "welcome.html"
	this.Render()
}
