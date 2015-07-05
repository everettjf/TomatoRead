package models

import (
	"LSServer/utils"
	"fmt"
	"github.com/seefan/to"
	"regexp"
	"sort"
	"time"
)

type LinkPropertyBasic struct {
	Title string // Short title
	URL   string // URL for this link
}
type LinkPropertyExtend struct {
	CreateTime int64    // timestamp when creating this link
	Tags       []string // Tags for this link (value for reserved)
}
type LinkPropertyData struct {
	ClickCount    int64 // Click count [store in zset("links_click_count")]
	LastClickTime int64
}

type Link struct {
	ID     int64 // Unique identifier
	Basic  LinkPropertyBasic
	Extend LinkPropertyExtend
	Data   LinkPropertyData
}
type TinyLink struct {
	ID    int64
	Basic LinkPropertyBasic
}
type TinyLinkWithClick struct {
	ID         int64
	Basic      LinkPropertyBasic
	ClickCount int64 // Click count [store in zset("links_click_count")]
}
type TinyLinkWithClickTime struct {
	ID            int64
	Basic         LinkPropertyBasic
	LastClickTime int64
}
type TinyTag struct {
	Name string
}

type Group struct {
	ID   int64
	Name string
}
type TinyGroup struct {
	Group
	Links []TinyLink
}

func NewLink(title string, url string) *Link {
	return &Link{
		0,
		LinkPropertyBasic{title, url},
		LinkPropertyExtend{time.Now().Unix(), []string{}},
		LinkPropertyData{0, 0},
	}
}

func ParseTagString(tagString string) []string {
	splitResult := regexp.MustCompile("(,| |，)").Split(tagString, -1)
	setTags := map[string]int{}
	for _, d := range splitResult {
		if len(d) == 0 {
			continue
		}
		setTags[d] = 0
	}

	var res []string
	for k, _ := range setTags {
		res = append(res, k)
	}

	return res
}

type LinkManager struct {
	userID int64
}

func (m *LinkManager) SetUserID(userID int64) {
	m.userID = userID
}
func (m *LinkManager) ParamReady() bool {
	if m.userID == 0 {
		return false
	}
	return true
}

func NewLinkManager() *LinkManager {
	return &LinkManager{}
}

func (m *LinkManager) Save(link *Link) error {
	if !m.ParamReady() {
		return fmt.Errorf("param not ready")
	}

	maxTitle := 30
	if len(link.Basic.Title) > maxTitle {
		link.Basic.Title = utils.SubString(link.Basic.Title, 0, 10)
		link.Basic.Title += "..."
	}

	c, err := DefaultDBPool.NewClient()
	if err != nil {
		return fmt.Errorf("db new client error %v", err)
	}
	defer c.Close()

	dbLinksCount := DBBuildKey(KDBUserLinksCount, m.userID)
	link.ID, err = c.Incr(dbLinksCount, 1)
	if err != nil {
		return fmt.Errorf("Link incr failed")
	}

	dbLinks := DBBuildKey(KDBUserLinks, m.userID)
	dbLinksExtend := DBBuildKey(KDBUserLinksExtend, m.userID)
	dbLinkUrlMap := DBBuildKey(KDBUserLinksURLMap, m.userID)
	dbLinksClickCount := DBBuildKey(KDBUserLinksClickCount, m.userID)
	dbLinksClickTime := DBBuildKey(KDBUserLinksClickTime, m.userID)
	dbLinksTags := DBBuildKey(KDBUserLinksTags, m.userID)

	// find same url
	urlHash := utils.GetMd5String(link.Basic.URL)
	existedID, err := c.Hget(dbLinkUrlMap, urlHash)
	if err == nil && existedID != "" {
		return fmt.Errorf("URL existed")
	}

	c.Hset(dbLinks, to.String(link.ID), &link.Basic)
	c.Hset(dbLinksExtend, to.String(link.ID), &link.Extend)

	c.Zset(dbLinksClickCount, to.String(link.ID), 0)
	c.Zset(dbLinksClickTime, to.String(link.ID), time.Now().Unix())

	c.Hset(dbLinkUrlMap, urlHash, link.ID)
	for _, tag := range link.Extend.Tags {
		dbLinksTagMap := DBBuildKey(KDBUserLinksTagMap, m.userID, tag)
		c.Hset(dbLinksTagMap, to.String(link.ID), "")

		c.Hset(dbLinksTags, tag, 0) // value for reserved
	}

	return nil
}

