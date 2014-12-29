#Never Stop Building: The Blog 2.0
##Now with DropBlog!

[![Build Status](https://travis-ci.org/neverstopbuilding/dropblog.svg?branch=master)](https://travis-ci.org/neverstopbuilding/dropblog) [![Code Climate](https://codeclimate.com/github/neverstopbuilding/dropblog/badges/gpa.svg)](https://codeclimate.com/github/neverstopbuilding/dropblog) [![Test Coverage](https://codeclimate.com/github/neverstopbuilding/dropblog/badges/coverage.svg)](https://codeclimate.com/github/neverstopbuilding/dropblog)

Check out the full project info at http://www.neverstopbuilding.com/dropblog

###Background

I'm kinda lazy and updating my blog is the last thing I really want to do. However, I do keep documentation on the projects I work on, and there has got to be a way to use software to manage the actual blog part. 

The idea for this is that I could create a simple folder structure in DropBox, with some basic rules, and write a set of tools that would automate the publication of the blog with pictures and all that jazz.

There are some good tools, like the DropBox API, RMagick and Jekyll that I could use to manage the blog itself. So I should only need to write markdown, put pictures in a folder, and add some sort of meta data to the pictures.

###Folder structure
Because I think in terms of "projects" as well as have one off articles, I'd like to organize my files like that:

```
    blog
        projects
            public
                project-one-slug
                    project.md
                    articles
                        article-one-slug.md
                    pictures
                        photo-one.jpg
                project-two-slug
                    project.md
                    articles
                        another-article-one-slug.md
                    pictures
                        another-photo-one.png
        articles
            one-off-article-slug
                article.md
                image1.png
                image2.png
```


###What's Cool
This structure is cool because I don't even need to use this folder for just the blog, so I could store all sorts of things in the project folder, and depend on the software to ignore the other supporting files. I can just drag and drop pictures to my image folder and depend on the software to load them into the article or make a photo gallery. I can depend on other tools to format the pictures and manage publication. 

Also, updating will be effortless, I can just edit markdown files to fix typos. I could just drag in more pictures to drop box to add more pictures to the project. I can use some sort of meta data to manage publication dates and article settings. I'm just gonna edit files on my computer and let software handle all the BS.

###Proposed Architecture

<img src="https://docs.google.com/drawings/d/1_RW2Ro0tOObCKw6MndtMXYpX_LX6PVnoWZsoa1WI9Yw/pub?w=960&amp;h=720">

- Use the dropbox webhook to notify the application of file changes.
- Use a worker process to do the heavy lifting of downloading the changed files, processing pictures, publishing processed pictures to S3, storing image information in the database, updating blog content in the database
- A simple rails application will serve as both the API side and the front facing website which can be modified and published automatically with CI
- We can explore using a caching layer so that each request doesn't re parse the blog markdown
- Since only changed files will be re-updated, we won't constantly process pictures.

###Image Syntax
The whole point of this adventure is to make authoring seamless within dropbox. As such I can use the standard markdown syntax for pictures `![](../path.jpg)` with relative paths to pictures in the related pictures folder or simply the article folder. When dropbox updates occur, all these images are put through a processor and synced to S3, with their path information saved and associated to an article or project. 

Later when the stored markdown with the simple paths is rendered, we can key off the file name to discover the hosted image path.

That is, we are rendering some article and know some file name, so we can say "hey give me the path for this article's image with the file name xyz." File names are of course unique for any article/project folder.

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

###Processing

- http://dev.iron.io/solutions/image-processing/
- https://github.com/iron-io/iron_worker_examples/tree/master/ruby_ng/image_processing
- https://github.com/iron-io/iron_worker_rails_example
- another thing to consider: http://cloudinary.com/documentation/image_transformations

###Testing Concerns and Models
- http://stackoverflow.com/questions/16525222/how-to-test-a-concern-in-rails
- http://everydayrails.com/2012/03/19/testing-series-rspec-models-factory-girl.html

###Good Markdown 
- https://www.reinteractive.net/posts/43-activeadmin-and-markdown-on-your-15-minute-blog-part-4
