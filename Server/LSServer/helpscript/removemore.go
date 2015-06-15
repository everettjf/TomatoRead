// remove special links
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
		//fmt.Println("after unmarshal")
		//fmt.Println(link)

		// remove in links
		if link.Title == "baidu" || link.URL == "http://www.baidu.com" {

			err = c.Hdel(models.KDBLinks, link.ID)
			if err != nil {
				fmt.Printf("links error del %v - %v\n", link.ID, err)
			}
			// remove in links_click_count
			err = c.Zdel(models.KDBLinksClickCount, link.ID)
			if err != nil {
				fmt.Printf("links_click_count error del %v - %v\n", link.ID, err)
			}

			err = c.Hdel(models.KDBLinksURLMap, link.URL)
			if err != nil {
				fmt.Printf("links_url_map error del %v - %v\n", link.ID, err)
			}
			fmt.Println("<<<end>>>")
		}
	}
}
