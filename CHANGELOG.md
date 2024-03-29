## Release 2.8.2

* 9265be8 update: update rubocop to the latest
* 0dc424f update: github-actions and ruby version
* 9ef81c9 update: gems

## Release 2.8.1

* 8e8acd6 bugfix: do not use Unix password database for full name
* c33440b bugfix: allocate tty to action
* b4e5b8d bugfix: surpress warnings from git
* b9feecc bugfix: setup default identity for git
* e4c8621 ci: update rubocop_todo
* f03f204 bugfix: remove (unused) coveralls
* 858b31d bugfix: QA
* 39adce2 bugfix: update gems
* 636e91f update Gemfile.lock
* e8e7e94 ci: build qansible on Github Actions
* 2904cf0 imp: remove Travis CI, add Github Actions workflows

## Release 2.8.0

* 473e89c Bump json from 2.1.0 to 2.3.1
* b73d06b feature: run test-kitchen in Travis CI

## Release 2.7.4

* 1d683cc Bump rake from 10.5.0 to 13.0.1
* 96fda72 bugfix: update bundler to 2.x

## Release 2.7.3

* 9e0e3c1 bugfix: update .travis.yml

## Release 2.7.2

* 5ac1450 bugfix: fix path

## Release 2.7.1

* Fix wrong git tag in 2.7.0

## Release 2.7.0

* fc54718 feature: support molecule

## Release 2.6.5

bundler: update to 2.x

## Release 2.6.4

* 4d75155 update box version
* 0f20cfd bugfix: update RubyGem before install
* b4203ae update: bundler

## Release 2.6.3

* ca43331 bugfix: do not ignore Gemfile.lock
* 15d6f5b bugfix: fix style error and ignore a rubocop rule in Rakefile

## Release 2.6.2

* 3115c32 bugfix: update regexp
* e2a41d4 bugfix: update Rakefile

## Release 2.6.1

* 1bc4e74 bugfix: remove rvm, as it is not required anymore
* e8aaecf bugfix: add role_name

## Release 2.6.0

* 93c93ce feature: run yamllint as part of tests

## Release 2.5.8

* b0298c7 bugfix: after bafe8ad, Gemfile.lock should not be ignored
* 7563118 bugfix: update Gemfile
* 9f9821a bugfix: update .travisci to upgrade bundler
* db35dd2 bugfix: use cache in travisci
* fcac319 bugfix: update templates

## Release 2.5.7

* 0a490e8 bugfix: QA

## Release 2.5.6

* 9cb187d bugfix: remove role_name

## Release 2.5.5

* 21db2e3 update ruby version in travis
* c30227c bugfix: update rubocop and QA
* 6992510 bugfix: make Rakefile rubocop-compliant

## Release 2.5.4

* 2002e68 bugfix: Illformed requirement

## Release 2.5.3

* 4a4d090 bugfix: update kitchen-vagrant and rubocop
* 9f8467e bugfix: check role_name in meta/main.yml

## Release 2.5.2

* a364c1c [bugfix] update kitchen-ansible in Gemfile (#91)

## Release 2.5.1

* bump VERSION, no functionality changes

## Release 2.5.0

* 6ede855 [feature] enable cache and update ruby 2.3 (#87)

## Release 2.4.2

* d41bd78 [bugfix] update Rakefile for integration tests (#80)

## Release 2.4.1

* a57c2f8 [bugfix] add AllowSymlinksInCacheRootDirectory (#78)

## Release 2.4.0

* 80f527b [feature] warn if ansible_vault_password_file is used (#76)
* 2976c43 [bugfix] QA (#75)

## Release 2.3.2

* b19e5f1 [bugfix] include rspec-retry (#73)

## Release 2.3.1

* 1e1d446 [bugfix] fix issue #64 and #66 (#67)

## Release 2.3.0

* 3340144 change red to light red for criticals and yellow for warns (fixes #54) (#57)
* f04bc2a bugfix: fix invalid ruby syntax in Rakefile (#62)
* 8d2fad0 add .github (#63)
* a55f8d6 ignore `block` without name (#61)
* b6ff341 do not enable requirements_path by default (#60)
* f11b9cd warn if extra_roles exists (#58)

## Release 2.2.5

* [bugfix] version has not been bumped

## Release 2.2.4

* 52602bf ignore extra_roles diretory (#50)

## Release 2.2.3

* [bugfix] version has not been bumped

## Release 2.2.2

* 1d8afea fix failed rubocop run (#46)

## Release 2.2.1

* 052de4d rubocopfy default templates and run rubocop (#44)

## Release 2.1.1

* ef81bed introduce rubocop (#41)
* f8af554 Create ISSUE_TMPLATE (#39)
