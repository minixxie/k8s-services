#!/bin/bash

function checkFolder {
	d="$1"

	if ! [ -d "$d" ]; then
		return;
	fi
	echo "[$d]"
	#if [ -f "$d"/Makefile ]; then
	#	echo "- WARN: still has Makefile"
	#fi
	if [ -f "$d"/make.rc ]; then
		echo "- WARN: still has make.rc"
	fi
	if [ -f "$d"/wait.rc ]; then
		echo "- WARN: still has wait.rc"
	fi
	if [ -f "$d"/cli.rc ]; then
		echo "- WARN: still has cli.rc"
	fi
	if [ -f "$d"/img.rc ]; then
		echo "- WARN: still has img.rc"
	fi
	if [ -f "$d"/local.rc ]; then
		echo "- WARN: still has local.rc"
	fi

	if ! [ -f "$d"/get ]; then
		echo "- WARN: no ./get"
	fi
	if ! [ -f "$d"/up ]; then
		echo "- WARN: no ./up"
	fi
	if ! [ -f "$d"/down ]; then
		echo "- WARN: no ./down"
	fi
	if ! [ -f "$d"/local ]; then
		echo "- WARN: no ./local"
	fi
	if ! [ -f "$d"/logs ]; then
		echo "- WARN: no ./logs"
	fi
	if ! [ -f "$d"/img ]; then
		echo "- WARN: no ./img"
	fi
	if ! [ -f "$d"/ns ]; then
		echo "- WARN: no ./ns"
	fi
	if ! [ -f "$d"/wait ]; then
		echo "- WARN: no ./wait"
	fi
	if ! [ -f "$d"/var.rc ]; then
		echo "- WARN: no ./var.rc"
	fi
	if [ -f "$d"/Chart.yaml ]; then
		if ! [ -f "$d"/chart-name ]; then
			echo "- WARN: no ./chart-name"
		fi
		if ! [ -f "$d"/helm-repo ]; then
			echo "- WARN: no ./helm-repo"
		fi
		if ! [ -f "$d"/helm-repo-add ]; then
			echo "- WARN: no ./helm-repo-add"
		fi
		if ! [ -f "$d"/helm-repo-remove ]; then
			echo "- WARN: no ./helm-repo-remove"
		fi
		if ! [ -f "$d"/helm-show-val ]; then
			echo "- WARN: no ./helm-show-val"
		fi
		if ! [ -f "$d"/.helmignore ]; then
			echo "- WARN: no ./.helmignore"
		fi
	fi
	if ! [ -f "$d"/test.sh ]; then
		if ! [ -f "$d"/test ]; then
			echo "- WARN: no ./test.sh nor ./test"
		fi
	fi

	echo ""
}

if [ "$1" != "" ];
then
	checkFolder "$1"
	exit 0
fi

for d in *; do
	checkFolder "$d"
done
