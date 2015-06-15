package mail

import (
	"net/smtp"
	"strings"
)

type Sender struct {
	SmtpUser     string // e.g. hello@163.com
	SmtpPassword string // e.g. helloworld
	SmtpHost     string // e.g. smtp.163.com:25
}

// mailType : "html" or "text"
func (this *Sender) Send(to, subject, body, mailType string) error {
	hp := strings.Split(this.SmtpHost, ":")
	auth := smtp.PlainAuth("", this.SmtpUser, this.SmtpPassword, hp[0])

	var content_type string
	if mailtype == "html" {
		content_type = "Content-Type: text/" + mailtype + "; charset=UTF-8"
	} else {
		content_type = "Content-Type: text/plain" + "; charset=UTF-8"
	}

	msg := []byte("To: " + to + "\r\n" +
		"From: " + user + "<" + user + ">" + "\r\n" +
		"Subject: " + subject + "\r\n" +
		content_type + "\r\n\r\n" +
		body)
	send_to := strings.Split(to, ";")
	return smtp.SendMail(host, auth, user, send_to, msg)
}

func (this *Sender) SendText(to, subject, body string) error {
	return this.Send(to, subject, body, "text")
}
func (this *Sender) SendHtml(to, subject, body string) error {
	return this.Send(to, subject, body, "html")
}
