ci
==

[![Build Status](https://travis-ci.org/CommBank/ci.svg?branch=master)](https://travis-ci.org/CommBank/ci)
[![Coverage Status](https://coveralls.io/repos/github/wrouesnel/ci/badge.svg?branch=master)](https://coveralls.io/github/wrouesnel/ci?branch=master)

Scripts used for Continuous Integration


Travis Setup
==========

1. Create a `.travis.yml` file in the top level directory of the project. Use some of the other projects' `.travis.yml` 
   file as a template.
2. Install the travis client. Instructions are available at https://github.com/travis-ci/travis.rb. **Please be aware that the installation and usage of the travis client often result in network and SSL Errors from within the office network (including wifi). Tethering to  a 4G device is one workaround for this.**
3. Login. `travis login --pro` or `travis login --org`.
4. From project folder (same directory as `.travis.yml`), enable your project with Travis CI by running the command 
   `travis enable --pro` or `travis enable --org`.
5. Add the encrypted artifactory password. By running this command in the same directory as `.travis.yml`. `travis 
   encrypt ARTIFACTORY_PASSWORD=...`.
6. [Optional to publish documentation] **For public repos only** Create a branch called `gh-pages` for the project and push it to github. Then add the private key for omnia-bamboo as an encrypted file.
   1. Get the private key
   1. Create a folder in the repo `.travis`
   1. `travis encrypt-file <path-private-key> .travis/deploy-key.enc -w .travis/deploy-key.pem --add`
   1. For sbt builds add the `ci/sbt-gh-pages-ssh.sh` to the build commands.

Publishing a Branch to Artifactory
----------------------------------

If you are using the `sbt-deploy-to.sh` script, it will attempt to publish the `master` branch of your 
project to Artifactory automatically. If you would like to publish any other branches (for testing purposes,
for example), you can add them as a space-separated string to the `RELEASE_BRANCHES` environment variable.
For example, to publish branches named `CDH5` and `realtime` *in addition to* `master`, you would set 
`RELEASE_BRANCHES` to `"CDH5 realtime"`.

You can set `RELEASE_BRANCHES` via the Travis web UI (https://docs.travis-ci.com/user/environment-variables/#Defining-Variables-in-Repository-Settings), or
via the command line Travis client:
```
travis env set RELEASE_BRANCHES "CDH5 realtime"
```

Scala Example
--------------------

```
language: scala
jdk:
- oraclejdk7
cache:
  directories:
  - $HOME/.ivy2
  - $HOME/.m2
install:
- git clone https://github.com/CommBank/ci.git
- chmod ugo+x  ci/*
- ci/sbt-setup.sh
- ci/sbt-setup-version.sh
script:
- sbt -Dsbt.global.base=$TRAVIS_BUILD_DIR/ci ';  project all; test; package; project
  example; assembly; project tools; assembly' && ci/sbt-deploy-to.sh ext-releases-local && ci/sbt-gh-pages-ssh.sh
after_script:
- rm -rf ci
env:
  global:
  - secure: ...
  - secure: ...
```

Haskell OS X Example
--------------------

```
# needed to use the os x build agent.
language: objective-c

os:
  - osx

install:  
- git clone https://github.com/CommBank/ci.git
- chmod ugo+x  ci/*
- ci/cabal-osx-setup.sh

script:
- cabal install
- ci/cabal-deploy.sh dist/build/codetroll/codetroll ext-releases-local au/com/cba/omnia/codetroll

```

