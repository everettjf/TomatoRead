package controllers

import (
	"LSServer/models"
	"encoding/json"
	"github.com/astaxie/beego"
	//"strconv"
	"fmt"
	"github.com/seefan/to"
)

type LinkController struct {
	BaseController
}

// req: GET /link/
// res: 200 {"Links":[
//			{"ID":1,"Title":"baidu","url":"http://www.baidu.com"},
//			{"ID":2,"Title":"baidu","url":"http://www.baidu.com"}
//		]}
func (this *LinkController) ListLinks() {
	res := struct {
		Links []*models.TinyLink
	}{}

	linkManager := models.NewLinkManager()
	linkManager.SetUserID(this.UserID())
	links, err := linkManager.All()
	if err != nil {
		this.ResponseError400(err, "fetch link data")
		return
	}
	res.Links = links

	beego.Info("link count =", len(res.Links))

	this.Data["json"] = res
	this.ServeJson()
}
func (this *LinkController) ListTags() {
	res := struct {
		Tags []*models.TinyTag
	}{}

	linkManager := models.NewLinkManager()
	linkManager.SetUserID(this.UserID())
	tags, err := linkManager.AllTags()
	if err != nil {
		this.ResponseError400(err, "fetch tag")
		return
	}
	res.Tags = tags

	beego.Info("tag count =", len(res.Tags))

	this.Data["json"] = res
	this.ServeJson()
}
func (this *LinkController) ListTopClickLinks() {
	req := struct {
		Top int64
	}{}

	if err := json.Unmarshal(this.Ctx.Input.RequestBody, &req); err != nil {
		req.Top = 20
	}

	res := struct {
		Links []*models.TinyLinkWithClick
	}{}

	linkManager := models.NewLinkManager()
	linkManager.SetUserID(this.UserID())
	links, err := linkManager.TopClickLinks(req.Top)
	if err != nil {
		this.ResponseError400(err, "fetch topclicklinks data")
		return
	}
	res.Links = links

	beego.Info("topclicklink count =", len(res.Links))

	this.Data["json"] = res
	this.ServeJson()
}

func (this *LinkController) ListTopNeverClickLinks() {
	req := struct {
		Top int64
	}{}

	if err := json.Unmarshal(this.Ctx.Input.RequestBody, &req); err != nil {
		req.Top = 20
	}

	res := struct {
		Links []*models.TinyLinkWithClickTime
	}{}

	linkManager := models.NewLinkManager()
	linkManager.SetUserID(this.UserID())
	links, err := linkManager.TopNeverClickLinks(req.Top)
	if err != nil {
		this.ResponseError400(err, "fetch topclicklinks data")
		return
	}
	res.Links = links

	beego.Info("topneverclicklinktime count =", len(res.Links))

	this.Data["json"] = res
	this.ServeJson()
}

// req: POST /link/ {"Title":"","url":"}
// res: 400 empty title or url
//
// req: POST /link/ {"Title":"baidu","url":"http://www.baidu.com"}
// res: 200
func (this *LinkController) NewLink() {
	beego.Info("new link")

	req := struct {
		Title     string
		URL       string
		TagString string
	}{}

	if err := json.Unmarshal(this.Ctx.Input.RequestBody, &req); err != nil {
		this.ResponseError400(err, "empty title or url")
		return
	}
	if req.Title == "" || req.URL == "" || req.TagString == "" {
		this.ResponseError400(fmt.Errorf("Field is empty"), "")
		return
	}

	link := models.NewLink(req.Title, req.URL)

	link.Extend.Tags = models.ParseTagString(req.TagString)

	linkManager := models.NewLinkManager()
	linkManager.SetUserID(this.UserID())
	err := linkManager.Save(link)
	if err != nil {
		this.ResponseError400(err, "save link")
		return
	}
}

func (this *LinkController) BatchNewLink() {
	req := struct {
		Count int
		Links []struct {
			Title string
			URL   string
		}
	}{}

	if err := json.Unmarshal(this.Ctx.Input.RequestBody, &req); err != nil {
		this.ResponseError400(err, "unmarshal failed")
		return
	}

	linkManager := models.NewLinkManager()
	linkManager.SetUserID(this.UserID())
	if !linkManager.ParamReady() {
		this.ResponseError400(fmt.Errorf("Param not ready"), "")
		return
	}
	errorCount := 0
	for _, l := range req.Links {
		link := models.NewLink(l.Title, l.URL)
		link.Extend.Tags = ExtractTagsByArray(l.Title, l.URL)
		err := linkManager.Save(link)
		if err != nil {
			errorCount++
			continue
		}
	}
	if errorCount > 0 {
		// some error
		this.ResponseError400(fmt.Errorf("Partial Succeed"), "")
		return
	}

}

