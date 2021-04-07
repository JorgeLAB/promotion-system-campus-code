# Projeto 1º Etapa-CampusCode

## Aplicação de Gerenciamento de Coupons.
[![Coverage Status](https://coveralls.io/repos/github/JorgeLAB/promotion-system-campus-code/badge.svg?branch=main)](https://coveralls.io/github/JorgeLAB/promotion-system-campus-code?branch=main)
![](https://img.shields.io/github/issues/JorgeLAB/promotion-system-campus-code)
![](https://img.shields.io/github/license/JorgeLAB/promotion-system-campus-code)
![](https://img.shields.io/github/languages/code-size/JorgeLAB/promotion-system-campus-code)
#### Em Construção !!!

## Requisitos

**:warning:** Como usar o docker-compose?

- **🛠 Development mode**
    - :computer: [Linux Ubuntu LTS](https://ubuntu.com/download/desktop)
    - 🐳 [Docker](https://docs.docker.com/engine/installation/)
    - 🐳 [Docker Compose](https://docs.docker.com/compose/)
    - **💡 Tip:** [Docker- doc](https://docs.docker.com/)

## Instalação

### 🐳 Development Mode with Docker


Depois da instalação do docker e docker-compose, vá para a pasta raiz do projeto e execute:

```sh
docker-compose build
docker-compose up
```
A aplicação pode ser derrubada com **Control + C**.

Como acessar o container da aplicação, execute:

```sh
docker-compose run --rm app bash
```

🚀 A aplicação pode ser acessada em [localhost: 3000] (localhost: 3000)

## Problemas que podem ocorrer (GNU/LINUX)

➡️  A aplicação após ser derrubada pode ainda conter o **pid** do processo do server.

```sh
A server is already running. Check /home/user/Documents/promotion-system/tmp/pids/server.pid.
```
Solução, remova server.pid:

```sh
rm /home/user/Documents/promotion-system/tmp/pids/server.pid.
```

➡️ A aplicação pode dar error de permissão:
```
  Permission denied @ apply2files
```
Solução, dê permissão à sua aplicação, dentro da raiz de seu projeto digíte:

```sh
  sudo chown -R $USER:$USER .
```

## Referências

[1° Create docker-compose for Ruby on Rails](https://docs.docker.com/compose/rails/)
