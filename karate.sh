#!/usr/bin/env bash

echo "START: Running regression tests..."

LENV="${ENV:-dev}"

java -Dkarate.env=$LENV -jar karate.jar features/*.feature
