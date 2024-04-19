#!/bin/bash

#We have to do two validations one is executing the node with root user

USERID=$(id -u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]
then
    echo -e "Please Connect To $R SUDO USER $N"
else
    echo -e "Connected To $G SUDO USER $N"
fi
