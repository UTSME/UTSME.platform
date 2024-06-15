#!/usr/bin/python

import boto3
import botocore
import subprocess
import datetime
import os

WIKI_PATH = "/path/to/wiki"
BACKUP_PATH = "/path/to/backup/to"
AWS_ACCESS_KEY = "access key"
AWS_SECRET_KEY = "secret key"
BUCKET_NAME = "bucket name"
BUCKET_KEY_PREFIX = "dokuwiki/"

TARGET_DIRS = ["conf", "data/attic", "data/media", "data/meta", "data/pages"]

dirs = [WIKI_PATH + "/" + d for d in TARGET_DIRS]
weekday = datetime.datetime.now().strftime("%a")
filename = "{}/wiki-{}.tar".format(BACKUP_PATH, weekday)
subprocess.call(["tar", "-cvf", filename] + dirs)
subprocess.call(["gzip", "-f", filename])
filename += ".gz"

s3 = boto3.resource("s3")

bucket = s3.Bucket(BUCKET_NAME)
exists = True

print(filename)

print(os.path.basename(filename))

try:
    s3.Object(BUCKET_NAME, BUCKET_KEY_PREFIX + os.path.basename(filename)).put(
        Body=open(filename, "rb")
    )

except botocore.exceptions.ClientError as e:
    # If a client error is thrown, then check that it was a 404 error.
    # If it was a 404 error, then the bucket does not exist.
    error_code = int(e.response["Error"]["Code"])
    if error_code == 404:
        exists = False
