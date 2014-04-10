#!/bin/sh -euv

cat > $TRAVIS_BUILD_DIR/ci/ivy.credentials <<EOF
realm=Artifactory Realm
host=commbank.artifactoryonline.com
user=omnia-ci
password=$ARTIFACTORY_PASSWORD
EOF
