#!/bin/bash
FILE="hello.txt"
if [ -f "$FILE" ]; then
	echo "Hello $USER"
else
	echo "Hello ІСТ Майор Дмитро Ярославович"
fi
