package tags

import (
	"github.com/everettjf/jiebago/analyse"
)

var DefaultTagExtracter analyse.TagExtracter

func init() {
	DefaultTagExtracter.LoadDictionary("dict.txt")
	DefaultTagExtracter.LoadUserDictionary("userdict.txt")
	DefaultTagExtracter.LoadIdf("idf.txt")
}
