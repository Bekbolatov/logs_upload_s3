#!/bin/bash


cp -rf /huyaks/conf/* /EFS/conf/.

exec /usr/bin/python -u scheduled_runner.py
