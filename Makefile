.PHONY:  default

default:
	@echo "make [build|publish]"

%.build:
	./scripts/build.sh $*

build:
	./scripts/build.sh

publish:
	./scripts/publish.sh

clean:
	rm -i lab*/*.pdf >/dev/null