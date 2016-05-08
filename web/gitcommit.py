import os
import datetime

from envconfig import target_json_dir,target_markdown_dir


# Git
def commit_and_push(dir):
    print(dir)
    os.system('cd %s;git pull' % dir)
    os.system('cd %s;git add .' % dir)
    os.system('cd %s;git commit -m autocommit%s' % (dir, datetime.datetime.now().isoformat()))
    os.system('cd %s;git push origin master'% dir)

if __name__ == '__main__':
    commit_and_push(target_json_dir)
    commit_and_push(target_markdown_dir)