func cloneLink(l *Link) *Link {
	c := *l
	return &c
}

func (m *LinkManager) TopClickLinks(n int64) ([]*TinyLinkWithClick, error) {
	if !m.ParamReady() {
		return nil, fmt.Errorf("param not ready")
	}
	c, err := DefaultDBPool.NewClient()
	if err != nil {
		return nil, fmt.Errorf("db new client error :%v", err)
	}
	defer c.Close()

	dbLinks := DBBuildKey(KDBUserLinks, m.userID)
	dbLinksClickCount := DBBuildKey(KDBUserLinksClickCount, m.userID)

	keys, scores, err := c.Zrscan(dbLinksClickCount, "", "", "", n)
	if err != nil {
		return nil, fmt.Errorf("links click count get failed :%v", err)
	}

	_, values, err := c.MultiHgetSlice(dbLinks, keys...)
	if err != nil {
		return nil, fmt.Errorf("links multiget failed :%v", err)
	}

	links := []*TinyLinkWithClick{}
	for i, l := range values {
		var link TinyLinkWithClick
		l.As(&link.Basic)

		link.ID = to.Int64(keys[i])
		link.ClickCount = scores[i]
		links = append(links, &link)
	}

	return links, nil
}
func (m *LinkManager) TopNeverClickLinks(n int64) ([]*TinyLinkWithClickTime, error) {
	if !m.ParamReady() {
		return nil, fmt.Errorf("param not ready")
	}
	c, err := DefaultDBPool.NewClient()
	if err != nil {
		return nil, fmt.Errorf("db new client error :%v", err)
	}
	defer c.Close()

	dbLinks := DBBuildKey(KDBUserLinks, m.userID)
	dbLinksClickTime := DBBuildKey(KDBUserLinksClickTime, m.userID)

	keys, scores, err := c.Zscan(dbLinksClickTime, "", "", "", n)
	if err != nil {
		return nil, fmt.Errorf("links click count get failed :%v", err)
	}

	_, values, err := c.MultiHgetSlice(dbLinks, keys...)
	if err != nil {
		return nil, fmt.Errorf("links multiget failed :%v", err)
	}

	links := []*TinyLinkWithClickTime{}
	for i, l := range values {
		var link TinyLinkWithClickTime
		l.As(&link.Basic)

		link.ID = to.Int64(keys[i])
		link.LastClickTime = scores[i]
		links = append(links, &link)
	}

	return links, nil
}

func (m *LinkManager) All() ([]*TinyLink, error) {
	if !m.ParamReady() {
		return nil, fmt.Errorf("param not ready")
	}
	c, err := DefaultDBPool.NewClient()
	if err != nil {
		return nil, fmt.Errorf("db new client error :%v", err)
	}
	defer c.Close()

	dbLinks := DBBuildKey(KDBUserLinks, m.userID)
	result, err := c.Hscan(dbLinks, "", "", 100)
	if err != nil {
		return nil, fmt.Errorf("links scan failed : %v", err)
	}

	links := []*TinyLink{}
	for k, l := range result {
		var link TinyLink
		l.As(&link.Basic)

		link.ID = to.Int64(k)
		links = append(links, &link)
	}

	return links, nil
}

func (m *LinkManager) AllTags() ([]*TinyTag, error) {
	if !m.ParamReady() {
		return nil, fmt.Errorf("param not ready")
	}
	c, err := DefaultDBPool.NewClient()
	if err != nil {
		return nil, fmt.Errorf("db new client error :%v", err)
	}
	defer c.Close()

	dbLinksTags := DBBuildKey(KDBUserLinksTags, m.userID)
	result, err := c.Hscan(dbLinksTags, "", "", 500)
	if err != nil {
		return nil, fmt.Errorf("linkstags scan failed : %v", err)
	}

	tags := []*TinyTag{}
	for k, _ := range result {
		tags = append(tags, &TinyTag{k})
	}

	return tags, nil
}

