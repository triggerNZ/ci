ci
==

Scripts used for Continuous Integration


Travis Setup
==========

1. Create a `.travis.yml` file in the top level directory of the project. Use some of the other projects' `.travis.yml` 
   file as a template.
2. Install the travis client. Instructions are available at https://github.com/travis-ci/travis.rb.
3. Login. `travis login --pro` or `travis login --org`.
4. From project folder (same directory as `.travis.yml`), enable your project with Travis CI by running the command 
   `travis enable --pro` or `travis enable --org`.
5. Add the encrypted artifactory password. By running this command in the same directory as `.travis.yml`. `travis 
   encrypt ARTIFACTORY_PASSWORD=...`.
6. [Optional to publish documentation] Create a branch called `gh-pages` for the project and push it to github. 
   Then add the encrypted github password by running this command in the same directory as `.travis.yml`. 
   `travis encrypt GH_PASSWORD=...`.


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

