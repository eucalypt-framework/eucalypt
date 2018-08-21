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