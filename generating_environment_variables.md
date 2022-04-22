# Generating environment variables

## Google

### Initial setup

- Create a project called Youtaite Network on your Google Cloud console: https://console.cloud.google.com/projectcreate
- Click "Select Project" for your new project in the notification window.
- Enable the [YouTube Data API v3](https://console.cloud.google.com/apis/library/youtube.googleapis.com) for the project.
- Configure the [consent screen](https://console.cloud.google.com/apis/credentials/consent).
  - Under "User Type", click "External" and then "Create".
  - Under "App Information", enter "Youtaite Network" for the app name and your email for user support email.
  - Under "Developer contact information", enter your email.
  - Click "Save and Continue" (3 times) and then "Back to Dashboard".

### Google API key

- Go to the [Credentials page](https://console.cloud.google.com/apis/credentials) for the project
- Click "Create Credentials" > "API key"
- Edit the API key that you just created
  - Application restrictions: None
  - API restrictions:
    - Click "Restrict key"
    - Select "YouTube Data API v3" from the combobox
- Click "Save"
- Copy the API key and replace the placeholder value in `.env.local`.

### Google client ID

- Go to the [Credentials page](https://console.cloud.google.com/apis/credentials) for the project
- Click "Create Credentials" > "OAuth client ID"
  - Application type: Web application
  - Name: Youtaite Network
  - Authorized JavaScript origins: http://localhost:8000
- Click "Create"
- Copy the client ID and replace the placeholder value in `.env.local`.

## Twitter

### Initial setup

- Follow the instructions on Twitter's [Getting Started page](https://developer.twitter.com/en/docs/twitter-api/getting-started/getting-access-to-the-twitter-api) to sign up for a developer account
- Go to the [Developer Portal](https://developer.twitter.com/en/portal/dashboard)
- Click "Create Project"
  - Project name: Youtaite Network
  - Use case: Building consumer tools (hobbyist)
  - Project description: Website for visualizing collaborations between content creators
  - App name: Youtaite Network @\<Twitter handle\>
- Copy the API Key, API Key Secret, and Bearer Token and replace the placeholder values in `.env.local`.
