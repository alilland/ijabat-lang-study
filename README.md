# ijabat-lang-study

project was built using ruby 3.2.2 (2023-03-30 revision e51014f9c0) [x86_64-darwin23]

You will need the following third party dependencies:
- Google Programmable Search Engine
- Google Custom Search API enabled

---


# Installation Dependencies
```bash
$ bundle install
```

# initialize Dotenv File
```bash
$ touch .env.development
```

# Programmable Search Engine Setup
You will need to be able to make programatic queries to the Google Search Engine via API requests

- Go to [Google Programmable Search Engine](https://programmablesearchengine.google.com/about/).
- Click Create a search engine.
- Set it to search the entire web.
- Once created, go to Setup > Search engine ID.
- Copy the "cx" value, which is your Custom Search Engine ID.

in your `.env.development` file, add the following environment variable
```
GOOGLE_CSE_ID=<your_cx_value>
```

# Custom Search API
You will need to enable and generate API credentials to access the Custom Search API.

- Go to the [Google Cloud Console](https://console.cloud.google.com/)
- Create or Select a Project
  - Click on the "Select a project" dropdown at the top.
  - Click "New Project" if you don’t already have one.
  - Give it a name (e.g., Custom Search API Project) and click Create.
- Enable the Custom Search API:
  - Go to the API Library in Google Cloud Console.
  - Search for "Custom Search API".
  - Click Enable.
- Create API Credentials (API Key):
  - Go to APIs & Services > Credentials.
  - Click "Create Credentials" > "API Key".
  - A new API Key will be generated. Copy this key.

in your `.env.development` file, add the following environment variable
```
GOOGLE_API_KEY=<your_api_key_value>
```
