# qansible

[![Code Climate](https://codeclimate.com/github/trombik/qansible/badges/gpa.svg)](https://codeclimate.com/github/trombik/qansible)
[![Build Status](https://travis-ci.org/trombik/qansible.svg?branch=master)](https://travis-ci.org/trombik/qansible)
[![Coverage Status](https://coveralls.io/repos/github/trombik/qansible/badge.svg?branch=master)](https://coveralls.io/github/trombik/qansible?branch=master)

`qansible` provides helper scripts to create and maintain `ansible` roles.

`ansible-role-init` creates a scaffold. `ansible-role-qa` performs static
analysis.

## Dependencies

* `git`
* `bundler`

## Building the gem

```sh
git clone https://github.com/trombik/qansible.git
cd qansible
bundle install --without "development test"
bundle exec rake build
```

## Installation

Run `gem` WITHOUT `bundler`.

```sh
gem install --user-install pkg/qansible-$VERSION.gem
```

Make sure `~/.gem/ruby/$RUBYVERSION/bin` is in your `PATH` environment
variable. Run `gem env` to see `PATH`. After adding the path to `PATH`, run:

```sh
qansible --version
```

The command should show version number.

## Uninstalling the gem

```sh
gem uninstall qansible
```

## Usage

### qansible init [ROLENAME]

Creates an `ansible` role in the current directory and perform `git init`.

`ROLENAME` must start with `ansible-role`.

### ansible qa

Perform static analysis in the current directory.

## Development

Fork and clone the repository. Then:

```sh
cd qansible
bundle install --path vendor/bundle --with "test development"
```

Open another terminal. Run `guard`.

```sh
bundle exec guard
```
