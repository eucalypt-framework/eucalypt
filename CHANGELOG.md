# [0.9.0](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.9.0)

#### Major changes

- Removes the security (authentication and authorization) commands due to their opinionated implementation as described in #60. ([#61](https://github.com/eucalypt-framework/eucalypt/pull/61))

#### Minor changes

- Add primary author email address to `LICENSE`. ([#62](https://github.com/eucalypt-framework/eucalypt/pull/62))
- Add @ahmgeek as a contributor (for #37). ([#59](https://github.com/eucalypt-framework/eucalypt/pull/59))
- Add CI ruby `2.7.0.preview1`. ([#58](https://github.com/eucalypt-framework/eucalypt/pull/58))

# [0.8.0](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.8.0)

#### Major changes

- Remove `rspec` core rake tasks (top-level & application-level). ([#50](https://github.com/eucalypt-framework/eucalypt/pull/50))
- Change CI script to implicit `rspec` call (top-level & application-level). ([#50](https://github.com/eucalypt-framework/eucalypt/pull/50))
- Add environment options for `console` command. ([#47](https://github.com/eucalypt-framework/eucalypt/pull/47))
- Add `Eucalypt.console?` to check whether the console is active. ([#47](https://github.com/eucalypt-framework/eucalypt/pull/47))
- Redirect console output in production environment to STDOUT by default. ([#47](https://github.com/eucalypt-framework/eucalypt/pull/47))
- Remove conditional `irb` require. ([#46](https://github.com/eucalypt-framework/eucalypt/pull/46))
- Migrate to [travis-ci.com](https://travis-ci.com/). ([#44](https://github.com/eucalypt-framework/eucalypt/pull/44))

#### Minor changes

- Render REST policy controller resources as JSON. ([#55](https://github.com/eucalypt-framework/eucalypt/pull/55))
- Add GitHub issue and pull request templates. ([#54](https://github.com/eucalypt-framework/eucalypt/pull/54))
- Serve repository graphics externally. ([#53](https://github.com/eucalypt-framework/eucalypt/pull/53))
- Add read permission to default scaffold policy roles. ([#45](https://github.com/eucalypt-framework/eucalypt/pull/45))
- Silence policy role-plucking query. ([#45](https://github.com/eucalypt-framework/eucalypt/pull/45))

# [0.7.2](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.7.2)

#### Major changes

- Remove `bundler` gem runtime dependency. ([#41](https://github.com/eucalypt-framework/eucalypt/pull/41))
- Add Ruby version `2.6` to Travis CI build. ([#39](https://github.com/eucalypt-framework/eucalypt/pull/39))

#### Minor changes

- Add database migration command to `Procfile`. ([#40](https://github.com/eucalypt-framework/eucalypt/pull/40))
- Add directory structure and acknowledgements to `README.md`. ([#38](https://github.com/eucalypt-framework/eucalypt/pull/38))
- Remove `.codeclimate.yml` and `.rubocop.yml`. ([#42](https://github.com/eucalypt-framework/eucalypt/pull/42))

# [0.7.1](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.7.1)

#### Major changes

- Fixed the issue of IRB not being bundled in Ruby `>= 2.6`.<br>_See bundler/bundler#6929._

# [0.7.0](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.7.0)

#### Major changes

- Change `bundler` version specifier to `~> 2.0` in `eucalypt.gemspec` and generated application's `Gemfile`. ([#29](https://github.com/eucalypt-framework/eucalypt/pull/29))
- Use `Regexp#match?` instead of `Object#=~` to suppress warnings when using Ruby `2.6.2`. ([#32](https://github.com/eucalypt-framework/eucalypt/pull/32))
- Add `ruby-head` to Travis RVM rubies. ([#31](https://github.com/eucalypt-framework/eucalypt/pull/31))

#### Minor changes

- Update author email from `edwinonuonga@gmail.com` to `ed@eonu.net`. ([#30](https://github.com/eucalypt-framework/eucalypt/pull/30))
- Add `.ruby-version` and `.ruby-gemset` to `.gitignore`. ([#28](https://github.com/eucalypt-framework/eucalypt/pull/28))

# [0.6.2](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.6.2)

#### Major changes

- Only show the `init` task by default when the top-level `eucalypt` command is run outside a Eucalypt application directory. ([#26](https://github.com/eucalypt-framework/eucalypt/pull/26))

#### Minor changes

- Add a second CLI image showing the new `init` task when top-level `eucalypt` command is run outside a Eucalypt application directory. ([#26](https://github.com/eucalypt-framework/eucalypt/pull/26))
- Update CLI screenshot in README.md ([#25](https://github.com/eucalypt-framework/eucalypt/pull/25))

# [0.6.1](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.6.1)

#### Major changes

- Fix LoadError originating from the use of the updated `sqlite3` gem version `1.4.0`, by changing the gem version specifier in the `Gemfile` to `~> 1.3.6`, making it more strict than the previous `~> 1.3` ([#21](https://github.com/eucalypt-framework/eucalypt/pull/21))
- Remove `rake db:migrate` as default rake task for `eucalypt rake` command ([#23](https://github.com/eucalypt-framework/eucalypt/pull/23))
- Add `task` argument to the `eucalypt rake` command for specifying rake tasks ([#23](https://github.com/eucalypt-framework/eucalypt/pull/23))

#### Minor changes

- Changed font on default index page from Alegreya to Signika ([#22](https://github.com/eucalypt-framework/eucalypt/pull/22))
- Changed message on default index page from `It's alive!` to `It's running!` ([#22](https://github.com/eucalypt-framework/eucalypt/pull/22))

# [0.6.0](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.6.0)

#### Major changes

**These major changes were to address the issue of routes being inherited, or in response to this fix**

- Remove `ApplicationController` from `app/controllers` directory to prevent routes being defined in it (since the main cause of route inheritance is from the fact that each controller subclasses `ApplicationController`)
- Add `MainController` which now effectively works the same way as the old `app/controllers/application_controller.rb` - it is rooted at `/`
- Add `MainHelper` which is the helper module for `MainController` only. `ApplicationHelper` still exists, and is still used for defining methods which should be available to all subclassing controllers
- Change maintenance mode to use before filters to redirect to `MainController`'s `/maintenance` method. Additionally, maintenance mode and the maintenance route are now both configured in `app.rb`
- Change asset pipeline setup to only define `/assets/*` at the root (`MainController`) rather than relative to each controller
- Prevent `app/controllers/main_controller.rb` from being deleted through the CLI

**Other major changes**

- Add `render_static` method as an abstraction for `send_file`, to avoid having to type `send_file File.join(settings.public_folder, file)`
- Change ordering of require directives in `eucalypt/load.rb`
- Move asset pipeline configuration into the library (to avoid cluttering the application)

#### Minor changes

- Add a default index page if `/` is not defined in `MainController`
- Change default logging configurations
  - `Lumberjack::Severity::DEBUG` is now the default severity for the development environment
  - Remove unnecessary `Lumberjack::Severity::INFO` specification for the production environment, since `set :logging` defaults to this severity anyway
- Delete unused `eucalypt/guard.rb` file
- Change default specs to all be true
- Remove `bundle exec` from `Procfile` since the `eucalypt launch` command already executes `rackup` under `bundle exec`

# [0.5.4](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.5.4)

#### Major changes

- (**`core/helpers/static.rb`**): Remove stabby lambda definition from `static_router` setting to prevent a new `Static::Router` object from being initialized every time the setting is called

#### Minor changes

- (**`core/helpers/static.rb`**): Remove `:<<` alias method for `Static::Router#route` instance method

# [0.5.3](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.5.3)

#### Major changes

- (**`core/helpers/maintenance.rb`**): Change dummy route to use `SecureRandom.hex` instead of `SecureRandon.random_bytes`, which used to generate invalid URLs

# [0.5.2](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.5.2)

#### Major changes

- Remove IP whitelisting feature (remove `Eucalypt::Whitelist` and `eucalypt/whitelist.rb`)
- (**`config/assets.rb`**): Change `assets.rb` to automatically append the paths of any directories under `app/assets` to the `Sprockets::Environment` object
- Rework `static` method for serving static files
- Revert static data accessor to be configured to `app/static` rather than the value of `settings.public_folder`
- Change `settings.public_folder` to `app/static/public` (to differentiate between static files which are public, and static files which should remain internal to the application unless exposed at other endpoints)

#### Minor changes

- (**`Gemfile`**): Remove `:production` symbol from what should be the test environment for requiring the `rspec`, `rack-test` and `should-matchers` gems
- (**`README.md`**): Remove `README.md` code highlighting, replace with screenshot of CLI

# [0.5.1](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.5.1)

#### Major changes

- Move policy role models from `app/models` to `app/models/roles` to avoid cluttering the `models` directory, preserving it for proper models such as `User`
- Add `lib/eucalypt/security/permissions.rb` to dynamically define permission methods for each policy in `app/policies` to avoid cluttering the policy file

#### Minor changes

- Change ActiveRecord default logging configuration to be less verbose

# [0.5.0](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.5.0)

#### Major changes

- Introduce IP whitelisting with the `Eucalypt::Whitelist` class, and IP-protected routes with the `ip_check` helper method
- Rework maintenance mode to be defined with a special route in the `ApplicationController`:

  ```ruby
  maintenance do
    static '/maintenance.html'
  end
  ```

  This redirects every route to this one. This special route is enabled or disabled through the `:maintenance` setting in `app.rb`.

#### Minor changes

- Introduce `static` controller class method for redirecting to, or rendering static HTML files stored in the `app/static` directory (this is essentially just an alias for `redirect`)
- Move `Eucalypt.require` directives to `eucalypt/load.rb` within the library rather than in the application
- Remove unnecessary `root` and `server` settings from `app.rb`
- Rename `config/asset_pipeline.rb` to `config/assets.rb`

# [0.4.2](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.4.2)

#### Major changes

- Add maintenance mode toggle from `app.rb` (in the form of a setting)
  - `enable :maintenance` redirects all routes to `static/maintenance.html`
  - `disable :maintenance` disables this feature

#### Minor changes

- Fix a minor whitespace issue in `config/asset_pipeline.rb` when blogging environment is setup

# [0.4.1](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.4.1)

#### Major changes

- **Improving the logging system**
  - Rename `log` folder to `logs`
  - Move logic out of `config/logging.rb` and into library file `eucalypt/core/helpers/logging.rb`
  - Add settings for logging customisation:
    - `:logging` - If `true`/`false`, indicates whether log messages will be seen, if a `Lumberjack::Severity`, then sets the severity of the logger
    - `:log_file` - Specifies whether or not to redirect `STDOUT` to a log file
    - `:log_directory_format` - Specifies the `DateTime` format for the name of the subdirectory in the `logs` folder where new logs are stored
  - Allow different customisations to be made depending on the environment

# [0.4.0](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.4.0)

#### Major changes

- Change default environment configuration for logging:
  - [ ] Disabled in `test` environment
  - [x] Enabled in `development` environment (displayed to `STDOUT`)
  - [x] Enabled in `production` environment (displayed in log file)
- Allow static files to be served from the `static` directory
- Change file name format for log files (to `YYYY-MM-DD_hh-mm-ss`)
- Add file support for static XML files

#### Minor changes

- Change gem destription
- Clean up README
- Change `spec/eucalypt` subdirectories name from old format `eucalypt-*` to just `*`
- Fix `spec_helper.rb` environment specification

# [0.3.5](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.3.5)

#### Major changes

- Use clearer variable names in `config/logging.rb`
- Remove comment about CSS reset in `application.scss`

#### Minor changes

- Add logo to README.md

# [0.3.4](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.3.4)

#### Major changes

- Fix bundle errors when running `eucalypt test` (by prefixing the `rspec spec` commands with `bundle exec`)

#### Minor changes

- Fix top-level array issue with `Static` class.
- Support both relative and absolute pathing for the `partial` helper method

# [0.3.3](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.3.3)

#### Major changes

- Change `Eucalypt::List` to CLI metaclass extension.
- Add `eucalypt rake` command for running database migrations with the command `bundle exec rake db:migrate`
- Require `active_support/core_ext/hash` before `sinatra` gem in order to silece ActiveSupport warning (Read [sinatra#1476](https://github.com/sinatra/sinatra/issues/1476))
- Add `partial` helper method for rendering partials in views
- Rename `application` manifest accessor method to `manifest`
- Bump `sinatra` lower version restriction to `>= 2.0.4`, making the overall version requirement `~> 2.0, >= 2.0.4`

#### Minor changes

- Delete `config/active_record.rb` and move ActiveRecord logging configuration to `config/logging.rb`

# [0.3.1](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.3.1)

#### Major changes

- Remove unnecessary comment in `config/active_record.rb`

# [0.3.0](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.3.0)

#### Major changes

- Change namespace directory names from `eucalypt-<namespace>` to just `eucalypt`
- Move Warden middleware to `config.ru`. This fixed a major bug with authentication where some POST routes in the `AuthenticationController` seemed to be undefined
- Remove `authorize` method from `config/pundit.rb`, since Pundit already comes with its own `authorize` method
- Fix `authorized?` method

#### Minor changes

- Delete `static/readme.yml`
- Move and rename `user_confirm.rb` file to `confirm.rb`

# [0.2.2](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.2.2)

#### Major changes

- Unhide `helper` CLI tasks from command list. The `generate helper` and `destroy helper` commands were being hidden due to the code that hides the `help` tasks using the following condition to find `help` tasks:

  ```ruby
  cmd.include?('help')
  ```

  Which would obviously include the `helper` tasks as well. This was changed to the following to unhide the helper tasks:

  ```ruby
  (/.*help.*/.match?(cmd) && /^(?!.*(helper))/.match?(cmd))
  ```

#### Minor changes

- Change default TODO spec example titles from:

  ```ruby
  it "should expect true to be true" do
    expect(true).to be false
  end
  ```

  to:

  ```ruby
  it "should expect true to be false" do
    expect(true).to be false
  end
  ```

# [0.2.1](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.2.1)

#### Major changes

- Move `root`, `path` and `glob` class methods to `eucalypt/root.rb`
- Add `require` class method for requiring files relative to root

The above features allowed `app.rb` to be cleaned up a bit.

#### Minor changes

- Change `Procfile` process type to use `eucalypt launch production` instead of `bundle exec bin rackup`
- Change `:environment` setting for Sprockets to `:assets` to avoid having the same name as the default `:environment` setting that indicates the current application environment (this also allowed all configuration files to be required with one directive instead of requiring logging first, then the rest of the configuration files)

# [0.2.0](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.2.0)

#### Major changes

- Add support for the generation of headless security policies (along with generating them through scaffolding). A headless policy can be specified with the `-H` option in the `generate scaffold` and `security generate policy` commands
- Add `authenticated?` method (alias `logged_in?`) to `config/warden.rb` for returning an explicit boolean value indicating whether or not there is a currently authenticated user
- Add `authorized?` method to `config/pundit.rb` for returning an explicit boolean value indicating whether or not the currently authenticated user is authorized to perform a given action on a given policy

  The `authorized?` method supports security policies with models, and also headless security policies.

  ```ruby
  # Old authorization check
  policy(Product).edit?  # With a model
  policy(:product).edit? # Without a model (headless)

  # New authorization check
  authorized? Product, :edit?  # With a model
  authorized? :product, :edit? # Without a model (headless)
  ```

  In addition to wrapping over Pundit's policy authorization methods, the `authorized?` method first checks that there is a currently authenticated user. If not, then the method returns false. This cleans up views by allowing conditionals like:

  ```ruby
  if authorized? Product, :edit?
    # ...
  end
  ```

  Instead of:

  ```ruby
  if authenticated? && policy(Product).edit?
    # ...
  end
  ```

- Configure test environment to log output to a log file
- Change log file names to include the current environment. Example:

  > - STDOUT log file: `production.stdout.log`
  > - STDERR log file: `production.stderr.log`


#### Minor changes

- Change `method_option` occurrences to `option` for CLI command option declarations (for consistency)
- Change `RACK_ENV` references to `APP_ENV` to reflect changes described in [sinatra/sinatra#984](https://github.com/sinatra/sinatra/pull/984)

# [0.1.3](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.1.3)

#### Major changes

- Transfer repository (along with documentation) to [eucalypt-framework](https://github.com/eucalypt-framework) organisation

  This meant changing a bunch of repository links, README badges (on the `eucalypt` and `eucalypt-book` repositories) and `gemspec` information.

- Change framework description from:

  > Micro-framework and CLI wrapped around the Sinatra DSL, for the generation and maintenance of structured web applications.

  To:

  > Micro-framework and CLI wrapped around the Sinatra DSL.

#### Minor changes

- Rename GitBook from `gum.gitbook.io` to `eucalypt.gitbook.io`

# [0.1.2](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.1.2)

#### Major changes

- Change structure of the logging directory and functionality of loggers

  Logs are now split into `stdout.log` and `stderr.log` files, which reside under a newly created subdirectory (with each server start) in the `log` directory. For example:

  ```elm
  log
  ├── 2018-08-21T20-26-23p0400
  │   ├── stderr.log
  │   └── stdout.log
  └── 2018-08-21T20-26-41p0400
      ├── stderr.log
      └── stdout.log
  ```

- Add rack environment argument mapping for `eucalypt launch`

  It is now possible to do:

  - `eucalypt launch p` as an alias for `eucalypt launch production`
  - `eucalypt launch d` as an alias for `eucalypt launch development`
  - `eucalypt launch t` as an alias for `eucalypt launch test`

#### Minor changes

- Add links to the GitBook documentation to `README`.
- Add documentation badge to `README`
- Add `Thor` gem to the features list in `README`

# [0.1.1](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.1.1)

#### Major changes

- Add `RSpec::Core` rake tasks to `Rakefile`, and make `spec` the default rake task

  (This fixed the issue with Travis CI not doing anything, since it was configured to use run with the `bundle exec rake` command)

- Change the description of the gem (in `README` and `eucalypt.gemspec`) from:

  > Micro-framework and CLI for the generation and maintenance of structured Sinatra web applications.

  to

  > Micro-framework and CLI wrapped around the Sinatra DSL, for the generation and maintenance of structured web applications.

#### Minor changes

- Add further information to the `README` file about initialization (particularly about making sure gem dependencies have been installed), the top-level `eucalypt` command and in-progress documentation
- Add features table to `README`
- Comment out `homepage` metadata in `eucalypt.gemspec` until documentation is ready
- Fix badge links in `README`

# [0.1.0](https://github.com/eucalypt-framework/eucalypt/releases/tag/v0.1.0)

#### Major changes

Nothing, initial release!