# microblog
Работа выполнена в рамках курсовой работы на тему "Сервис микроблоггинга". В процессе разработки необходимо было использовать СУБД PostgreSQL.
Логика приложения содержится в хранимых процедурах.

## Начало работы
Для начала скопируйте данный репозиторий:

```
git clone https://github.com/DenisTsvetkov/microblog.git
```

Перейдите в каталог с проектом:

```
cd microblog
```

Установите зависимости:

```
npm install or yarn install
```


Импортируйте содержимое файла базы данных PostgreSQL:

```
psql -U <UserName> microblog
\i dump_microblog.sql
```

В файле ./config/Db.js добавьте свои имя пользователя и пароль от базы данных PostgreSQL:

```javascript
const cn = {
    host: 'localhost',
    port: 5432,
    database: 'microblog',
    user: 'YOUR_USERNAME',
    password: 'YOUR_PASSWORD' //password here
};
```

## Запуск
Для запуска приложения перейдите в каталог с проектом и введите:

```
node app
```

Для запуска проекта вместе с запуском Gulp используйте команду:

```
gulp
```

