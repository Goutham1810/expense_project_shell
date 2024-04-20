#!/bin/bash

#We have to do two validations one is executing the node with root user

USERID=$(id -u)
TIMESTAMP=$(date +%F-%H-%M-%S)
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
LOGFILE=/tmp/$SCRIPT_NAME-$TIMESTAMP.log
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]
then
    echo -e "Please Connect To $R SUDO USER $N"
    exit 1;
else
    echo -e "Connected To $G SUDO USER $N"
fi

VALIDATE()
{
    if [ $1 -ne 0 ]
    then
        echo -e "The Action $2 $R Failed $N"
        exit 1;
    else
        echo -e "The Action $2 $G SUCCESS $N"
    fi 
}

dnf install mysql-server -y &>>$LOGFILE
VALIDATE $? "Installation of Mysql Server"

systemctl enable mysqld &>>$LOGFILE
VALIDATE $? "Enabling mysqld service"

systemctl start mysqld &>>$LOGFILE
VALIDATE $? "Starting mysqld service"

mysql_secure_installation --set-root-pass ExpenseApp@1 &>>LOGFILE
VALIDATE $? "Setting up root password"
