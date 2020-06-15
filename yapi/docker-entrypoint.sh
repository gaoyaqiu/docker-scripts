#! /bin/bash
set -e
set -x

cd ${VENDORS}

MY_PORT="${MY_PORT:=3000}"
MY_ACOUNT="${MY_ACOUNT:=yapi}"
MY_DB_SERVER="${MY_DB_SERVER:=127.0.0.1}"
MY_DB_NAME="${MY_DB_NAME:=yapi}"
MY_DB_PORT="${MY_DB_PORT:=27027}"
MY_USER="${MY_USER}"
MY_PASS="${MY_PASS}"
MY_AUTH="${MY_AUTH}"

function Print {
    date +"[%F %T] $*"
}

sed -i "s/MY_PORT/"${MY_PORT}"/g" ${HOME}/config.json
sed -i "s/MY_ACOUNT/"${MY_ACOUNT}"/g" ${HOME}/config.json
sed -i "s/MY_DB_SERVER/"${MY_DB_SERVER}"/g" ${HOME}/config.json
sed -i "s/MY_DB_NAME/"${MY_DB_NAME}"/g" ${HOME}/config.json
sed -i "s/MY_DB_PORT/"${MY_DB_PORT}"/g" ${HOME}/config.json
sed -i "s/MY_USER/"${MY_USER}"/g" ${HOME}/config.json
sed -i "s/MY_PASS/"${MY_PASS}"/g" ${HOME}/config.json
sed -i "s/MY_AUTH/"${MY_AUTH}"/g" ${HOME}/config.json

if [ ! -e "/home/install/init.lock" ]
then
    Print Install mongodb ...
    npm run install-server
    touch /home/install/init.lock
fi

node server/app.js