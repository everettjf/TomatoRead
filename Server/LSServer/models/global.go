package models

import (
	"github.com/astaxie/beego"
	"github.com/everettjf/gossdb"
)

// Global
var (
	DefaultDBPool *gossdb.Connectors
)

func init() {
	ip := beego.AppConfig.String("ssdbip")
	port, err := beego.AppConfig.Int("ssdbport")
	if ip == "" {
		ip = "127.0.0.1"
	}
	if port == 0 {
		port = 8888
	}

	DefaultDBPool, err = gossdb.NewPool(&gossdb.Config{
		Host: ip,
		Port: port,
	})
	if err != nil {
		beego.Error("db pool new failed :%v", err)
		return
	}
	gossdb.Encoding = true
}
