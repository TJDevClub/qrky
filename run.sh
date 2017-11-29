#!/bin/bash

python $(dirname "${BASH_SOURCE[0]}")/qrky/manage.py runserver $PORT
