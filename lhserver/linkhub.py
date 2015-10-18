from flask import Flask,request,session,g,redirect,url_for,abort,render_template,flash
from mongoengine import connect

app = Flask(__name__)
app.config.from_object('config')

connect('linkhub')


@app.route('/')
def index():
    return render_template('index.html')


@app.route('/register',methods=['GET','POST'])
def register():
    error = None
    if request.method == 'POST':
        pass

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

