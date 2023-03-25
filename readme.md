## create structure
```
public/
    .data/
    www/
```

После создания для .data назначить пара 777, для www - 755.

## build
После выполнения `docker-compose build` в `bocker/` формируются изображения по формату  `#COMPOSE_PROJECT_NAME#_#service-name#:latest`, т.е. если COMPOSE_PROJECT_NAME=test, то будет сформировано 3 изображения:
- test_nginx:latest
- test_workspace:latest
- test_mysql:latest

Но хранилище докера отлично от хранилища кубера, поэтому надо поднять локальный регистр. Читай [https://microk8s.io/docs/registry-private](https://microk8s.io/docs/registry-private) .

Если ты используешь microk8s то он поднимается через `microk8s enable registry`, а так следуй мануалу.

Как только хранилище будет настроено можно воспользоваться `docker/build.sh` для сборки и отправки изображений.