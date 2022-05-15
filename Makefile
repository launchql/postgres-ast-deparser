
def:
	./build.sh lql plan
	./build.sh lql package
	make install

up:
	docker-compose up -d

down:
	docker-compose down -v

ssh:
	docker exec -it launchql-ast-postgres /bin/bash

install:
	$(MAKE) docker-install || $(MAKE) k8-install

dinstall:
	$(MAKE) docker-install

docker-install:
	docker exec launchql-ast-postgres /sql-bin/install.sh

k8-install:
	$(eval POD_NAME := $(shell kubectl get pods -l app=postgres -n webinc -o jsonpath="{.items[*].metadata.name}"))
	kubectl exec -n webinc -it $(POD_NAME) /sql-bin/install.sh

dump:
	lql dump --deps --project dbs --path dump.sql

seed:
	createdb launchql
	lql deploy --recursive --database launchql --yes --project ast

deploy:
	@echo lql deploy --recursive --createdb --yes --project ast --database launchql-db

ast:
	@cd packages/ast && lql package 
	$(MAKE) install
