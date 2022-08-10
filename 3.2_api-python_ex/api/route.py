from crypt import methods
import linecache
from flask import Flask
from flask import jsonify
import os
import linecache
import random

app = Flask(__name__)

def create_file():
    randfile= open('data.txt','w')
    nums= 500
    num_base = 100

    for i in range(nums):
        line = str(random.uniform(-num_base,num_base)) + '\n'
        randfile.write(line)
    randfile.close()

def find(ind):
    data = open('data.txt', 'r')
    content= data.readlines()
    num = float(content[ind])
    return num 

def operation(op, num1, num2):
    if op == 'sum':
        result = num1 + num2 
    elif op == 'resta':
        result = num1 - num2
    elif op == 'div':
        result = num1 / num2
    elif op == 'mod':
        result = num1 % num2 
    elif op == 'mult':
        result = num1 * num2
    else: 
        print('ERROR')
    return result 


@app.route("/")
@app.route("/home")
def home():
    return "<h1>Hola Fer</h1>"

@app.route("/math/<int:x>/<int:y>/<string:op>", methods = ['GET'])
def math(x,y,op):
    num1 = find(x)
    num2 = find(y)
    result = operation(op,num1, num2)
    response= '%d %s %d = %d' %(num1,op,num2,result)
    return response

@app.route("/mathjson/<int:x>/<int:y>/<string:op>", methods = ['GET'])
def mathjson(x,y,op):
    num1 = find(x)
    num2 = find(y)
    result = operation(op,num1, num2)
    resp= {'num1': num1, 'num2': num2, 'result': result}
    response = jsonify(resp)
    response.status_code = 200
    response.headers['Link'] = 'http://localhost'
    return response

if __name__ == '__main__':
    create_file()
    app.run(debug=True, host='0.0.0.0', port=8000)

