# dingtalk-api-proxy

 > 基于node的钉钉api调用转发，解决本地无公网ip直接调用钉钉api提示“访问ip不在白名单之中”的问题。

 ## 一、项目背景

 由于钉钉api需要在“开发管理”中指定服务器出口ip，对于没有公网ip的nas等本地设备而言，调用api发送消息比较麻烦，所以有了此项目，此项目仅用于请求转发，不作其他任何用途。


 ### 注意，该服务需要部署在互联网，并在钉钉开发平台设置服务器ip白名单。


 ## 二、如何使用

 ### 1. 直接使用nodejs   
    
    
 ``` bash
 npm install
 node index.js
 ```

然后通过http://ipaddress:3000/xxx 访问即可，xxx替换为钉钉官方文档中的请求路径即可（比如：http://localhost:3000/chat/send ），请求参数同钉钉原接口。


### 2. 使用docker

```
docker pull ashshen/dingtalk-api-proxy
docker run -itd -p 3000:3000 --restart=unless-stopped ashshen/dingtalk-api-proxy:latest
```
然后通过http://ipaddress:3000/xxx 访问即可，xxx替换为钉钉官方文档中的请求路径即可（比如：http://localhost:3000/chat/send ），请求参数同钉钉原接口。


## 三、开放服务

> 你可以使用 http://free.2017017.xyz/ 这个地址的服务来进行测试（请求body大小限制了1MB），它并不会记录你的access_token，只做单纯的接口转发。


## 四、用法示例

### 1. 当nas用户ssh登录时，发送消息通知（添加 /etc/ssh/sshrc 内容如下）

``` bash
ACCESS_TOKEN_RES=$(curl --location --request GET 'https://oapi.dingtalk.com/gettoken?appkey=咻咻咻&appsecret=咻咻咻')
ACCESS_TOKEN=$(echo $ACCESS_TOKEN_RES | sed 's/,/\n/g' | grep 'access_token' | sed 's/:/\n/g' | grep -v 'access_token' | sed 's/"//g')
IP="$(echo $SSH_CONNECTION | cut -d " " -f 1)"
HOSTNAME='nas名称'
CHATID='咻咻咻'
NOW=$(date "+%D %T")

TEXT="### $HOSTNAME登录 \n - 登录用户: $USER \n - 登录IP: $IP \n - 登录时间: $NOW \n"

RES=$(curl -o /dev/null --silent --location --request POST "http://free.2017017.xyz/chat/send?access_token=${ACCESS_TOKEN}" --header "Content-Type: application/json" --data-raw '{"chatid": "'"${CHATID}"'","msg": {"msgtype": "markdown","markdown": {"title": "'"${HOSTNAME}"'登录","text": "### '"${HOSTNAME}"'登录 \n - 登录用户: '"${USER}"' \n - 登录IP: '"${IP}"' \n - 登录时间: '"${NOW}"' \n"}}}')
```