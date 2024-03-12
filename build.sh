#!/bin/bash

children=""
for version in $(ls -1 images)
do
  tmpFile=$(mktemp --tmpdir=. "php$version.XXX.log")
  docker build --pull --no-cache -t "johnpbloch/phpfpm:$version" "images/$version" > $tmpFile 2>&1 &
  pid="$!"
  echo "Building $version (PID $pid, output in $tmpFile)..."
  children="$children $version:$pid"
done

exitcode=0
errorMsg="The following versions failed:"
for versions in $children
do
	pid=${versions##*:}
	ver=${versions%%:*}
	if wait $pid ; then
		rm php$ver.*.log
	else
		errorMsg+=" $ver"
		exitcode=$(($exitcode+1))
	fi
done

if (( $exitcode > 0 )); then
	2>&1 echo $errorMsg
	exit $exitcode
fi

docker tag johnpbloch/phpfpm:8.3 johnpbloch/phpfpm:latest

echo "Pushing images..."
for version in $(ls -1 images)
do
	docker push johnpbloch/phpfpm:$version > /dev/null 2>&1 &
done
docker push johnpbloch/phpfpm:latest > /dev/null 2>&1 &
wait

