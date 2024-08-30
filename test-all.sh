#!/bin/bash

cd ./tests/
for s in ./e2e.*.sh
do
	printf "\x1B[92m=== $s ===\x1B[0m\n"
	$s || printf >&2 "\x1B[91mERROR: $s\x1B[0m\n"
done
