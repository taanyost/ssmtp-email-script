#!/bin/bash
#statusmail1 uses content generated by statusmail2 to send system administrator a daily status email
#crontab file should run statusmail1 at daily interval
sudo bash /scripts/statusmail2.sh | ssmtp account@email.tld