// req: GET /link/4526734dljfsds32323
// res: 404 not found
//
// req: GET /link/32
// res: 200 {"ID":"32","Title":"baidu",....}
func (this *LinkController) GetLink() {
	id := to.Int64(this.Ctx.Input.Param(":id"))
	beego.Info("get link ,id=", id)

	linkManager := models.NewLinkManager()
	linkManager.SetUserID(this.UserID())
	link, err := linkManager.Find(id)
	if err != nil {
		this.ResponseError404(err, "link not found")
		return
	}
	this.Data["json"] = link
	this.ServeJson()
}

func (this *LinkController) ClickLink() {
	beego.Info("click link")

	req := struct {
		ID int64
	}{}

	if err := json.Unmarshal(this.Ctx.Input.RequestBody, &req); err != nil {
		this.ResponseError400(err, "empty id")
		return
	}

	linkManager := models.NewLinkManager()
	linkManager.SetUserID(this.UserID())
	count, err := linkManager.Click(req.ID)
	if err != nil {
		this.ResponseError404(err, "click not count")
		return
	}
	this.Data["json"] = &struct{ Count int64 }{count}
	this.ServeJson()
}

func (this *LinkController) TrashLink() {
	beego.Info("trash link")

	req := struct {
		ID int64
	}{}

	if err := json.Unmarshal(this.Ctx.Input.RequestBody, &req); err != nil {
		this.ResponseError400(err, "empty id")
		return
	}

	linkManager := models.NewLinkManager()
	linkManager.SetUserID(this.UserID())
	err := linkManager.Trash(req.ID)
	if err != nil {
		this.ResponseError404(err, "delete link failed")
		return
	}
}

func (this *LinkController) AddGroup() {
	beego.Info("add group")

	req := struct {
		Name string
	}{}

	if err := json.Unmarshal(this.Ctx.Input.RequestBody, &req); err != nil {
		this.ResponseError400(err, "empty name")
		return
	}

	linkManager := models.NewLinkManager()
	linkManager.SetUserID(this.UserID())
	err := linkManager.AddGroup(req.Name)
	if err != nil {
		this.ResponseError404(err, "add group failed")
		return
	}
}

func (this *LinkController) RemoveGroup() {
	beego.Info("remove group")

	req := struct {
		ID int64
	}{}

	if err := json.Unmarshal(this.Ctx.Input.RequestBody, &req); err != nil {
		this.ResponseError400(err, "empty id")
		return
	}

	linkManager := models.NewLinkManager()
	linkManager.SetUserID(this.UserID())
	err := linkManager.RemoveGroup(req.ID)
	if err != nil {
		this.ResponseError404(err, "remove group failed")
		return
	}
}
func (this *LinkController) ListGroup() {

	res := struct {
		Groups []*models.TinyGroup
	}{}

	linkManager := models.NewLinkManager()
	linkManager.SetUserID(this.UserID())
	groups, err := linkManager.AllGroups()
	if err != nil {
		this.ResponseError400(err, "fetch groups data")
		return
	}
	res.Groups = groups

	beego.Info("groups count =", len(res.Groups))

	this.Data["json"] = res
	this.ServeJson()
}

func (this *LinkController) ListGroupBasic() {

	res := struct {
		Groups []*models.Group
	}{}

	linkManager := models.NewLinkManager()
	linkManager.SetUserID(this.UserID())
	groups, err := linkManager.AllGroupsBasic()
	if err != nil {
		this.ResponseError400(err, "fetch groups basic data")
		return
	}
	res.Groups = groups

	beego.Info("groups count =", len(res.Groups))

	this.Data["json"] = res
	this.ServeJson()
}

func (this *LinkController) AddLinkToGroup() {
	beego.Info("add link to group")

	req := struct {
		GroupID int64
		LinkID  int64
	}{}

	if err := json.Unmarshal(this.Ctx.Input.RequestBody, &req); err != nil {
		this.ResponseError400(err, "empty ids")
		return
	}

	linkManager := models.NewLinkManager()
	linkManager.SetUserID(this.UserID())
	err := linkManager.AddLinkToGroup(to.Int64(req.GroupID), to.Int64(req.LinkID))
	if err != nil {
		this.ResponseError404(err, "add group failed")
		return
	}
}

func (this *LinkController) RemoveLinkFromGroup() {
	beego.Info("remove link from group")

	req := struct {
		LinkID int64
	}{}

	if err := json.Unmarshal(this.Ctx.Input.RequestBody, &req); err != nil {
		this.ResponseError400(err, "empty ids")
		return
	}

	linkManager := models.NewLinkManager()
	linkManager.SetUserID(this.UserID())
	err := linkManager.RemoveLinkFromGroup(to.Int64(req.LinkID))
	if err != nil {
		this.ResponseError404(err, "remove group failed")
		return
	}
}
