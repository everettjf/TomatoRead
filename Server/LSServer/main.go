package main

import (
	_ "LSServer/models"
	_ "LSServer/routers"
	_ "LSServer/utils/tags"
	"github.com/astaxie/beego"
)

func main() {
	// log
	beego.SetLogger("file", `{"filename":"logs/app.log"}`)
	//beego.BeeLogger.DelLogger("console")
	beego.SetLevel(beego.LevelDebug)
	beego.SetLogFuncCall(true)

	// admin
	//beego.EnableAdmin = true

	beego.SetStaticPath("/partials", "views/partials")

	beego.Run()
}
