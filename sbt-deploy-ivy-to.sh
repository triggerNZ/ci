#!/bin/bash


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

# sbt-deploy-ivy-to.sh targetRepository [ project1 project2 ... ]
#
#   Uses sbt to deploy artifacts to the chosen target repository. Optionally,
#   projects can be named explicitly in order that sbt deploy each of them
#   to the chosen repository. This deploys artifacts using ivy style. This
#   is mainly used for sbt plugins.
#
#   targetRepository - the target repository for deployment
#                      (eg. ext-releases-local or libs-releases-local)
#   projectN - a project name for sbt to deploy. If this is omitted, the
#              default (top-level) project is deployed.
#
#   Please see settings.sh for a description of how to set which branches
#   are released (i.e. actually published to artifactory).
set -e
set -u
set -v

readonly location="$( cd $(dirname $0) && pwd -P )"

source $location/settings.sh

set +e
isReleaseBranch $TRAVIS_BRANCH
IS_RELEASE=$?
set -e

if [[ $TRAVIS_PULL_REQUEST == "false" && $IS_RELEASE -eq 0 ]]; then
    if [ $# -eq 0 ]; then
        echo "Please provide a target repository and an optional list of projects to deploy."
        exit 1
    else
        repository=$1
        artifactoryUrl="http://commbank.artifactoryonline.com/commbank/$repository"
        publishTo="set publishTo in ThisBuild := Some(\"$repository\" at \"$artifactoryUrl\")"
        publishIvyStyle="set publishMavenStyle in ThisBuild := false"
        projects=${*:2}
        if [ $# -eq 1 ]; then
            echo "Publishing to repository $repository"
            sbt -Dsbt.global.base=$TRAVIS_BUILD_DIR/ci "; $publishTo; $publishIvyStyle; + publish"
        else
            for project in $projects; do
                echo "Publishing $project to repository $repository"
                sbt -Dsbt.global.base=$TRAVIS_BUILD_DIR/ci ";project $project; $publishTo; $publishIvyStyle; + publish"
            done
        fi
    fi
else
    echo "Not a release branch. Nothing to deploy."
    if [[ $TRAVIS_PULL_REQUEST != "false" ]]; then
        echo "Travis has marked this branch as a Pull Request, so it will not be deployed to Artifactory."
    else
        # format the string describing the added branch nicely
        read -a branchesArray <<< "${RELEASE_BRANCHES-}"
        if [ ${#branchesArray[@]} -eq 0 ]; then
            addedBranch="\"$TRAVIS_BRANCH\""
        else
            addedBranch="\"$TRAVIS_BRANCH ${branchesArray[@]-}\""
        fi
        # tell the user what to do if they want their branch deployed
        echo "To deploy this branch ($TRAVIS_BRANCH), add it to the RELEASE_BRANCHES environment variable:"
        echo "  travis env set RELEASE_BRANCHES $addedBranch"
        echo "(Or, alternatively, set it using the Travis web interface.)"
    fi
fi
