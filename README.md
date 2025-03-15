# ijabat-lang-study

The following project builds a SQLite database of Basic Christian teaching search terms, pulling from a curated list of languages compiled from the [2025 World Watch List](https://www.opendoorsus.org/en-US/persecution/countries) from Open Doors USA, a database ranking nations where Christians face the most extreme persecution.

---

# Study Results

Study results are published in `/studies`

- [Study 001](/studies/study_001.md) - Presence of Cults Among Google Top 10 Search Results By Language
- [Study 002](/studies/study_002.md) - Efforts That Could Easily Achieve Google Top 10 by Language
- [Study 003](/studies/study_003.md) - Top Domains Across Languages
- [Study 004](/studies/study_004.md) - "Christianity" Keyword Google Trends
- [Study 004=5](/studies/study_005.md) - "Stepping Stones" Topic Language Study

---

# Dependencies

project was built using ruby 3.2.2 (2023-03-30 revision e51014f9c0) [x86_64-darwin23]

You will need the following third party dependencies:
- Google Programmable Search Engine
- Google Custom Search API enabled
- OpenAI API Platform enabled
- *Optional, you can download a SQLite GUI from [SQLite Browser](https://sqlitebrowser.org/) to open, view and interact with the SQL tables.
- [TODO] add a user interface, currently scripts just populate the database where you can retrieve data manually

(I think the study cost me less than $5 to assemble and pay Google and OpenAI, I wasn't keeping track, but know that it does cost money to run)

Just an FYI - Because I use many programming languages across many projects, it is useful for me to make one command line interface to manage all scripts, I use Makefile (the command `make`) for this purpose, no matter what language i'm programming in, all I need to remember is Makefile is where I assemble my CLI commands, rather than remembering individual CLI scripts by language.


---

# Installation
```bash
$ bundle install
```

# initialize an empty dotenv file
Feel free to implement this a different way if you are using something like docker, or if you prefer managing your environment variables in a safer way, `.env.development` is found in the `.gitignore`

```bash
$ touch .env.development
```

# Programmable Search Engine Setup
You will need to be able to make programmatic queries to the Google Search Engine via API requests

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

# OpenAI API Platform enabled
You will need openAI API access in order to translate words into other languages. You will need to sign up, create an API key, and configure access to use the OpenAI API.

- Sign Up and Access OpenAI API
  - Go to the OpenAI Platform
  - Click on "Sign Up" or "Log In" if you already have an account.
  - Verify your email and phone number if prompted.
- Create an API Key
  - Navigate to API Keys.
  - Click "Create API Key".
  - Copy the API key and store it in your ENV. (For security reasons, you won’t be able to see it again.)
- Enable Billing (Required for full access)
  - Go to the Billing Page.
  - Add a payment method or check available free credits.

in your `.env.development` file, add the following environment variable
```
OPENAI_API_KEY=<your_api_key_value>
```

---

# Step 1) Build the Database

The following will
- create the local SQLite database
- run a migration adding the database models (tables)
- populate the supported languages from `data/lang_map.yaml` into the database
- populate the supported categories from `data/categories.yaml` into the database
- populate the supported terms (key words) from `data/categories.yaml` into the database and relate them to categories

```bash
$ make initialize
```

# Step 2) Translate the English search terms into 20+ languages

The following will iterate over each term in the database and obtain a translation of that phrase from OpenAI. It will take a while.

```bash
$ make translate_terms
```

# Step 3) Obtain search result data from Google

For each term, search google and store first page result domains in the database, with the total number of query results available from Google. It will give us a metric to use later.

```bash
$ make fill_webdata
```

# Step 4) Enrich the data

Using the search results
- determine if search results include known cults
- iterate over all the google data and determine how easy or hard it would be to write content that would bubble up to the top of the search results (build a result score)
- look at all the domains by count to see what domains are seen the most across the board

```bash
$ make enrich_data
```

# Step 5) Access the Data

Right now, you can access the data directly in SQL (SQLite GUI from [SQLite Browser](https://sqlitebrowser.org/)). The `terms` table will display the number of results by language for each search term, it will include the different web domains that came back in the search results, and will tell you whether or not cults were found in the top 10 results for that search term.

It will also tell you how easy or difficult it will be for an article to achieve a high SEO score if someone writes an article or translates an article into that language, with the given search term.

# Troubleshooting
You can obliterate and delete the database by running the reset script
Because its SQLite, you can safely delete the file, no harm will be done, and start over.

The following script deletes the database files in `db/*`, while leaving the migration scripts in tact so you can start over.

```bash
$ make reset
```
