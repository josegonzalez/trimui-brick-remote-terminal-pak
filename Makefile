TAG ?= latest
BUILD_DATE := "$(shell date -u +%FT%TZ)"

clean:
	rm -f bin/evtest || true
	rm -f bin/remote-term || true

build: bin/evtest bin/sdl2imgshow bin/remote-term res/BPreplayBold.otf

bin/evtest:
	docker buildx build --platform linux/arm64 --load -f Dockerfile.evtest --progress plain -t app/evtest:$(TAG) .
	docker container create --name extract app/evtest:$(TAG)
	docker container cp extract:/go/src/github.com/freedesktop/evtest/evtest bin/evtest
	docker container rm extract
	chmod +x bin/evtest

bin/sdl2imgshow:
	docker buildx build --platform linux/arm64 --load -f Dockerfile.sdl2imgshow --progress plain -t app/sdl2imgshow:$(TAG) .
	docker container create --name extract app/sdl2imgshow:$(TAG)
	docker container cp extract:/go/src/github.com/kloptops/sdl2imgshow/build/sdl2imgshow bin/sdl2imgshow
	docker container rm extract
	chmod +x bin/sdl2imgshow

bin/remote-term:
	docker buildx build --platform linux/arm64 --load -f Dockerfile.remote-term --progress plain -t app/remote-term:$(TAG) .
	docker container create --name extract app/remote-term:$(TAG)
	docker container cp extract:/go/src/github.com/josegonzalez/go-remote-term/remote-term bin/remote-term
	docker container rm extract
	chmod +x bin/remote-term

res/BPreplayBold.otf:
	curl -sSL -o res/BPreplayBold.otf "https://raw.githubusercontent.com/shauninman/MinUI/refs/heads/main/skeleton/SYSTEM/res/BPreplayBold-unhinted.otf"