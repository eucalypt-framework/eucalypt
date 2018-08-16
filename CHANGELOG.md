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

# 0.1.0

#### Major changes

Nothing, initial release!