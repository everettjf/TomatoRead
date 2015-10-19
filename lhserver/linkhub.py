from flask import Flask,request,session,g,redirect,url_for,abort,render_template,flash
from flask.ext.seasurf import SeaSurf
from flask.ext.login import LoginManager, login_required, login_user, logout_user
from mongoengine import connect,errors
from form import form
from model import model
import hashlib


# App
app = Flask(__name__)
app.config.from_object('config')

# CSRF Protect
csrf = SeaSurf(app)

# Login Manager
login_manager = LoginManager()
login_manager.init_app(app)

# MongoDB
connect(app.config['DB_NAME'])


@login_manager.user_loader
def load_user(user_id):
    users = model.User.objects(id=user_id)
    if len(users) == 0:
        return None
    return users[0]


# Routes
@app.route('/')
def index():
    return render_template('index.html')


@app.route('/u')
@login_required
def user_list():
    return 'Hi'


@app.route('/u/<blog_id>')
@login_required
def user_index(blog_id):
    return render_template('user_index.html')


@app.route('/register', methods=['GET', 'POST'])
def register():
    error = None
    if request.method == 'POST':
        user = model.User()
        user.email = request.form['email']
        user.password = request.form['password']

        user.blog_id = hashlib.md5(user.email).hexdigest()
        try:
            user.save()
            flash('Register succeed')
            return redirect(url_for('login'))
        except errors.NotUniqueError, err:
            error = 'Save error (Email existed) :' + err.message
        except errors.OperationError, err:
            error = 'Save error : ' + err.message

    return render_template('register.html', error=error)


@app.route('/login', methods=['GET', 'POST'])
def login():
    login_form = form.LoginForm(request.form)
    if request.method == 'POST' and login_form.validate():
        users = model.User.objects(email=login_form.email.data,
                           password=login_form.password.data)
        if len(users) > 0:
            user = users[0]
            login_user(user)

            flash('Logged in successfully.')
            return redirect(url_for('user_index', blog_id=user.blog_id))
        else:
            flash('Password or email incorrect')

    return render_template('login.html', form=login_form)


@app.route('/logout')
@login_required
def logout():
    logout_user()
    return redirect(url_for('login'))

# AddLink
# ClickLink
# UpdateLink
#

if __name__ == '__main__':
    app.run()

