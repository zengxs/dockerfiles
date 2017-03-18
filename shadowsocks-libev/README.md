# shadowsocks-libev
[shadowsocks-libev](https://github.com/shadowsocks/shadowsocks-libev)
是一个轻量级的安全 socks5 代理软件。

> Dockerfile 来自 shadowsocks-libev 官方仓库。

## 如何使用
### 命令行运行
```sh
$ docker run -d -e METHOD=aes-128-cfb -e PASSWORD=a8z78FyrPRD7 -p 8388:8388 --restart always matsuz/shadowsocks-libev
$ docker ps
```

> :warning: 你可以[点击这里]生成一个随机密码。

### 使用 docker-compose 管理
使用 [docker-compose](https://github.com/docker/compose) 可以非常方便的管理 Docker 容器。

这是一个简单的 `docker-compose.yml` 文件示例：
```yml
shadowsocks:
  image: matsuz/shadowsocks-libev
  ports:
    - "8388:8388/tcp"
    - "8388:8388/udp"
  environment:
    - METHOD=aes-128-cfb
    - PASSWORD=a8z78FyrPRD7
  restart: always
```

`environment` 中可以配置加密算法与密码。

> 如果你想要使用自己构建的 Docker 镜像，需要修改配置中的 `image` 项。

推荐创建一个目录树来管理 docker-compose 配置：
```sh
$ mkdir -p ~/fig/shadowsocks/
$ cd ~/fig/shadowsocks/
$ curl -sSLO https://github.com/matsuz/dockerfiles/raw/master/shadowsocks-libev/docker-compose.yml
$ docker-compose up -d
$ docker-compose ps
```

> :warning: 运行之前记得修改加密算法与密码。

## 安装 Docker
```sh
$ curl -sSL https://get.docker.com/ | sh
$ docker --version
```

如果使用 Ubuntu，则可以使用如下安装方式：
```sh
$ sudo apt install docker.io
```

## 