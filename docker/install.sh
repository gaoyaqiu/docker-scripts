#!/bin/bash

# 安装docker
if ! [ -x "$(command -v docker)" ]; then
  echo '检测到 Docker 尚未安装，正在试图安装 Docker ...'

  if [ -x "$(command -v yum)" ]; then
    sudo yum install -y python3-pip yum-utils device-mapper-persistent-data lvm2
    sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    yum list docker-ce --showduplicates | sort -r
    sudo yum -y install docker-ce docker-ce-cli containerd.io
  else
    sudo apt-get update
    sudo dpkg --configure -a
    sudo apt-get install python3-pip apt-transport-https ca-certificates curl software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
    sudo apt-get update
    sudo apt-get install docker-ce
  fi

  # 启动docker和开机自启动
  sudo systemctl enable docker
  sudo systemctl start docker
fi

# 安装docker-compose
if ! [ -x "$(command -v docker-compose)" ]; then
    echo '检测到 Docker-Compose 尚未安装，正在试图安装 Docker-Compose ...'
    sudo curl -L "https://github.com/docker/compose/releases/download/1.25.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    sudo cp -rf /usr/local/bin/docker-compose /usr/bin/
fi

# check version
if [ -x "$(command -v docker)" -a -x "$(command -v docker-compose)" ]; then
  docker --version
  docker-compose --version
else
  if ! [ -x "$(command -v docker)" ]; then
    echo 'Docker 安装失败，请检测您当前的环境（或网络）是否正常。'
  fi
  if ! [ -x "$(command -v docker-compose)" ]; then
    echo 'Docker-Compose 安装失败，请检测您当前的环境（或网络）是否正常。'
  fi
fi