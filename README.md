ci
==

Scripts used for Continuous Integration


Travis Setup
============

1. Add a `.travis.yml` file to the top level directory of the project. See some of the other projects for a sample one.
1. Download the travis client. https://github.com/travis-ci/travis.rb.
1. Login. `travis login --pro` or `travis login --org`.
1. Add the encrypted artifactory password. By running this command in the same directory as `.travis.yml`. `travis encrypt 'ARTIFACTORY_PASSWORD=...'`.
1. [Optional to publish documentation] Add the encrypted github password. By running this command in the same directory as `.travis.yml`. `travis encrypt 'GH_PASSWORD=...'`.
1. Enable the build by `travis enable -r [name]`.


Scala Example
-------------

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
  example; assembly; project tools; assembly' && ci/sbt-deploy-to.sh ext-releases-local && ci/gh-pages.sh
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

