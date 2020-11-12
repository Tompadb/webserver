#!/bin/bash

FILE="./webserver/index.html"
PORT=$1
PROCESS_ID="/tmp/FILE-$PORT-$$"


function check_figlet() {
     if ! command -v figlet 
     then
       echo ""
       echo "You don't have figlet installed, please install it."
       echo "" 
     exit 1    
     fi
}

function check_file_port() {

     until [ -n "$PORT" ]  ; do
         echo "Port number: "
         read PORT 
     done
}

function check_file() {
     if [ -e $FILE ] 
     then
       echo ""
     else
       sudo mkdir ./webserver/
       sudo touch ./webserver/index.html
       sudo chmod a+rwx ./webserver/index.html
       sudo echo "<html>" >> ./webserver/index.html
       sudo echo "<body>" >> ./webserver/index.html
       sudo echo "<h1>Server is running</h1>" >> ./webserver/index.html
       sudo echo "</body>" >> ./webserver/index.html
       sudo echo "</html>" >> ./webserver/index.html 
     fi
}

function start() {
     clear
     figlet -w 120 -k -f slant "localhost: ${PORT}"
     echo "-----------------------------------------------------"
     echo -ne "Started at: $(date "+%dth %B, %Y  %H:%M") \n"
     echo "-----------------------------------------------------"

     echo "File: ${FILE} | Port: ${PORT} | Pid: $$"
     echo -ne "-----------------------------------------------------\r\n\r\n"
     
     echo $$ > $PROCESS_ID
}

check_figlet
check_file_port
check_file
start

while true; do (echo -e 'HTTP/1.1 200 OK\r\n'; cat $FILE;) | nc -lp $PORT; done