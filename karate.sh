#!/usr/bin/env bash

echo "START: Running regression tests..."

LENV="${ENV:-dev}"

java -Dkarate.env=$LENV -jar /usr/ka/karate.jar features/*.feature
