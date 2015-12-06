#!/bin/sh


aptitude update

# aptitude repository
aptitude install -y netselect-apt
netselect-apt
mv /etc/apt/sources.list /etc/apt/sources.list.org
mv sources.list /etc/apt/sources.list
aptitude update

# base
aptitude install -y vim screen iftop tcpdump

# openswitch (?)
#aptitude install -y bridge-utils

# 
#aptitude install lxc

# ncurses dialogs (!!!)
aptitude install -y lxc=0.8.0~rc1-8+deb7u1
