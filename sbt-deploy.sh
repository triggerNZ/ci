#   Copyright 2014 Commonwealth Bank of Australia
#
#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

#!/bin/bash

source settings.sh

set -e
set -u
set -v

# a warning indicating that this script is deprecated in favour of sbt-deploy-to.sh
echo "WARNING: the sbt-deploy.sh CI script is deprecated; please use sbt-deploy-to.sh instead."
echo "REASON FOR DEPRECATION:"
echo "  sbt-deploy.sh assumes that deployment will happen to the public artifactoryonline"
echo "  repository (ext-releases-local). Some private repositories, however, should be"
echo "  deployed to a non-public location. Hence, for the purposes of uniformity, a new script,"
echo "  sbt-deploy-to.sh, has been created that requires a target repository to be explicitly"
echo "  specified."

if [[ $TRAVIS_PULL_REQUEST == "false" && isReleaseBranch $TRAVIS_BRANCH ]]; then
    if [ $# -eq 0 ]; then
        echo "DEPRECATION MIGRATION: this script can be replaced by: sbt-deploy-to.sh ext-releases-local"
        sbt -Dsbt.global.base=$TRAVIS_BUILD_DIR/ci ';set publishTo in ThisBuild := Some("commbank-releases" at "http://commbank.artifactoryonline.com/commbank/ext-releases-local"); set publishMavenStyle in ThisBuild  := true; publish'
    else
        echo "DEPRECATION MIGRATION: this script can be replaced by: sbt-deploy-to.sh ext-releases-local" $@ 
        for project in $@; do
            echo "Publishing $project"
            sbt -Dsbt.global.base=$TRAVIS_BUILD_DIR/ci ";project $project; set publishTo in ThisBuild := Some(\"commbank-releases\" at \"http://commbank.artifactoryonline.com/commbank/ext-releases-local\"); set publishMavenStyle in ThisBuild  := true; publish"
        done
    fi
else
    echo "Not a release branch (${releaseBranches[@]}). Nothing to deploy."
fi
