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
echo "Please Enter Password:"
read -s mysql_root_password

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

dnf install nginx -y  &>>$LOGFILE
VALIDATE $? "Installing NGINX"

systemctl enable nginx &>>$LOGFILE
VALIDATE $? "Enabling NGINX"

systemctl start nginx &>>$LOGFILE
VALIDATE $? "Starting NGINX"

rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
VALIDATE $? "Downloading Front-end Code"

cd /usr/share/nginx/html
unzip /tmp/frontend.zip
VALIDATE $? "Extraction of Frontend"

cp 
systemctl restart backend &>>$LOGFILE
VALIDATE $? "Restarting Backend"
