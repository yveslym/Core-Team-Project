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
mongo = MongoClient('localhost', 27017)
app.db = mongo.movie-preview
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
