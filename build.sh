#!/bin/sh

for version in $(ls -1 images)
do
  docker build --pull --no-cache -t "johnpbloch/phpfpm:$version" "images/$version"
done

docker tag johnpbloch/phpfpm:7.1 johnpbloch/phpfpm:latest

docker push johnpbloch/phpfpm

