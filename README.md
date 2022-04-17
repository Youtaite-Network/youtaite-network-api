# Youtaite Network API

## Initial setup

* If you don't have one already, install a Ruby version manager like rvm or rbenv (using your package manager)
* Check [.ruby-version](.ruby-version) for the current Ruby version
 * Using rbenv: `rbenv install <version>`
 * Using rvm: `rvm install <version>`
 * You may need to update your Ruby version manager for the version to be available
* Install bundler: `gem install bundler`
* From the repository directory: `bundle install`
 * If it doesn't work, you may have to run `bundle update` first
* Check that rails is installed by running `rails console` (or `rails c`) from the repository directory. This opens up a Ruby console where you should be able to run any Ruby commands - eg, `puts 'Hello World!'`.
* Set up the environment variables:
 * From the repository directory: `cp .env.local.example .env.local`
 * Generate a Google API key and client ID
 * Generate a Twitter API key, API secret, and bearer token
 * Replace the placeholder values in `.env.local` with your new values. Do not replace the values in `.env.local.example`.
* Set up your database: `rails db:reset`
 * Check to make sure it worked using `rails db`. This opens up a console where you can run postgresql on your development database.
  * Try running the following commands (all results should be greater than 0):
   * `select count(*) from people;`
   * `select count(*) from collabs;`
   * `select count(*) from roles;`
 * If it didn't work, there may be something wrong with one of your API secrets
* Try starting the server using the instructions below

## Start the server

* From the repository directory: `rails server` (or `rails s`)
* If it worked, you should be able to access `localhost:3000/roles`, `localhost:3000/people`, or `localhost:3000/collabs`.

## License
This project is licensed under the terms of the MIT license.
