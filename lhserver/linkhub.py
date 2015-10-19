from flask import Flask,request,session,g,redirect,url_for,abort,render_template,flash
from flask.ext.mongoengine import MongoEngine
import datetime
import hashlib


app = Flask(__name__)
app.config.from_object('config')

db = MongoEngine()


class User(db.Document):
    email = db.StringField(required=True, unique=True)
    blog_id = db.StringField(required=True, max_length=100, unique=True)
    password = db.StringField(required=True, max_length=100)


class Post(db.Document):
    meta = {'allow_inheritance': True}

    author = db.ReferenceField(User)
    title = db.StringField(required=True, max_length=100)
    tags = db.ListField(db.StringField(max_length=50))
    created_at = db.DateTimeField(default=datetime.datetime.now)


class LinkPost(Post):
    link_url = db.StringField(required=True, unique_with=['author', 'title'])
    click_events = db.ListField(db.DateTimeField(default=datetime.datetime.now))


class TextPost(Post):
    content = db.StringField(required=True, max_length=100, unique_with=['author', 'title'])


@app.route('/')
def index():
    return render_template('index.html')


@app.route('/u')
def user_list():
    return 'Hi'


@app.route('/u/<blog_id>')
def user_index(blog_id):
    return render_template('user_index.html')


@app.route('/register',methods=['GET', 'POST'])
def register():
    error = None
    if request.method == 'POST':
        user = User()
        user.email = request.form['email']
        user.password = request.form['password']

        user.blog_id = hashlib.md5(user.email).hexdigest()
        try:
            user.save()
            flash('Register succeed')
            return redirect(url_for('user_index', blog_id=user.blog_id))
        except db.NotUniqueError, err:
            error = 'Save error (Email existed) :' + err.message
        except db.OperationError, err:
            error = 'Save error : ' + err.message

    return render_template('register.html', error=error)


@app.route('/login')
def login():
    return 'login'


@app.route('/logout')
def logout():
    return 'logout'

# AddLink
# ClickLink
# UpdateLink
#

if __name__ == '__main__':
    app.run()

