# 0.2.2

#### Major changes

- Unhide `helper` CLI tasks from command list. The `generate helper` and `destroy helper` commands were being hidden
  due to the code that hides the `help` tasks using the following condition to find `help` tasks:

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

# 0.2.1

#### Major changes

- Move `root`, `path` and `glob` class methods to `eucalypt/root.rb`.
- Add `require` class method for requiring files relative to root.

The above features allowed `app.rb` to be cleaned up a bit.

#### Minor changes

- Change `Procfile` process type to use `eucalypt launch production` instead of `bundle exec bin rackup`.
- Change `:environment` setting for Sprockets to `:assets` to avoid having the same name as the default `:environment` setting that indicates the current application environment (this also allowed all configuration files to be required with one directive instead of requiring logging first, then the rest of the configuration files).

# 0.2.0

#### Major changes

- Add support for the generation of headless security policies (along with generating them through scaffolding). A headless policy can be specified with the `-H` option in the `generate scaffold` and `security generate policy` commands.
- Add `authenticated?` method (alias `logged_in?`) to `config/warden.rb` for returning an explicit boolean value indicating whether or not there is a currently authenticated user.
- Add `authorized?` method to `config/pundit.rb` for returning an explicit boolean value indicating whether or not the currently authenticated user is authorized to perform a given action on a given policy.

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

- Configure test environment to log output to a log file.
- Change log file names to include the current environment. Example:

  > - STDOUT log file: `production.stdout.log`
  > - STDERR log file: `production.stderr.log`


#### Minor changes

- Change `method_option` occurrences to `option` for CLI command option declarations (for consistency).
- Change `RACK_ENV` references to `APP_ENV` to reflect changes described in [sinatra/sinatra#984](https://github.com/sinatra/sinatra/pull/984).

# 0.1.3

#### Major changes

- Transfer repository (along with documentation) to [eucalypt-framework](https://github.com/eucalypt-framework) organisation.

  This meant changing a bunch of repository links, README badges (on the `eucalypt` and `eucalypt-book` repositories) and `gemspec` information.

- Change framework description from:

  > Micro-framework and CLI wrapped around the Sinatra DSL, for the generation and maintenance of structured web applications.

  To:

  > Micro-framework and CLI wrapped around the Sinatra DSL.

#### Minor changes

- Rename GitBook from `gum.gitbook.io` to `eucalypt.gitbook.io`.

# 0.1.2

#### Major changes

- Change structure of the logging directory and functionality of loggers.

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

- Add rack environment argument mapping for `eucalypt launch`.

  It is now possible to do:

  - `eucalypt launch p` as an alias for `eucalypt launch production`
  - `eucalypt launch d` as an alias for `eucalypt launch development`
  - `eucalypt launch t` as an alias for `eucalypt launch test`

#### Minor changes

- Add links to the GitBook documentation to `README`.
- Add documentation badge to `README`.
- Add `Thor` gem to the features list in `README`.

# 0.1.1

#### Major changes

- Add `RSpec::Core` rake tasks to `Rakefile`, and make `spec` the default rake task.

  (This fixed the issue with Travis CI not doing anything, since it was configured to use run with the `bundle exec rake` command)

- Change the description of the gem (in `README` and `eucalypt.gemspec`) from:

  > Micro-framework and CLI for the generation and maintenance of structured Sinatra web applications.

  to

  > Micro-framework and CLI wrapped around the Sinatra DSL, for the generation and maintenance of structured web applications.

#### Minor changes

- Add further information to the `README` file about initialization (particularly about making sure gem dependencies have been installed), the top-level `eucalypt` command and in-progress documentation.
- Add features table to `README`.
- Comment out `homepage` metadata in `eucalypt.gemspec` until documentation is ready.
- Fix badge links in `README`.

# 0.1.0

#### Major changes

Nothing, initial release!