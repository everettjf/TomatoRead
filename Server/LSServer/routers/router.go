package routers

import (
	"LSServer/controllers"
	"github.com/astaxie/beego"
)

func init() {
	beego.Router("/", &controllers.MainController{}, "get:Welcome")
	beego.Router("/my", &controllers.MainController{}, "get:My")

	beego.Router("/user/signup/", &controllers.UserController{}, "post:SignUp")
	beego.Router("/user/signin/", &controllers.UserController{}, "post:SignIn")
	beego.Router("/user/signout/", &controllers.UserController{}, "get:SignOutView;post:SignOut")
	beego.Router("/user/status/", &controllers.UserController{}, "get:UserStatus")

	beego.Router("/link/list/", &controllers.LinkController{}, "get:ListLinks")
	beego.Router("/link/listtopclick/", &controllers.LinkController{}, "get:ListTopClickLinks")
	beego.Router("/link/listtopneverclick/", &controllers.LinkController{}, "get:ListTopNeverClickLinks")
	beego.Router("/link/listtags/", &controllers.LinkController{}, "get:ListTags")
	beego.Router("/link/new/", &controllers.LinkController{}, "post:NewLink")
	beego.Router("/link/batchnew/", &controllers.LinkController{}, "post:BatchNewLink")
	beego.Router("/link/info/:id", &controllers.LinkController{}, "get:GetLink")
	beego.Router("/link/click/", &controllers.LinkController{}, "put:ClickLink")
	beego.Router("/link/trash/", &controllers.LinkController{}, "post:TrashLink")
	beego.Router("/link/addgroup/", &controllers.LinkController{}, "post:AddGroup")
	beego.Router("/link/listgroup/", &controllers.LinkController{}, "get:ListGroup")
	beego.Router("/link/listgroupbasic/", &controllers.LinkController{}, "get:ListGroupBasic")
	beego.Router("/link/removegroup/", &controllers.LinkController{}, "post:RemoveGroup")
	beego.Router("/link/addlinktogroup/", &controllers.LinkController{}, "post:AddLinkToGroup")
	beego.Router("/link/removelinkfromgroup/", &controllers.LinkController{}, "post:RemoveLinkFromGroup")

	beego.Router("/util/extracttags/", &controllers.TagController{}, "post:ExtractTags")
	beego.Router("/util/extracttitletags/", &controllers.TagController{}, "post:ExtractTitleTags")
}