func (m *LinkManager) Find(id int64) (*Link, error) {
	if !m.ParamReady() {
		return nil, fmt.Errorf("param not ready")
	}
	c, err := DefaultDBPool.NewClient()
	if err != nil {
		return nil, fmt.Errorf("new db client failed : %v", err)
	}
	defer c.Close()

	dbLinks := DBBuildKey(KDBUserLinks, m.userID)
	dbLinksExtend := DBBuildKey(KDBUserLinksExtend, m.userID)
	dbLinksClickCount := DBBuildKey(KDBUserLinksClickCount, m.userID)
	dbLinksClickTime := DBBuildKey(KDBUserLinksClickTime, m.userID)

	link := &Link{}
	link.ID = id
	result, err := c.Hget(dbLinks, to.String(id))
	if err != nil {
		return nil, fmt.Errorf("db hget failed : %v", err)
	}
	err = result.As(&link.Basic)
	if err != nil {
		return nil, fmt.Errorf("marshel failed : %v", err)
	}

	result, err = c.Hget(dbLinksExtend, to.String(id))
	if err == nil {
		err = result.As(&link.Extend)
	}

	link.Data.ClickCount, _ = c.Zget(dbLinksClickCount, to.String(link.ID))
	link.Data.LastClickTime, _ = c.Zget(dbLinksClickTime, to.String(link.ID))
	return link, nil
}

func (m *LinkManager) Click(id int64) (int64, error) {
	if !m.ParamReady() {
		return 0, fmt.Errorf("param not ready")
	}

	c, err := DefaultDBPool.NewClient()
	if err != nil {
		return 0, fmt.Errorf("new db client failed : %v", err)
	}
	defer c.Close()

	dbLinksClickCount := DBBuildKey(KDBUserLinksClickCount, m.userID)
	dbLinksClickTime := DBBuildKey(KDBUserLinksClickTime, m.userID)
	count, err := c.Zincr(dbLinksClickCount, to.String(id), 1)
	c.Zset(dbLinksClickTime, to.String(id), time.Now().Unix())

	return count, err
}

func (m *LinkManager) Trash(id int64) error {
	if !m.ParamReady() {
		return fmt.Errorf("param not ready")
	}

	c, err := DefaultDBPool.NewClient()
	if err != nil {
		return fmt.Errorf("new db client failed : %v", err)
	}
	defer c.Close()

	link, err := m.Find(id)
	if err != nil {
		return fmt.Errorf("can not find this link : %v", err)
	}

	dbLinks := DBBuildKey(KDBUserLinks, m.userID)
	dbLinksExtend := DBBuildKey(KDBUserLinksExtend, m.userID)
	dbLinkUrlMap := DBBuildKey(KDBUserLinksURLMap, m.userID)
	dbLinksClickCount := DBBuildKey(KDBUserLinksClickCount, m.userID)
	dbLinksTrash := DBBuildKey(KDBUsersLinksTrash, m.userID)
	dbLinksClickTime := DBBuildKey(KDBUserLinksClickTime, m.userID)

	c.Qpush(dbLinksTrash, link.Basic.URL)

	for _, tag := range link.Extend.Tags {
		dbLinksTagMap := DBBuildKey(KDBUserLinksTagMap, m.userID, tag)
		c.Hdel(dbLinksTagMap, to.String(link.ID))
	}

	c.Hdel(dbLinks, to.String(link.ID))
	c.Hdel(dbLinksExtend, to.String(link.ID))
	c.Zdel(dbLinksClickCount, to.String(link.ID))
	c.Zdel(dbLinksClickTime, to.String(link.ID))

	urlHash := utils.GetMd5String(link.Basic.URL)
	c.Hdel(dbLinkUrlMap, urlHash)

	return err
}

func (m *LinkManager) AddGroup(name string) error {
	if !m.ParamReady() {
		return fmt.Errorf("param not ready")
	}

	c, err := DefaultDBPool.NewClient()
	if err != nil {
		return fmt.Errorf("new db client failed : %v", err)
	}
	defer c.Close()

	dbUserLinksGroupCount := DBBuildKey(KDBUserLinksGroupCount, m.userID)
	groupID, _ := c.Incr(dbUserLinksGroupCount, 1)
	if err != nil {
		return fmt.Errorf("incr failed")
	}
	dbUserLinksGroup := DBBuildKey(KDBUserLinksGroups, m.userID)

	c.Hset(dbUserLinksGroup, to.String(groupID), name)

	fmt.Println("add group:", groupID, " - ", name)
	return nil
}

func (m *LinkManager) RemoveGroup(groupID int64) error {
	if !m.ParamReady() {
		return fmt.Errorf("param not ready")
	}

	c, err := DefaultDBPool.NewClient()
	if err != nil {
		return fmt.Errorf("new db client failed : %v", err)
	}
	defer c.Close()
	dbUserLinksGroup := DBBuildKey(KDBUserLinksGroups, m.userID)
	dbUserLinksGroupLinks := DBBuildKey(KDBUserLinksGroupLinks, m.userID, groupID)
	c.Hdel(dbUserLinksGroup, to.String(groupID))
	c.Hclear(dbUserLinksGroupLinks)
	return nil
}

