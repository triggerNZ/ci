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

set -e
set -u
set -v

if [[ $TRAVIS_PULL_REQUEST == "false" && $TRAVIS_BRANCH == "master" ]]; then
    if [ $# -lt 3 ]; then
        echo "Need to provide path to the executable, project name, and target repository."
        exit 1
    else
      artifactPath=$1
      repository=$2
      projectPath=$3

      if [ -f *.cabal ]; then
          # find the default form of the cabal version string.
          version=`grep -E -o "version:\W+[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+" *.cabal | cut -d':' -f 2`
          # trim the version string.
          version=${${version##+( )}%%+( )}
          filename="`basename "$artifactPath"`"
          ts=`date "+%Y%m%d%H%M%S"`
          commish=`git rev-parse --short HEAD`
          version="$version-$ts-$commish"
      else
          echo "Could not find *.cabal file."
          exit 1
      fi

      echo "Deploying $version to $repository ($projectPath)"

      curl -K $TRAVIS_BUILD_DIR/ci/curl.credentials \
        -X PUT \
        -T $artifactPath \
        https://commbank.artifactoryonline.com/commbank/$repository/$projectPath/$version/$filename
    fi
else
    echo "Not on master. Nothing to deploy"
fi
