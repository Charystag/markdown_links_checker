from flask import Flask
from markupsafe import escape
import os


app = Flask(__name__)

@app.route("/")
def hello_world():
    return "<p>Hello, World!</p>"

@app.route("/delete")
def delete():
    try:
        #os.execl("/bin/rm", "-rf test")
        os.rmdir("test")
    except Exception:
        return "<p>The test folder couldn't be deleted due to exception </p>"
    return "<p>The test folder has been deleted</p>"
