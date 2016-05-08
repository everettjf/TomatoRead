
git pull

pyenv local 3.5.0

cd ../web
python export.py


pyenv local 2.7.10
cd ../jianspider

scrapy crawl jianshu


cd ../web
pyenv local 3.5.0
python gitcommit.py