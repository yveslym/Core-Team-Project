from flask import Flask, request, make_response
from flask_restful import Resource, Api
from pymongo import MongoClient
from utils.mongo_json_encoder import JSONEncoder
from bson.objectid import ObjectId
import bcrypt
from mongoengine import *
import pdb
import uuid
from socket import *
from basicauth import decode

app = Flask(__name__)

MONGODB_URI = "mongodb://yveslym:1q2w3e4r@ds044887.mlab.com:44887/kalmoney-database
"
mongo = MongoClient(MONGODB_URI, connectTimeOutMS=30000)
app.db = mongo.users
rounds = app.bcrypt_rounds = 12
api = Api(app)

def user_auth(func):
        def wrapper(*args,**kwargs):
            auth_code = request.headers['authorization']
            email,password = decode(auth_code)
            user_dict = app.db.users.find_one({'email':email})
            if user_dict is not None:
                encoded_pw = password.encode('utf-8')
                if bcrypt.hashpw(encoded_pw,user_dict['password']) == user_dict['password']:
                    return func(*args, **kwargs)
                else:
                    return ({'error':'email or password incorect'},401,None)
            else:
                return({'error':'user does not exist'},400,None)
    return wrapper

class User(Resource):

    '''post request: method to create and add new user in the database'''
    def post(self):
        if request.json is not None:
            user = request.json
            password = user['password']
            encoded_password = password.encode('utf-8')
            encrypted_password = bcrypt.hashpw(encoded_password, bcrypt.gensalt(rounds))
            user['password'] = encrypted_password
            user_collect = app.db.users
            user_collect.insert_one(user)
            return ({'message':'new user as been added'}, 201, None)
        else:
            return ({'error':"new user doesn't get registered"}, 400, None)

    '''method to get user info and when user login'''
    @user_auth
    def get(self):
        auth = request.authorization
        user_col = app.db.users
        user = user_col.find_one({'email':auth.username})
        user.pop('password')
        return (user, 200, None)

    '''method to delete user from database'''
    @user_auth
    def delete(self):
        auth_code = request.headers['authorization']

        auth = request.authorization
        user_dict = app.db.users.find_one({'email':auth.username})
        app.db.users.remove(user_dict)
        return ({'delete':'the user '+ auth.username+ ' as been deleted'}, 200, None)
    '''method to update user info'''
    @user_auth
    def patch(self):

        user = request.json
        user_collect = app.db
        #if user['username'] is not None:





if __name__ == '__main__':

    # Turn this on in debug mode to get detailled information about request
    # related exceptions: http://flask.pocoo.org/docs/0.10/config/
    app.config['TRAP_BAD_REQUEST_ERRORS'] = True
    app.run(debug=True)







    #patch Request
