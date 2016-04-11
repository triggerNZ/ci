#!/bin/sh

set -e

# this scripts uses the GitHub API to create a comment against a specific
# git commit-sha.
#
# our specific use case is to have our CI system post comments against a commit
# which is part of a pull request.
#
# the script expects the following parameters:
#   $1 - GH or GHE endpoint E.g. https://api.github.com
#   $2 - GitHub API user
#   $3 - GitHub API user personal token
#   $4 - GitHub repository owner and name E.g. lvenegas/myrepo
#   $5 - Git commit-sha to comment against
#   $6 - Comment
#
# example call:
#   ./gh-commit-comment.sh https://api.github.com lvenegas abcde lvenegas/myrepo ba7ead 'Comment here!'
#
# NOTE: on failure it returns a non-zero exit code so that our CI process
# registers the error
#
# see the page below for the API details:
# - https://developer.github.com/v3/repos/comments/#create-a-commit-comment

curl \
  --fail \
  -u $2:$3 \
  -H "Content-Type: application/json" \
  -X POST -d "{\"body\": \"$6\"}" \
  $1/repos/$4/commits/$5/comments
