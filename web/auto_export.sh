
cd /root/iOSBlog/

echo 'pull'
git pull
echo 'local3.5'
pyenv local 3.5.0

cd web
echo 'export'
python export.py
cd ..


echo 'local'
pyenv local 2.7.10
cd jianspider

echo 'crawl'
scrapy crawl jianshu

cd ..


cd web
echo 'local'
pyenv local 3.5.0

echo 'git commit'
python gitcommit.py

cd ..
