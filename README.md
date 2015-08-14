[ ![Codeship Status for policy-wiki-educational-foundation/debate-summary](https://codeship.com/projects/3326a590-1f2a-0133-bd40-4edf2c514030/status?branch=master)](https://codeship.com/projects/95478)

# Debate Summary

Debate Summary is open-sourced version of [ShouldWe](http://www.shouldwe.org), free to copy and modify (see [LICENSE](./LICENSE)).

## Prerequisites

* [PostgreSQL 9.3](http://www.postgresql.org/) - Production Database storage
* [Redis](http://redis.io/) - Key-value store database
* [Node.js][node.js] - Assets compilation and JavaScript Testing
* [Ruby 1.9.3-p194][ruby] - Ruby Language
* [Bundler 1.2](http://gembundler.com/v1.2/) - Application Dependancies management

### Saddening Prerequisites

* LibV8 - to satify TheRubyRacer. [read this](http://stackoverflow.com/a/14080341/580513)

## Quick Setup (Mac OS X)
```
brew install postgresql nodejs phantomjs rbenv ruby-build redis

ruby_build 1.9.3-p194 ~/.rbenv/versions/1.9.3-p194
rbenv rehash
rbenv use 1.9.3-p194

gem install bundler
npm install
bundle install
```

## Application Database setup

Create and load database

    bundle exec rake db:create db:schema:load db:migrate
    bundle exec rake db:seed
    bundle exec rake db:test:prepare


## Application Environment Variables

You will need to create a developer account on the following:
* [Twitter](https://apps.twitter.com/), [LinkedIn](https://www.linkedin.com/developer/apps) and [Facebook](https://developers.facebook.com/apps) to authenticate.
* [Amazon WebServices](https://console.aws.amazon.com/iam/home#users) for image assets uploads.
* [Mandrill](https://mandrillapp.com/login/) or [Mailchimp](https://login.mailchimp.com/) for email services.
* [Microsoft Azure Marketplace - Bing Search API](https://datamarket.azure.com/dataset/bing/search) for related issues.


You will need to define the following environment variables in your bash config or `.env` file in this project.

    export AZURE_DATAMARKET_API_KEY=XXXXXXXXXX
    export AWS_REGION=us-east-1
    export AWS_ACCESS_KEY_IDXXXXXXXXXX
    export AWS_SECRET_ACCESS_KEY=XXXXXXXXXX
    export SMTP_ADDRESS=smtp.mandrillapp.com
    export SMTP_USERNAME=example
    export SMTP_PASSWORD=supersecret
    export FACEBOOK_API_KEY=XXXXXXXXXX
    export FACEBOOK_API_SECRET=XXXXXXXXXX
    export TWITTER_API_KEY=XXXXXXXXXX
    export TWITTER_API_SECRET=XXXXXXXXXX
    export LINKEDIN_API_KEY=XXXXXXXXXX
    export LINKEDIN_API_SECRET=XXXXXXXXXX
    export REDIS_URL=redis://localhost:6379/0

The OAuth callback url's are:

* http://{DEBATE_SUMMARY_URL}/users/auth/linkedin/callback
* http://{DEBATE_SUMMARY_URL}/users/auth/twitter/callback
* http://{DEBATE_SUMMARY_URL}/users/auth/facebook/callback

### PostgreSQL Setup

You'll need to enable `unaccent` extension on the database:

    $ psql -c 'create extension "unaccent"; ALTER TEXT SEARCH DICTIONARY unaccent (RULES="unaccent");' -d debate_summary_development
    $ psql -c 'create extension "unaccent"; ALTER TEXT SEARCH DICTIONARY unaccent (RULES="unaccent");' -d debate_summary_test

This should enable full text search.

## Developing

Use invoker to start PostgreSQL, Redis and the Application development environment

    bundle exec invoker start invoker.ini

Invoker starts the following processes:

    postgres -D /usr/local/var/postgres
    redis-server
    bundle exec passenger start -p 5000
    bundle exec sidekiq -c 1

Web Application will be served on:

    http://localhost:5000


If you want to check outgoing emails, you can run [mailcatcher][mailcatcher] to observe mail without actually sending.

1. `$ mailcatcher`
2. go to [localhost:1080](http://localhost:1080)

## Testing
### Ruby

Ruby is tested using the standard rails testing library.

    bundle exec rake test

### JavaScript

Testem is the main runtime that runs JavaScript unit tests.

    ./node_modules/.bin/testem

[Test'em][testem] will boot you can connect any browser with [Testem][testem] using [http://localhost:7357](http://localhost:7357)

## Deploying

### Heroku

Here is a quick example to get Debate Summary deployed on a heroku instance.

*Note: Replace the `heroku config:set` with your own Environment variables*

    heroku create --buildpack https://github.com/heroku/heroku-buildpack-ruby
    heroku config:set FACEBOOK_APP_KEY= FACEBOOK_SECRET_KEY= TWITTER_API_KEY= TWITTER_API_SECRET= LINKEDIN_APP_KEY= LINKEDIN_SECRET_KEY= SMTP_ADDRESS=smtp.mandrillapp.com SMTP_USERNAME= SMTP_PASSWORD= AWS_REGION=us-east-1 AWS_ACCESS_KEY_ID= AWS_SECRET_ACCESS_KEY= AZURE_DATAMARKET_API_KEY=
    heroku pg:psql <db/structure.sql
    heroku run rake --trace db:migrate db:seed

## License

Copyright (C) 2015 Policy Wiki Educational Foundation LTD <hello@shouldwe.org>, (see [License](./LICENSE))


[ruby]:http://www.ruby-lang.org/en/news/2012/04/20/ruby-1-9-3-p194-is-released/
[node.js]:http://nodejs.org/
[npm]:https://npmjs.org/
[testem]:https://github.com/airportyh/testem
[mailcatcher]:http://mailcacher.me
