.PHONY:  default

default:
	@echo "make [build|publish]"

%.build:
	./scripts/build.sh $*

build:
	./scripts/build.sh

publish:
	./scripts/publish.sh

%.new:
	mkdir -p $*;
	echo "---\n\
marp: true\n\
---\n\

# Title!
" > $*/note.marp.md

clean:
	rm -i lab*/*.pdf >/dev/null