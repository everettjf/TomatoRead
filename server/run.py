
from mostlikelink import app
from mostlikelink.views import *
from mostlikelink.adminviews import *
from mostlikelink.apis import *
from mostlikelink.userapis import *
import os

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
