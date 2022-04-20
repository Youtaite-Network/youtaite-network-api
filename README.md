# Youtaite Network API

## Initial setup

* Clone the repository: `git clone git@github.com:Youtaite-Network/youtaite-network-api.git`
 * If it doesn't work, you may have to [set up an SSH key with GitHub](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)
* Go into the repository directory: `cd youtaite-network-api`
* Install the correct version of Ruby using a Ruby version manager
 * If you don't have one already, install a Ruby version manager like rvm or [rbenv](https://github.com/rbenv/rbenv)
 * Check [.ruby-version](.ruby-version) for the current Ruby version: `cat .ruby-version`
  * Using rbenv: `rbenv install <version>`
  * Using rvm: `rvm install <version>`
* Install bundler: `gem install bundler`
* Install dependencies: `bundle install` (or `bundle`)
 * If it doesn't work, you may have to run `bundle update` first
* Restart your terminal and `cd` back into the repository directory if necessary.
* Check that rails is installed by running `rails console` (or `rails c`) from the repository directory. This opens up a Ruby console where you should be able to run any Ruby commands - eg, `puts 'Hello World!'`.
* Set up the environment variables:
 * From the repository directory: `cp .env.local.example .env.local`
 * Generate new environment variables using instructions below
 * Replace the placeholder values in `.env.local` with your new values. Do not replace the values in `.env.local.example`.
* Set up your database: `rails db:reset`
 * Check to make sure it worked using `rails db`. This opens up a console where you can run postgresql on your development database.
  * Try running the following commands (all results should be greater than 0):
   * `select count(*) from people;`
   * `select count(*) from collabs;`
   * `select count(*) from roles;`
 * If it didn't work, there may be something wrong with one of your API secrets
* Try starting the server using the instructions below

### Generate environment variables

#### Google

* Create a project called Youtaite Network on your Google Cloud console: https://console.cloud.google.com/projectcreate
* Click "Select Project" for your new project in the notification window.
* Enable the [YouTube Data API v3](https://console.cloud.google.com/apis/library/youtube.googleapis.com) for the project.
* Go to the [Credentials page](https://console.cloud.google.com/apis/credentials) for the project.
* Click "Create Credentials" > "API key".
* Edit the API key that you just created.
 * Under "Application restrictions", click "IP addresses" and add "127.0.0.1".
 * Under "API restrictions", click "Restrict key" and select "YouTube Data API v3" from the combobox.
* Configure the [consent screen](https://console.cloud.google.com/apis/credentials/consent).
 * Under "User Type", click "External" and then "Create".
 * Under "App Information", enter "Youtaite Network" for the app name and your email for user support email.
 * Under "Developer contact information", enter your email.
 * Click "Save and Continue" (3 times) and then "Back to Dashboard".
* Go to the [Credentials page](https://console.cloud.google.com/apis/credentials) and click "Create Credentials" > "OAuth client ID".
 * For the application type, select "Web application".
 * Enter "Youtaite Network" for the name.
 * Add "http://localhost:8000" to "Authorized JavaScript origins".
 * Click "Create".

#### Twitter

## Start the server

* From the repository directory: `rails server` (or `rails s`)
* If it worked, you should be able to access `localhost:3000/roles`, `localhost:3000/people`, or `localhost:3000/collabs`.

## License
This project is licensed under the terms of the MIT license.
