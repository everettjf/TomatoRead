
pyenv local 3.5.0

cd ./web
python export.py


pyenv local scrapy

scrapy crawl jianshu -o jianshu.json
