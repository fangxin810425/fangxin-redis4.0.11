#!/bin/sh
nohup  supervisord  -n -c /etc/supervisord.conf &
