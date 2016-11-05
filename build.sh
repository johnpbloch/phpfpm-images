#!/bin/sh

for version in $(ls -1 images)
do
  docker build --pull -t "johnpbloch/phpfpm:$version" "images/$version"
done

docker tag johnpbloch/phpfpm:7.0 johnpbloch/phpfpm:latest

docker push johnpbloch/phpfpm

