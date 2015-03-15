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

# Common CI settings
# Branches for which we should do a release
releaseBranches=("master" "CDH5" "CDH5V1" "CDH5_new_deps")

# Checks if an array contains the specified element
# Usage: containsElement "CDH5" ${release_branches[@]}
containsElement () {
    local e
    for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
    return 1
}

# Checks if the specified branch is a release branch
# Usage: isReleaseBranch "CDH5"
isReleaseBranch () {
    containsElement $1 ${releaseBranches[@]}
}

