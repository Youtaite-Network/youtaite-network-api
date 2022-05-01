# Youtaite Network API

## Initial setup

- [Fork the repository](https://docs.github.com/en/get-started/quickstart/fork-a-repo)
- Clone your fork of the repository: `git clone git@github.com:<username>/youtaite-network-api.git`
  - If it doesn't work, you may have to [set up an SSH key with GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
- Go into the repository directory: `cd youtaite-network-api`
- Configure the original repository as the upstream remote: `git remote add upstream https://github.com/youtaite-network/youtaite-network-api.git`
- Install the correct version of Ruby using a Ruby version manager
  - If you don't have one already, install a Ruby version manager like rvm or [rbenv](https://github.com/rbenv/rbenv)
  - Check [.ruby-version](.ruby-version) for the current Ruby version: `cat .ruby-version`
    - Using rbenv: `rbenv install <version>`
    - Using rvm: `rvm install <version>`
- Install bundler: `gem install bundler`
- Install dependencies: `bundle install` (or `bundle`)
  - If it doesn't work, you may have to run `bundle update` first
- Check that rails is installed by running `rails console` (or `rails c`) from the repository directory. This opens up a Ruby console where you should be able to run any Ruby commands - eg, `puts 'Hello World!'`.
  - If it doesn't work, try restarting your terminal. If necessary, `cd` back into the repository directory before re-running `rails c`.
- Set up the environment variables:
  - From the repository directory: `cp .env.local.example .env.local`
  - [Generate new environment variables](generating_environment_variables.md)
  - Replace the placeholder values in `.env.local` with your new values. Do not replace the values in `.env.local.example`.
- Set up your database: `rails db:reset`
  - Check to make sure it worked using `rails db`. This opens up a console where you can run postgresql on your development database.
    - Try running the following commands (all counts should be greater than 0):
      - `select count(*) from people;`
      - `select count(*) from collabs;`
      - `select count(*) from roles;`
      - `select * from people limit 10;`: Make sure the data looks right
  - If it didn't work, there may be something wrong with one of your API secrets
- Start the server: `rails s`

## Start the server

- From the repository directory: `rails server` (or `rails s`)
- If it worked, you should be able to access `localhost:3000/roles`, `localhost:3000/people`, or `localhost:3000/collabs`.

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License
This project is licensed under the terms of the MIT license.
