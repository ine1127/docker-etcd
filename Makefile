## Variable
CONTAINER_NAME = docker-etcd
VERSION = 2.3.7
IMAGE_TAG = octbr.ine/${CONTAINER_NAME}
##

all: build

help:
	@echo ""
	@echo "-- Help Menu"
	@echo ""
	@echo "   1. make build        - build the ${CONTAINER_NAME} image"
	@echo "   2. make boot         - run ${CONTAINER_NAME}"
	@echo "   3. make debug        - run /bin/sh ${CONTAINER_NAME}"
	@echo "   4. make quickstart   - build & boot ${CONTAINER_NAME}"
	@echo "   5. make start        - start ${CONTAINER_NAME}"
	@echo "   6. make stop         - stop ${CONTAINER_NAME}"
	@echo "   7. make remove       - remove ${CONTAINER_NAME} container"
	@echo "   8. make erase        - remove ${CONTAINER_NAME} image"
	@echo "   9. make purge        - stop & remove & erase ${CONTAINER_NAME}"
	@echo "  10. make login        - login ${CONTAINER_NAME} container"
	@echo "  11. make logs         - watch console ${CONTAINER_NAME}"
	@echo ""

build:
	@docker build -t ${IMAGE_TAG}:${VERSION} .

boot:
	@cp -ip etcd.conf /etc/etcd
	@echo "Running ${CONTAINER_NAME} image..."
	@docker run -d --restart=always \
		--name ${CONTAINER_NAME} \
		-p 2379:2379 -p 2380:2380 \
		-v /var/lib/etcd:/var/lib/etcd:Z \
		-v /etc/etcd:/etc/etcd:Z \
		${IMAGE_TAG}:${VERSION}
	@echo "Booted docker-etcd container!"

debug:
	@docker run -it --rm --name ${CONTAINER_NAME} --entrypoint=/bin/sh ${IMAGE_TAG}:${VERSION}

quickstart: build boot

start:
	@echo -e "Starting ${CONTAINER_NAME} container..."
	@docker start ${CONTAINER_NAME}

stop:
	@echo "Stopping ${CONTAINER_NAME} container..."
	@docker stop ${CONTAINER_NAME}

remove:
	@echo "Removeing stopped container..."
	@docker rm ${CONTAINER_NAME}

erase:
	@echo "Removing ${CONTAINER_NAME} image..."
	@docker rmi ${IMAGE_TAG}:${VERSION}

purge: stop remove erase
	@echo "Purging container..."

login:
	@echo "Login ${CONTAINER_NAME}..."
	@echo "[user]: root"
	@docker exec -it ${CONTAINER_NAME} sh

logs:
	@docker logs ${CONTAINER_NAME}
