<p align="center"><img width="75px" src="https://i.ibb.co/BKb7SxT/eucalypt.png"></p>

[![Ruby Version](https://img.shields.io/badge/ruby-~%3E%202.5-red.svg)](https://github.com/eucalypt-framework/eucalypt/blob/0c509a4e22fd97ec52b6f638af21de783f3aafc8/eucalypt.gemspec#L19)
[![Gem](https://img.shields.io/gem/v/eucalypt.svg)](https://rubygems.org/gems/eucalypt)
[![Build Status](https://travis-ci.com/eucalypt-framework/eucalypt.svg?branch=master)](https://travis-ci.com/eucalypt-framework/eucalypt)
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

Running the top-level `eucalypt` command displays information about initializing a new application:

<p align="center"><img width="70%" src="https://i.ibb.co/4ZkqjS5/cli-1.png"></p>

Initialize a new application with:

```bash
$ eucalypt init my-new-app
```

> Once the setup is complete, make sure the required gems have been installed (without any errors).

### Commands

Move into your new application's directory and run the top-level `eucalypt` command to display a list of all available commands:

<p align="center"><img width="70%" src="https://i.ibb.co/JsQkH8j/cli-2.png"></p>

## Documentation

Full documentation can be found in the form of a GitBook, [here](https://eucalypt.gitbook.io/eucalypt).

## Directory structure

The structure of a generated application looks like the following:

```
.
├── Gemfile
├── Gemfile.lock
├── Gumfile
├── Procfile
├── Rakefile
├── app
│   ├── assets
│   │   ├── fonts
│   │   ├── images
│   │   ├── scripts
│   │   │   └── application.js
│   │   └── stylesheets
│   │       └── application.scss
│   ├── controllers
│   ├── helpers
│   ├── models
│   ├── static
│   │   └── public
│   └── views
│       ├── index.erb
│       ├── layouts
│       │   └── main.erb
│       └── partials
├── app.rb
├── config
│   ├── assets.rb
│   ├── database.yml
│   ├── initializers
│   └── logging.rb
├── config.ru
├── logs
└── spec
    ├── controllers
    ├── helpers
    ├── models
    └── spec_helper.rb
```

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

## Acknowledgements

<p align="center">
  <b>Eucalypt</b> &copy; 2018-2020, Edwin Onuonga - Released under the <a href="http://mit-license.org/">MIT</a> License.<br/>
  <em>Authored and maintained by Edwin Onuonga.</em>
  <p align="center">
    <a href="https://eonu.net">eonu.net</a>&nbsp;&middot;&nbsp;
    GitHub: <a href="https://github.com/eonu">@eonu</a>&nbsp;&middot;&nbsp;
    Email: <a href="mailto:ed@eonu.net">ed@eonu.net</a>
  </p>
</p>