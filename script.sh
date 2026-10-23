#!/usr/bin/env bash
grep -i "error" /var/log/syslog > report.txt
