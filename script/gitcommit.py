import os
import datetime


def is_in_production():
    if 'IOSBLOGRUNMODE' in os.environ:
        RUNMODE = os.environ['IOSBLOGRUNMODE']
    else:
        RUNMODE = 'develop'

    return RUNMODE == 'production'

if is_in_production():
    target_json_dir = '/root/everettjf.github.com/app/blogreader/'
    target_markdown_dir = '/root/iOSBlog/'
else:
    target_json_dir = '/Users/everettjf/GitHub/everettjf.github.com/app/blogreader/'
    target_markdown_dir = '/Users/everettjf/GitHub/iOSBlog/'


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
