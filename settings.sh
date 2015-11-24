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

# Common CI settings

# The environment variable RELEASE_BRANCHES controls which branches are released
# (ie. published to Artifactory). This variable should be set (in Travis) to a
# space-separated string containing branch names; for example:
#   RELEASE_BRANCHES="CDH5 realtime"
# The "master" branch is included automatically. The variable can be set using
# the Travis web interface or the CLI app:
#   travis env set RELEASE_BRANCHES "CDH5 realtime"

# Checks if an array contains the specified element
# Usage: containsElement "CDH5" ${branchArray[@]}
containsElement () {
    local e
    for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
    return 1
}

# Checks if the specified branch is a release branch
# Usage: isReleaseBranch "CDH5"
isReleaseBranch () {
    read -a branchesArray <<< "${RELEASE_BRANCHES-}"
    masterAndReleaseBranches=("master" "${branchesArray[@]-}")
    containsElement $1 ${masterAndReleaseBranches[@]}
}
