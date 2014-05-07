#!/bin/bash -euv

function get_version() {
    local branch=$TRAVIS_BRANCH
    local ts=`date "+%Y%m%d%H%M%S"`
    local commish=`git rev-parse --short HEAD`
    local version="$1-$ts-$commish"
    if [ $TRAVIS_PULL_REQUEST != "false" ]; then
        echo "PR$TRAVIS_PULL_REQUEST-$version"
    elif [ $TRAVIS_BRANCH == "master" ]; then
        echo "$version"
    else
        echo "$branch-$version"
    fi
}

if [ -f version.sbt ]; then
    version=`grep -E -o "[0-9]*\.[0-9]*\.[0-9]*" version.sbt`
    echo $version
    new_version=$(get_version $version)
    echo "version in ThisBuild := \"$new_version\"" > version.sbt
else
    exit 1
fi

exit 0
