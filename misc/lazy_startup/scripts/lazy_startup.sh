#!/bin/bash

export $(dbus-launch)
/usr/bin/python3 /home/agsousa/config_aggs/lazy_startup.py
