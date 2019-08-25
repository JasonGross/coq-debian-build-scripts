.PHONY: all

all:
	./01-download-coqs.sh || true # exit $$?
	./02-make-debian-preorigs.sh || exit $$?
	./03-sanitize-debian-origs.sh || exit $$?
	./04-make-debian-from-reference.sh || exit $$?
	./05-build-debian.sh || exit $$?
