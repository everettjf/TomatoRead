
cd /root/iOSBlog/

date >> date.txt

git pull
pyenv local 3.5.0

cd web
python export.py
cd ..


pyenv local 2.7.10
cd jianspider

scrapy crawl jianshu

cd ..


cd web
pyenv local 3.5.0
python gitcommit.py

cd ..