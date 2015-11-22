# coding=utf-8

from snowslink import app
from snowslink.views import *
from snowslink.adminviews import *
from snowslink.apis import *
from snowslink.userapis import *
import os

if __name__ == '__main__':
    if os.environ.get('SNOWSLINK_PRODUCTION') is not None:
        app.run(host='0.0.0.0', port=80)
    else:
        app.run(host='0.0.0.0', port=5000)
