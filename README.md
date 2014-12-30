#Never Stop Building: The Blog 2.0
##Now with DropBlog!

[![Build Status](https://travis-ci.org/neverstopbuilding/dropblog.svg?branch=master)](https://travis-ci.org/neverstopbuilding/dropblog) [![Code Climate](https://codeclimate.com/github/neverstopbuilding/dropblog/badges/gpa.svg)](https://codeclimate.com/github/neverstopbuilding/dropblog) [![Test Coverage](https://codeclimate.com/github/neverstopbuilding/dropblog/badges/coverage.svg)](https://codeclimate.com/github/neverstopbuilding/dropblog)

Project documentation can be found at http://www.neverstopbuilding.com/dropblog



###Configuration
Most of the variables are stored in a `application.yml` file and used with figaro:

```
dropbox_user_id: ~~~
dropbox_access_token: ~~~
dropbox_app_key: ~~~
dropbox_app_secret: ~~~
dropbox_blog_dir: dropblog-test
AWS_ACCESS_KEY_ID: ~~~
AWS_SECRET_ACCESS_KEY: ~~~
S3_BUCKET: ~~~

production:
  dropbox_blog_dir: never-stop-building
  DOMAIN_NAME: ~~~
  SECRET_KEY_BASE: ~~~
  S3_BUCKET: ~~~
  FOG_PROVIDER: AWS
  FOG_DIRECTORY: ~~~
  ASSET_SYNC_GZIP_COMPRESSION: true

development:
  REDISTOGO_URL: 'redis://localhost:6379'
  RACK_ENV: development
  PORT: '3000'
```

Be sure to restart spring if you update the variables locally. And for loading them to heroku:

    figaro heroku:set -e production
