DOCKER_REPO ?= masaruhoshi/okta-awscli
GITHUB_REPO := masaruhoshi/okta-awscli-docker
RELEASE_TYPE ?= patch

COMMIT ?= `git rev-parse --short HEAD 2>/dev/null`
BRANCH ?= `git rev-parse --abbrev-ref HEAD 2>/dev/null`
VERSION ?= $(shell cat version.txt)
BUILD_DATE := `date -u +"%Y-%m-%dT%H:%M:%SZ"`


VER=latest

version.txt: .git/HEAD
	./gen_version.sh > version.txt

build: image.iid

image.iid: version.txt Dockerfile
	$(eval PROFILE_FILE := $(shell mktemp .XXXXX))
	@./create_profile.sh $(PROFILE_FILE)
	docker build \
		--iidfile $@ \
		--build-arg BUILD_DATE=$(BUILD_DATE) \
		--build-arg VCS_REF=$(COMMIT) \
		--build-arg VERSION=$(VERSION) \
		--build-arg CODEOWNERS="$(shell cat .github/CODEOWNERS | grep -v '^#' | tr -s ' ')" \
    --build-arg PROFILE_FILE=$(PROFILE_FILE) \
		.
	rm -fr $(PROFILE_FILE)

clean:
	rm -f version.txt

clean-images: clean
	-@for iid in *.iid; do \
		[ -f "$$iid" ] || continue; \
		docker image rm -f $$(cat $$iid); \
		rm -f $$iid; \
	done

tag: image.iid
	docker tag $(shell cat image.iid) $(DOCKER_REPO):$(VERSION)

push: tag
	docker push $(DOCKER_REPO)

.PHONY: build release tag push deploy clean clean-images
