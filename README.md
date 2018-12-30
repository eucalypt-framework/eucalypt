<p align="center"><img width="75px" src="gfx/eucalypt.png"></p>

[![Ruby Version](https://img.shields.io/badge/ruby-~%3E%202.5-red.svg)](https://github.com/eucalypt-framework/eucalypt/blob/0c509a4e22fd97ec52b6f638af21de783f3aafc8/eucalypt.gemspec#L19)
[![Gem](https://img.shields.io/gem/v/eucalypt.svg)](https://rubygems.org/gems/eucalypt)
[![Build Status](https://travis-ci.org/eucalypt-framework/eucalypt.svg?branch=master)](https://travis-ci.org/eucalypt-framework/eucalypt)
[![License](https://img.shields.io/github/license/eucalypt-framework/eucalypt.svg)](https://github.com/eucalypt-framework/eucalypt/blob/master/LICENSE)
[![Documentation](https://img.shields.io/badge/docs-gitbook-blue.svg)](https://eucalypt.gitbook.io/eucalypt)

# Eucalypt

Micro-framework, application generator and CLI wrapped around the Sinatra DSL.

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

> Once the setup is complete, make sure the required gems have been installed (without any errors).

### Commands

Move into your new application's directory and run the top-level `eucalypt` command to display a list of all available commands:

```bash
$ eucalypt

Commands:
  eucalypt init [NAME]          ·› Sets up your application
  eucalypt launch [ENV]         ·› Launches your application
  eucalypt console              ·› Interactive console with all files loaded
  eucalypt test                 ·› Run all application tests
  eucalypt version              ·› Display installed Eucalypt version
  eucalypt rake                 ·› Run all database migrations
  eucalypt blog [COMMAND]       ·› Manage static blog environment
  eucalypt generate [COMMAND]   ·› Generate individual MVC files or scaffolds
  eucalypt destroy [COMMAND]    ·› Destroy individual MVC files or scaffolds
  eucalypt security [COMMAND]   ·› Manage authentication and authorization
  eucalypt migration [COMMAND]  ·› Generate ActiveRecord migrations

For more information about a specific command, use eucalypt -H.
Example: eucalypt -H generate scaffold
```

## Documentation

Full documentation can be found in the form of a GitBook, [here](https://eucalypt.gitbook.io/eucalypt).

## Features

| Type                 | Feature                                                      |
| -------------------- | ------------------------------------------------------------ |
| Core/DSL             | [Sinatra](http://sinatrarb.com/)                             |
| CLI builder          | [Thor](https://github.com/erikhuda/thor)                     |
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