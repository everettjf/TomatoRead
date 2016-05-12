
cd /root/iOSBlog/

echo 'pull'
git pull
echo 'local3.5'
pyenv local 3.5.0 >> /root/log.txt
pyenv versions >> /root/log.txt

cd web
echo 'export'
python export.py >> /root/log.txt
python -V >> /root/log.txt
cd ..


echo 'local'
pyenv local 2.7.10 >> /root/log.txt
pyenv versions >> /root/log.txt
cd jianspider

echo 'crawl'
scrapy crawl jianshu >> /root/log.txt

cd ..


cd web
echo 'local'
pyenv local 3.5.0 >> /root/log.txt
pyenv versions >> /root/log.txt

echo 'git commit'
python gitcommit.py

cd ..
