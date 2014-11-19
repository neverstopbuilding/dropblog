#DropBlog

[![Build Status](https://travis-ci.org/neverstopbuilding/dropblog.svg?branch=master)](https://travis-ci.org/neverstopbuilding/dropblog) [![Code Climate](https://codeclimate.com/github/neverstopbuilding/dropblog/badges/gpa.svg)](https://codeclimate.com/github/neverstopbuilding/dropblog) [![Test Coverage](https://codeclimate.com/github/neverstopbuilding/dropblog/badges/coverage.svg)](https://codeclimate.com/github/neverstopbuilding/dropblog)

I'm kinda lazy and updating my blog is the last thing I really want to do. However, I do keep documentation on the projects I work on, and there has got to be a way to use software to manage the actual blog part. 

The idea for this is that I could create a simple folder structure in drop box, with some basic rules, and write a set of tools that would automate the publication of the blog with images and all that jazz.

There are some good tools, like the DropBox API, RMagick and Jekyll that I could use to manage the blog itself. So I should only need to write markdown, put images in a folder, and add some sort of meta data to the images.

##Folder structure
Because I think in terms of "projects" as well as have one off articles, I'd like to organize my files like that:

```
    blog
        projects
            project-one-slug
                articles
                    article-one-slug.md
                images
                    photo-one.jpg
            project-two-slug
                articles
                    another-article-one-slug.md
                images
                    another-photo-one.png
        articles
            one-off-article-slug
                article.md
                image1.png
                image2.png
```


##What's Cool
This structure is cool because I don't even need to use this folder for just the blog, so I could store all sorts of things in the project folder, and depend on the software to ignore the other supporting files. I can just drag and drop images to my image folder and depend on the software to load them into the article or make a photo gallery. I can depend on other tools to format the images and manage publication. 

Also, updating will be effortless, I can just edit markdown files to fix typos. I could just drag in more images to drop box to add more images to the project. I can use some sort of meta data to manage publication dates and article settings. I'm just gonna edit files on my computer and let software handle all the BS.

##Proposed Architecture

<img src="https://docs.google.com/drawings/d/1_RW2Ro0tOObCKw6MndtMXYpX_LX6PVnoWZsoa1WI9Yw/pub?w=960&amp;h=720">

- Use the dropbox webhook to notify the application of file changes.
- Use a worker process to do the heavy lifting of downloading the changed files, processing images, publishing processed images to S3, storing image information in the database, updating blog content in the database
- A simple rails application will serve as both the API side and the front facing website which can be modified and published automatically with CI
- We can explore using a caching layer so that each request doesn't re parse the blog markdown
- Since only changed files will be re-updated, we won't constantly process images.
