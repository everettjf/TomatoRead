
pyenv local 3.5.0

cd ../web
python export.py


cd ../jianspider

scrapy crawl jianshu
