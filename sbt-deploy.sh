#!/bin/bash -euv

if [[ $TRAVIS_PULL_REQUEST == "false" && $TRAVIS_BRANCH == "master" ]]; then
    if [ $# -eq 0 ]; then
        sbt -Dsbt.global.base=$TRAVIS_BUILD_DIR/ci ';set publishTo in ThisBuild := Some("commbank-releases" at "http://commbank.artifactoryonline.com/commbank/ext-releases-local"); set publishMavenStyle in ThisBuild  := true; publish'
    else
        for project in $@; do
            echo "Publishing $project"
            sbt -Dsbt.global.base=$TRAVIS_BUILD_DIR/ci ";project $project; set publishTo in ThisBuild := Some(\"commbank-releases\" at \"http://commbank.artifactoryonline.com/commbank/ext-releases-local\"); set publishMavenStyle in ThisBuild  := true; publish"
        done
    fi
else
    echo "Not on master. Nothing to deploy"
fi
