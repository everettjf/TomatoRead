
git pull

pyenv local 3.5.0

cd ../web
python export.py


cd ../jianspider

scrapy crawl jianshu


cd ../script
pyenv local 3.5.0
python gitcommit.py