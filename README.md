[![Ruby Version](https://img.shields.io/badge/ruby-~%3E%202.5-red.svg)](https://github.com/eonu/eucalypt/blob/0c509a4e22fd97ec52b6f638af21de783f3aafc8/eucalypt.gemspec#L19)
[![Gem](https://img.shields.io/gem/v/eucalypt.svg)](https://rubygems.org/gems/eucalypt)
[![Build Status](https://travis-ci.org/eonu/eucalypt.svg?branch=master)](https://travis-ci.org/eonu/eucalypt)
[![License](https://img.shields.io/github/license/eonu/eucalypt.svg)](https://github.com/eonu/eucalypt/blob/master/LICENSE)

# Eucalypt

Micro-framework and CLI wrapped around the Sinatra DSL, for the generation and maintenance of structured web applications.

## Installation

To install the CLI, run:

```bash
$ gem install eucalypt
```

## Usage

Initialize a new application with:

```bash
$ eucalypt init my-new-app
```

> Once the setup is complete, make sure the required gems have been installed (without any errors). This is indicated by the presence of a `Gemfile.lock` file.
>
> This should have been done automatically unless you used the `--no-bundle` flag during initialization.

Move into your new application's directory and run the top-level `eucalypt` command to display a list of all available commands.

## Documentation and help

The full documentation can be found [here](https://gum.gitbook.io).

---

## Features

Some of these features are pretty set in stone, but it may be possible to change some of them around with a little bit of work.

| Type                 | Feature                                                      |
| -------------------- | ------------------------------------------------------------ |
| Core/DSL             | [Sinatra](http://sinatrarb.com/)                             |
| Web server           | [Thin](https://github.com/macournoyer/thin)                  |
| ORM                  | [ActiveRecord](https://github.com/rails/rails/tree/master/activerecord) |
| ORDBMS               | [PostgreSQL](https://www.postgresql.org/) + [SQLite3](https://www.sqlite.org/) |
| Asset pipeline       | [Sprockets](https://github.com/rails/sprockets)              |
| Templating engine    | [ERB](https://ruby-doc.org/stdlib-2.5.0/libdoc/erb/rdoc/ERB.html) |
| Markdown processor   | [RDiscount](https://github.com/davidfstr/rdiscount)          |
| Front matter parsing | [FrontMatterParser](https://github.com/waiting-for-dev/front_matter_parser) |
| HTML helpers         | [Hanami](https://github.com/hanami/helpers)                  |
| CSS preprocessing    | [SCSS](http://sass-lang.com/)                                |
| JS compressing       | [Uglifier](https://github.com/lautis/uglifier)               |
| Logging              | [Lumberjack](https://github.com/bdurand/lumberjack)          |
| Specs                | [RSpec](http://rspec.info/) + [Rack-Test](https://github.com/rack-test/rack-test) + [Shoulda-Matchers](http://matchers.shoulda.io/) |
| Encryption           | [BCrypt](https://github.com/codahale/bcrypt-ruby)            |
| Authentication       | [Warden](https://github.com/wardencommunity/warden)          |
| Authorization        | [Pundit](https://github.com/varvet/pundit)                   |
| CLI builder          | [Thor](https://github.com/erikhuda/thor)                     |