.PHONY: test
test:
	export LUA_PATH="./?.lua;./lib/?.lua;./third_party/?/?.lua"; \
	busted test
