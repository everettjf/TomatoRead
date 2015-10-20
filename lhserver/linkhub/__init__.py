from flask import Flask
from flask.ext.seasurf import SeaSurf
from flask.ext.login import LoginManager
from mongoengine import connect

# App
app = Flask(__name__, instance_relative_config=True)
app.config.from_object('config')
app.config.from_pyfile('config.py')

# CSRF Protect
csrf = SeaSurf(app)

# Login Manager
login_manager = LoginManager()
login_manager.init_app(app)

# MongoDB
connect(app.config['DB_NAME'])


