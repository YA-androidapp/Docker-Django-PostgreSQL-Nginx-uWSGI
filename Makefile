init:
	rm -rf backend/*
	docker-compose run web django-admin startproject mysite .
	cp ./backend/mysite/settings.py ./backend/mysite/settings.py.old
	cat ./backend/mysite/settings.py.old | sed "s/'ENGINE': 'django.db.backends.sqlite3',/'ENGINE': 'django.db.backends.postgresql',/g" | sed "s/'NAME': BASE_DIR \/ 'db.sqlite3',/'NAME': 'postgres', 'USER': 'postgres', 'PASSWORD': 'postgres', 'HOST': 'db', 'PORT': 5432,/g" | sed "s/LANGUAGE_CODE = 'en-us'/LANGUAGE_CODE = 'ja-jp'/g" | sed "s/TIME_ZONE = 'UTC'/TIME_ZONE = 'Asia\/Tokyo'/g" > ./backend/mysite/settings.py
	@make migrate

up:
	docker-compose up -d

collect-static:
	docker-compose run web ./manage.py collectstatic

migrate:
	docker-compose run web ./manage.py makemigrations
	docker-compose run web ./manage.py migrate
	docker-compose run web ./manage.py createsuperuser
	@make up
	echo "STATIC_ROOT = '/static'" >> ./backend/mysite/settings.py
	@make collect-static

create-app:
	docker-compose run web ./manage.py startapp myapp
	echo "Update the INSTALLED_APPS value in backend/mysite/settings.py."


db:
	docker-compose exec db bash
web:
	docker-compose exec web bash


build:
	docker-compose build --no-cache --force-rm
destroy:
	docker-compose down --rmi all --volumes
	rm -rf ./backend/*
destroy-volumes:
	docker-compose down --volumes
down:
	docker-compose down
logs:
	docker-compose logs
logs-watch:
	docker-compose logs --follow
ps:
	docker-compose ps
restart:
	@make down
	@make up
stop:
	docker-compose stop
