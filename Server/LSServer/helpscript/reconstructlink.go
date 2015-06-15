// reconstruct
// 1. links_url_map if not have
// 2. links_click_count if not have

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

	result, err := c.Hscan(models.KDBLinks, "", "", 1000)
	if err != nil {
		fmt.Printf("hscan failed:%v", err)
		return
	}

	for _, v := range result {
		fmt.Println("<<<<<<<processing>>>>>>>")
		//fmt.Println(v)

		var link models.Link
		err := v.As(&link)
		if err != nil {
			fmt.Printf("error unmarshal link %v\n", err)
			continue
		}

		if exist, err := c.Zexists(models.KDBLinksClickCount, link.ID); err == nil && !exist {
			err = c.Zset(models.KDBLinksClickCount, link.ID, 0)
			if err != nil {
				fmt.Printf("error zset links_click_count : %v", err)
				continue
			}
		}
		if exist, err := c.Hexists(models.KDBLinksURLMap, link.URL); err == nil && !exist {
			err = c.Hset(models.KDBLinksURLMap, link.URL, link.ID)
			if err != nil {
				fmt.Printf("error zset links_url_map : %v", err)
				continue
			}
		}
	}
}
