#!/bin/bash

NOW=`date`

while getopts m:t: opt
do
    case "${opt}" in
        m) MESSAGE=${OPTARG};;
        t) TAG=${OPTARG};;
    esac
done

echo "** ADD **"
git add .
echo

if [ "$TAG" != "" ]; then
    echo "** TAG: $TAG **"
    git tag $TAG
    echo
fi
echo "** COMMIT **"
git commit --allow-empty-message -am "$NOW: $MESSAGE"
echo

echo "** PUSH **"
git push git@github.com:woongzz0110/docker-timescaledb.git master --tags --force
echo