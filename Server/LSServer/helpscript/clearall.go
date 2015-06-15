package main

import (
	"LSServer/models"
	"fmt"
)

func main() {

	c, err := models.DefaultDBPool.NewClient()
	if err != nil {
		fmt.Printf("db new client failed:%v", err)
		return
	}

	tagList, _ := c.Hlist("", "", 1000)
	for _, key := range tagList {
		c.Hclear(key)
	}

	zlist, _ := c.Zlist("", "", 1000)
	for _, key := range zlist {
		c.Zclear(key)
	}

	qlist, _ := c.Qlist("", "", 1000)
	for _, key := range qlist {
		c.Qclear(key)
	}

}
