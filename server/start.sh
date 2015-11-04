gunicorn mostlikelink:app -p rocket.pid -b 0.0.0.0:80 -D
cat rocket.pid