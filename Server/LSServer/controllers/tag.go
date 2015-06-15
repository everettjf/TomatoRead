package controllers

import (
	"LSServer/utils/tags"
	"encoding/json"
	"github.com/astaxie/beego"
	"github.com/everettjf/goquery"
)

type TagController struct {
	BaseController
}

func extractTags(sentence string) []string {
	t := tags.DefaultTagExtracter

	var res []string
	segments := t.ExtractTags(sentence, 5)
	for _, segment := range segments {
		res = append(res, segment.Text())
	}
	return res
}
func ExtractTagsByArray(sentences ...string) []string {
	setTags := map[string]int{}
	for _, sentence := range sentences {
		tags := extractTags(sentence)
		for _, tag := range tags {
			setTags[tag] = 0
		}
	}
	tags := []string{}
	for tag, _ := range setTags {
		tags = append(tags, tag)
	}
	return tags
}

func extractHtmlTitle(url string) (string, error) {
	page, err := goquery.ParseUrl(url)
	if err != nil {
		return "", err
	}
	title := page.Find("title").Text()
	return title, nil
}

// req: post
//		/tag/extract {"Title":"baidu","URL":"http://www.baidu.com"}
// res:
//		["baidu","www","http","com"]
func (this *TagController) ExtractTags() {
	beego.Info("extract tags")

	req := struct {
		Title string
		URL   string
	}{}

	if err := json.Unmarshal(this.Ctx.Input.RequestBody, &req); err != nil {
		this.ResponseError400(err, "empty title or url")
		return
	}

	tags := ExtractTagsByArray(req.Title, req.URL)

	this.Data["json"] = tags
	this.ServeJson()
}

// req: post
// 		/tag/extracttitletags {"URL":"http://www.baidu.com"}
// res:
// 		{"Title":"xxx","Tags":["tag1","tag2","tag3"]}
func (this *TagController) ExtractTitleTags() {
	beego.Info("extract title tags")

	req := struct {
		URL string
	}{}

	if err := json.Unmarshal(this.Ctx.Input.RequestBody, &req); err != nil {
		this.ResponseError400(err, "empty url")
		return
	}

	res := struct {
		Title string
		Tags  []string
	}{}
	res.Title, _ = extractHtmlTitle(req.URL)
	res.Tags = ExtractTagsByArray(res.Title, req.URL)

	this.Data["json"] = res
	this.ServeJson()
}
