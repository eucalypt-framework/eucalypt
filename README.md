<p align="center">
  <img width="250px" src="https://i.ibb.co/TPDRwvK/banner-rounded.png">
  <h1>Eucalypt</h1>
  <hr/>
  <b>Micro-framework, application generator and CLI wrapped around the Sinatra DSL.</b>
  <a href="https://github.com/eucalypt-framework/eucalypt/blob/0c509a4e22fd97ec52b6f638af21de783f3aafc8/eucalypt.gemspec#L19"><img src="https://img.shields.io/badge/ruby-~%3E%202.5-red.svg" alt="Ruby Version"/></a>
  <a href="https://rubygems.org/gems/eucalypt"><img src="https://img.shields.io/gem/v/eucalypt.svg" alt="Gem"/></a>
  <a href="https://travis-ci.com/eucalypt-framework/eucalypt"><img src="https://travis-ci.com/eucalypt-framework/eucalypt.svg?branch=master" alt="Build Status"/></a>
  <a href="https://github.com/eucalypt-framework/eucalypt/blob/master/LICENSE"><img src="https://img.shields.io/github/license/eucalypt-framework/eucalypt.svg" alt="License"/></a>
  <a href="https://eucalypt.gitbook.io/eucalypt"><img src="https://img.shields.io/badge/docs-gitbook-blue.svg" alt="Documentation"/></a>
</p>

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

<p align="center"><img width="70%" src="https://i.ibb.co/ctM0T07/cli.png"></p>

## Documentation

Full documentation can be found in the form of a GitBook, [here](https://eucalypt.gitbook.io/eucalypt).

## Directory structure

<details>
  <summary>
    <i>Click here to see the structure of a generated application.</i>
  </summary>
  <p>

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

  </p>
</details>

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

# Contributors

<table>
	<thead>
		<tr>
		  <th align="center">
        <a href="https://github.com/eonu">
        <img src="https://avatars0.githubusercontent.com/u/24795571?s=460&v=4" alt="Edwin Onuonga" width="60px">
        <br/><sub><b>Edwin Onuonga</b></sub>
        </a>
        <br/>
        <a href="mailto:ed@eonu.net">✉️</a>
        <a href="https://eonu.net">🌍</a>
			</th>
      <th align="center">
        <a href="https://github.com/ahmgeek">
        <img src="https://avatars3.githubusercontent.com/u/4132009?s=460&v=4" alt="Ahmad" width="60px">
        <br/><sub><b>Ahmad</b></sub>
        </a>
        <br/>
        <a href="mailto:ahmgeek@icloud.com">✉️</a>
        <a href="https://ahmgeek.com/">🌍</a>
			</th>
			<!-- Add more <th></th> blocks for more contributors -->
		</tr>
	</thead>
</table>

<p align="center">
  <b>Eucalypt</b> &copy; 2018-2020, Edwin Onuonga - Released under the <a href="http://mit-license.org/">MIT</a> License.<br/>
  <em>Authored and maintained by Edwin Onuonga.</em>
  <p align="center">
    <a href="https://eonu.net">eonu.net</a>&nbsp;&middot;&nbsp;
    GitHub: <a href="https://github.com/eonu">@eonu</a>&nbsp;&middot;&nbsp;
    Email: <a href="mailto:ed@eonu.net">ed@eonu.net</a>
  </p>
</p>