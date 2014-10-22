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

# sbt-deploy-to.sh targetRepository [ project1, project2, ... ]
#
#   Uses sbt to deploy artifacts to the chosen target repository. Optionally,
#   projects can be named explicitly in order that sbt deploy each of them
#   to the chosen repository.
#
#   targetRepository - the target repository for deployment
#                      (eg. ext-releases-local or libs-releases-local)
#   projectN - a project name for sbt to deploy. If this is omitted, the
#              default (top-level) project is deployed.

set -e
set -u
set -v

if [[ $TRAVIS_PULL_REQUEST == "false" && ( $TRAVIS_BRANCH == "master" || $TRAVIS_BRANCH == "CDH5" ) ]]; then
    if [ $# -eq 0 ]; then
        echo "Please provide a target repository and an optional list of projects to deploy."
        exit 1
    else
        repository=$1
        artifactoryUrl="http://commbank.artifactoryonline.com/commbank/$repository"
        publishTo="set publishTo in ThisBuild := Some(\"$repository\" at \"$artifactoryUrl\")"
        publishMavenStyle="set publishMavenStyle in ThisBuild := true"
        projects=${*:2}
        if [ $# -eq 1 ]; then
            echo "Publishing to repository $repository"
            sbt -Dsbt.global.base=$TRAVIS_BUILD_DIR/ci "; $publishTo; $publishMavenStyle; publish"
        else
            for project in $projects; do
                echo "Publishing $project to repository $repository"
                sbt -Dsbt.global.base=$TRAVIS_BUILD_DIR/ci ";project $project; $publishTo; $publishMavenStyle; publish"
            done
        fi
    fi
else
    echo "Not on master or CDH5 branches. Nothing to deploy."
fi
