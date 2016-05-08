import os

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
