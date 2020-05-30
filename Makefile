
def:
	./build.sh skitch plan
	./build.sh skitch package --version 0.0.1
	make install

up:
	docker-compose up -d

down:
	docker-compose down -v

ssh:
	docker exec -it postgres /bin/bash

install:
	$(MAKE) docker-install || $(MAKE) k8-install

docker-install:
	docker exec webinc-postgres /sql-extensions/install.sh

k8-install:
	$(eval POD_NAME := $(shell kubectl get pods -l app=postgres -n webinc -o jsonpath="{.items[*].metadata.name}"))
	kubectl exec -n webinc -it $(POD_NAME) /sql-extensions/install.sh

all:
	./build.sh skitch package --version 0.0.1
	./build.sh skitch plan

dump:
	skitch dump --deps --project dbs --path $(WEBINC_PATH)/services/packages/graphql-server-service/bootstrap/app.sql

deploy:
	@echo skitch deploy --recursive --createdb --yes --project dbs --database webinc-db
