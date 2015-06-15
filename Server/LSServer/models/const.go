package models

import (
	"fmt"
)

// Database
const (

	// type  : hset
	// key   : userID
	// value : userDataJson
	// usage : 用户列表
	KDBUsers      = "users"
	KDBUserExtend = "users:extend"

	// type  : kv
	KDBUsersCount = "users.count"

	// type  : hset
	// key 	 : email
	// value : userID
	// usage : 实现检测email是否注册
	KDBUsersEmailMap = "users:email.map"

	// type  : hset
	// key	 : linkID
	// value : linkDataJson
	// usage : 存储链接数据，通过链接ID关联属性
	KDBUserLinks = "user:%d:links" // %d userID

	KDBUserLinksCount  = "user:%d:links.count"  // %d userID
	KDBUserLinksExtend = "user:%d:links.extend" // %d userID

	// type  : list
	// value : linkURL
	// usage : 用户删除链接的回收站
	KDBUsersLinksTrash = "user:%d:link.trash" // %d userID

	// type  : zset
	// key 	 : linkID
	// score : clickCount
	// usage : 存储链接点击次数，通过链接ID关联点击次数。实现按照点击次数排序。
	KDBUserLinksClickCount = "user:%d:links.click.count" // %d userID
	KDBUserLinksClickTime  = "user:%d:links.click.time"  // %d userID

	// type  : hset
	// key 	 : md5(linkURL)
	// value : linkID
	// usage : 存储链接URL与链接ID的关联。实现检测URL存在性。
	KDBUserLinksURLMap = "user:%d:links.url.map" // %d userID

	// type  : hset
	// key   : linkID
	// value : "" [reserved]
	// usage : 存储tag与链接的关联。实现通过tag查找链接。
	KDBUserLinksTagMap = "user:%d:links.tag.map:%s" // %d userID , %s tagName

	// usage : 存储用户所有tag
	// hset
	KDBUserLinksTags = "user:%d:links.tags" // %d userID

	// usage : 存储分组
	// hset  : id - groupName
	KDBUserLinksGroups = "user:%d:links.groups"
	// type : kv
	KDBUserLinksGroupCount = "user:%d:links.group.count"
	// usage : 存储分组链接ID
	// hset  : linkID - 0(reserved)
	KDBUserLinksGroupLinks = "user:%d:links.group:%d:links"

	// usage : 通过链接查找组
	// hset  : link - group
	KDBUserLinksLinkGroup = "user:%d:links.link.group"

	KDBPublicLinks              = "public:links.data"
	KDBPublicLinksClickCount    = "public:links.click.count"
	KDBPublicLinksURLMap        = "public:links.url.map"
	KDBPublicLinksTagMap        = "public:links.tag.map:%d"
	KDBPublicLinksGreetCount    = "public:links.greet.count"
	KDBPublicLinksDisgreetCount = "public:links.disgreet.count"
	KDBPublicLinksGreetUsers    = "public:link:%d:greet.users"
	KDBPublicLinksDisgreetUsers = "public:link:%d:disgreet.users"

	// type  : list
	// value : logJson
	KDBPublicLogs = "public:logs"
)

func DBBuildKey(keyFormatString string, a ...interface{}) string {
	return fmt.Sprintf(keyFormatString, a...)
}
