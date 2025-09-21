BASE_DOCKER_IMAGE=	burner-browser:latest

all:
	docker image build --rm -t "${BASE_DOCKER_IMAGE}" .

clean:
	-docker image remove "${BASE_DOCKER_IMAGE}"
