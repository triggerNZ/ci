#!/bin/bash -euv

test $TRAVIS_PULL_REQUEST == "false" \
    && test $TRAVIS_BRANCH == "master" && \
    sbt -Dsbt.global.base=$TRAVIS_BUILD_DIR/ci ';set publishTo in ThisBuild := Some("commbank-releases" at "http://commbank.artifactoryonline.com/commbank/ext-releases-local"); set publishMavenStyle in ThisBuild  := true; publish'
