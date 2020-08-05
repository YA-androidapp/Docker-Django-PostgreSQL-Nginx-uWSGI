init:
	rm -rf backend/*
	docker-compose run web django-admin startproject mysite .
	echo "Update DATABASES, Locale, Timezone values in backend/mysite/settings.py and run 'make migrate'."

up:
	docker-compose up -d

migrate:
	docker-compose run web ./manage.py makemigrations
	docker-compose run web ./manage.py migrate
	docker-compose run web ./manage.py createsuperuser
	@make up
	echo "Update the STATIC_ROOT value in backend/mysite/settings.py and run 'make collect-static'."

collect-static:
	docker-compose run web ./manage.py collectstatic

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
