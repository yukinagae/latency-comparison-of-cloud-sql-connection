import os
from flask import Flask, jsonify
import pymysql
import google.auth

from opencensus.ext.flask.flask_middleware import FlaskMiddleware
from opencensus.ext.stackdriver import trace_exporter as stackdriver_exporter
from opencensus.trace import config_integration
from opencensus.trace import samplers


app = Flask(__name__)

INTEGRATIONS = ["pymysql"]

_, project_id = google.auth.default()
exporter = stackdriver_exporter.StackdriverExporter(
    project_id=project_id
)
sampler = samplers.ProbabilitySampler(rate=1)
middleware = FlaskMiddleware(app, exporter=exporter, sampler=sampler)
config_integration.trace_integrations(INTEGRATIONS)

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_USER = os.getenv("DB_USER")


@app.route('/')
def hello_world():
    return 'Hello, World!'

@app.route('/liveness')
def liveness():
    return jsonify(status="OK", route="liveness")

@app.route('/readiness')
def readiness():
    conn = pymysql.connect(host=DB_HOST, port=3306, user=DB_USER, db='mysql')
    conn.close()
    return jsonify(status="OK", route="readiness")
