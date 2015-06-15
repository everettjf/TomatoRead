package models

import (
	"LSServer/utils"
	"fmt"
	"github.com/seefan/to"
	"time"
)

type User struct {
	ID          int64
	Email       string
	Password    string
	CreateTime  int64
	EmailStatus bool
}

func NewUser(email string, password string) *User {

	return &User{
		0, // should change to auto-incr id when save
		email,
		utils.MakePassword(password),
		time.Now().Unix(),
		false,
	}
}

type UserManager struct {
}

func NewUserManager() *UserManager {
	return &UserManager{}
}

func (this *UserManager) Save(user *User) error {
	c, err := DefaultDBPool.NewClient()
	if err != nil {
		return fmt.Errorf("db new client error %v", err)
	}
	defer c.Close()

	user.ID, err = c.Incr(KDBUsersCount, 1)
	if err != nil {
		return fmt.Errorf("User Incr failed")
	}

	// find same email
	emailHash := utils.GetMd5String(user.Email)
	existedID, err := c.Hget(KDBUsersEmailMap, emailHash)
	if err == nil && existedID != "" {
		return fmt.Errorf("Email existed")
	}

	// save
	c.Hset(KDBUsers, to.String(user.ID), user)
	c.Hset(KDBUsersEmailMap, emailHash, user.ID)

	return nil
}

func (this *UserManager) FindUser(email string) (*User, error) {
	c, err := DefaultDBPool.NewClient()
	if err != nil {
		return nil, fmt.Errorf("db new client error %v", err)
	}
	defer c.Close()

	existedID, err := c.Hget(KDBUsersEmailMap, utils.GetMd5String(email))
	if err != nil || existedID == "" {
		return nil, fmt.Errorf("Email not found")
	}

	result, err := c.Hget(KDBUsers, existedID.String())
	if err != nil {
		return nil, fmt.Errorf("User not found")
	}

	var user *User
	err = result.As(&user)
	if err != nil {
		return nil, fmt.Errorf("User marshel failed")
	}

	return user, nil
}
