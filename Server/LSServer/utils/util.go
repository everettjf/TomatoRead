package utils

import (
	"crypto/md5"
	"crypto/rand"
	"encoding/base64"
	"encoding/hex"
	"encoding/json"
	"io"
)

func GetMd5String(s string) string {
	h := md5.New()
	h.Write([]byte(s))
	return hex.EncodeToString(h.Sum(nil))
}

func NewGuid() string {
	b := make([]byte, 48)

	if _, err := io.ReadFull(rand.Reader, b); err != nil {
		return ""
	}
	return GetMd5String(base64.URLEncoding.EncodeToString(b))
}

func ToJson(value interface{}) string {
	if bs, err := json.Marshal(value); err == nil {
		return string(bs)
	}
	return "marshal failed."
}

func JsonAs(jsonString string, value interface{}) error {
	err := json.Unmarshal([]byte(jsonString), value)
	return err
}
func SubString(str string, begin, length int) (substr string) {
	// 将字符串的转换成[]rune
	rs := []rune(str)
	lth := len(rs)

	// 简单的越界判断
	if begin < 0 {
		begin = 0
	}
	if begin >= lth {
		begin = lth
	}
	end := begin + length
	if end > lth {
		end = lth
	}

	// 返回子串
	return string(rs[begin:end])
}

func MakePassword(password string) string {
	t := GetMd5String(password)
	x := "everettjf" + t + "234@#$%(KJ" + t
	return GetMd5String(x)
}
