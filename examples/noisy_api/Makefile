PROJECT = noisy_api

DEPS = cowboy cowboy_error_noise

dep_cowboy = git https://github.com/ninenines/cowboy.git master
dep_cowboy_error_noise = git https://github.com/ahf/cowboy_error_noise.git master

include ../../erlang.mk

console: all
	./_rel/noisy_api/bin/noisy_api console

.PHONY: console
