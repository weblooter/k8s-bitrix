## create structure
```
public/
    .data/
    www/
```

После создания для .data назначить пара 777, для www - 644.

## build
После выполнения `docker-compose build` в `bocker/` формируются изображения по формату  `#COMPOSE_PROJECT_NAME#_#service-name#:latest`, т.е. если COMPOSE_PROJECT_NAME=test, то будет сформировано 3 изображения:
- test_nginx:latest
- test_workspace:latest
- test_mysql:latest

Как итог для работы кубера необходимо будет подключиться к этим изображениям.