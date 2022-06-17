from datetime import datetime

import pyodbc
from flask import Flask

server = '192.168.1.10'
uid = "turbimsa"
pwd = "110509_turbim"
dbname = "ARIKREAL"

conn = pyodbc.connect('Driver={SQL Server};'
                          f'Server={server};'   
                            f'Database={dbname};'
                            f'UID={uid};'
                            f'PWD={pwd}')

app = Flask(__name__)


@app.route('/')
def index():
    now = datetime.now()
    data = conn.execute("select * from V_AllItems").fetchall()
    print("time elapsed:", datetime.now() - now)
    # row separator is |,|
    # column separator is |-|
    return '|,|'.join(['|-|'.join(map(str, row)) for row in data])
    # return '\n'.join(['-'.join(map(str, row)) for row in data])
    # return '\n'.join(['-'.join(map(str, row)) for row in data])

app.run(debug=True,host="192.168.1.58",port=80)
