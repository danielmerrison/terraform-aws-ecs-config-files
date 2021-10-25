VERSION := $(shell cat ./version)
REPOSITORY := public.ecr.aws/t6i3k6z5/ecs-config-files-example
login:
#	aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin public.ecr.aws/t6i3k6z5/ecs-config-files-example
	aws ecr-public get-login-password --region us-east-1 | docker login --username AWS --password-stdin public.ecr.aws

build:
	docker build -t $(REPOSITORY):$(VERSION) .

push:
	docker push $(REPOSITORY):$(VERSION)

run:
	docker run -it --rm -e "ECS_FILES_EXAMPLE={\"contents\":\"VGhpcyBpcyBhIHNlY3JldCB0ZXN0IGZpbGUgZ2VuZXJhdGVkIGZyb20gYW4gc3NtIHBhcmFtZXRlcg==\",\"file\":\"/tmp/secret-test.txt\"}" $(REPOSITORY):$(VERSION)

run-connect:
	docker run -t --rm -e "ECS_FILES_EXAMPLE={\"contents\":\"VGhpcyBpcyBhIHNlY3JldCB0ZXN0IGZpbGUgZ2VuZXJhdGVkIGZyb20gYW4gc3NtIHBhcmFtZXRlcg==\",\"file\":\"/tmp/secret-test.txt\"}" $(REPOSITORY):$(VERSION) bash