func (m *LinkManager) AllGroups() ([]*TinyGroup, error) {
	if !m.ParamReady() {
		return nil, fmt.Errorf("param not ready")
	}

	c, err := DefaultDBPool.NewClient()
	if err != nil {
		return nil, fmt.Errorf("new db client failed : %v", err)
	}
	defer c.Close()

	dbUserLinksGroup := DBBuildKey(KDBUserLinksGroups, m.userID)
	result, err := c.Hscan(dbUserLinksGroup, "", "", 10)
	if err != nil {
		return nil, fmt.Errorf("hscan failed")
	}

	var keys []string
	for k := range result {
		keys = append(keys, k)
	}
	sort.Strings(keys)

	dbLinks := DBBuildKey(KDBUserLinks, m.userID)

	groups := []*TinyGroup{}
	for _, id := range keys {
		name := result[id]
		group := &TinyGroup{Group{to.Int64(id), name.String()}, nil}

		dbUserLinksGroupLinks := DBBuildKey(KDBUserLinksGroupLinks, m.userID, to.Int64(id))
		linkIDs, err := c.Hscan(dbUserLinksGroupLinks, "", "", 100)
		if err == nil {
			for linkID, _ := range linkIDs {
				linkValue, err := c.Hget(dbLinks, linkID)
				if err != nil {
					continue
				}
				var link TinyLink
				err = linkValue.As(&link.Basic)
				if err != nil {
					continue
				}
				link.ID = to.Int64(linkID)
				group.Links = append(group.Links, link)
			}
		}

		groups = append(groups, group)
	}
	return groups, nil
}

func (m *LinkManager) AllGroupsBasic() ([]*Group, error) {
	if !m.ParamReady() {
		return nil, fmt.Errorf("param not ready")
	}

	c, err := DefaultDBPool.NewClient()
	if err != nil {
		return nil, fmt.Errorf("new db client failed : %v", err)
	}
	defer c.Close()

	dbUserLinksGroup := DBBuildKey(KDBUserLinksGroups, m.userID)
	result, err := c.Hscan(dbUserLinksGroup, "", "", 10)
	if err != nil {
		return nil, fmt.Errorf("hscan failed")
	}
	var keys []string
	for k := range result {
		keys = append(keys, k)
	}
	sort.Strings(keys)

	groups := []*Group{}
	for _, id := range keys {
		name := result[id]
		group := &Group{to.Int64(id), name.String()}

		groups = append(groups, group)
	}
	return groups, nil
}

func (m *LinkManager) AddLinkToGroup(groupID int64, linkIDs ...int64) error {
	if !m.ParamReady() {
		return fmt.Errorf("param not ready")
	}
	m.RemoveLinkFromGroup(linkIDs...)

	c, err := DefaultDBPool.NewClient()
	if err != nil {
		return fmt.Errorf("new db client failed : %v", err)
	}
	defer c.Close()

	dbUserLinksLinkGroup := DBBuildKey(KDBUserLinksLinkGroup, m.userID)
	dbUserLinksGroupLinks := DBBuildKey(KDBUserLinksGroupLinks, m.userID, groupID)
	for _, linkID := range linkIDs {
		c.Hset(dbUserLinksGroupLinks, to.String(linkID), 0)
		c.Hset(dbUserLinksLinkGroup, to.String(linkID), to.String(groupID))
	}

	return nil
}

func (m *LinkManager) RemoveLinkFromGroup(linkIDs ...int64) error {
	if !m.ParamReady() {
		return fmt.Errorf("param not ready")
	}

	c, err := DefaultDBPool.NewClient()
	if err != nil {
		return fmt.Errorf("new db client failed : %v", err)
	}
	defer c.Close()

	dbUserLinksLinkGroup := DBBuildKey(KDBUserLinksLinkGroup, m.userID)
	for _, linkID := range linkIDs {
		groupID, err := c.Hget(dbUserLinksLinkGroup, to.String(linkID))
		if err != nil {
			continue
		}
		dbUserLinksGroupLinks := DBBuildKey(KDBUserLinksGroupLinks, m.userID, groupID.Int64())
		c.Hdel(dbUserLinksGroupLinks, to.String(linkID))
		c.Hdel(dbUserLinksLinkGroup, to.String(linkID))
	}

	return nil
}
