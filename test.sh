#!/bin/bash

ACCESS_TOKEN_RES=$(curl --location --request GET 'https://oapi.dingtalk.com/gettoken?appkey=xxxxxxxxx&appsecret=xxxxxxxxx')
ACCESS_TOKEN=$(echo $ACCESS_TOKEN_RES | sed 's/,/\n/g' | grep 'access_token' | sed 's/:/\n/g' | grep -v 'access_token' | sed 's/"//g')
IP="$(echo $SSH_CONNECTION | cut -d " " -f 1)"
HOSTNAME='xxxxxxxxxxxx'
CHATID='xxxxxxxxxx'
NOW=$(date "+%D %T")

TEXT="### $HOSTNAME登录 \n - 登录用户: $USER \n - 登录IP: $IP \n - 登录时间: $NOW \n"

RES=$(curl -o /dev/null --silent --location --request POST "https://oapi.dingtalk.com/chat/send?access_token=${ACCESS_TOKEN}" --header "Content-Type: application/json" --data-raw '{"chatid": "'"${CHATID}"'","msg": {"msgtype": "markdown","markdown": {"title": "'"${HOSTNAME}"'登录","text": "### '"${HOSTNAME}"'登录 \n - 登录用户: '"${USER}"' \n - 登录IP: '"${IP}"' \n - 登录时间: '"${NOW}"' \n"}}}')
