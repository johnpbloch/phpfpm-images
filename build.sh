#!/bin/sh

children=""
for version in $(ls -1 images)
do
  tmpFile=$(mktemp --tmpdir=. "php$version.XXX.log")
  echo "Building $version (output in $tmpFile)..."
  docker build --pull --no-cache -t "johnpbloch/phpfpm:$version" "images/$version" > $tmpFile 2>&1 &
  children+=" $version:$!"
done

exitcode=0
errorMsg="The following versions failed:"
for versions in $children
do
	pid=${versions##*:}
	ver=${versions%%:*}
	if wait $pid ; then
		rm "php$ver.*.log"
	else
		errorMsg+=" $ver"
		let $exitcode++
	fi
done

if (( $exitcode > 0 )); then
	2>&1 echo $errorMsg
	exit $exitcode
fi

docker tag johnpbloch/phpfpm:7.2 johnpbloch/phpfpm:latest

docker push johnpbloch/phpfpm

