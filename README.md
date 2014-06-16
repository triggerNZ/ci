ci
==

Scripts used for Continuous Integration


Travis Setup
============

1. Add a `.travis.yml` file to the top level directory of the project. See some of the other projects for a sample one.
1. Download the travis client. https://github.com/travis-ci/travis.rb.
1. Login. `travis login --pro`
1. Add the encrypted password for travis to clone this repo. By running this command in the same directory as `.travis.yml`. `travis encrypt 'OMNIA_CI_PASSWORD=...`.
1. Add the encrypted artifactory password. By running this command in the same directory as `.travis.yml`. `travis encrypt 'ARTIFACTOET_PASSWORD=...`.
1. Enable the build by `travis enable -r [name]`.
