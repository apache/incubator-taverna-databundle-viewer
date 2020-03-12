<!--
   Licensed to the Apache Software Foundation (ASF) under one or more
   contributor license agreements.  See the NOTICE file distributed with
   this work for additional information regarding copyright ownership.
   The ASF licenses this file to You under the Apache License, Version 2.0
   (the "License"); you may not use this file except in compliance with
   the License.  You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License.
-->


## Taverna Project Retired

> tl;dr: The Taverna code base is **no longer maintained** 
> and is provided here for archival purposes.

From 2014 till 2020 this code base was maintained by the 
[Apache Incubator](https://incubator.apache.org/) project _Apache Taverna (incubating)_
(see [web archive](https://web.archive.org/web/20200312133332/https://taverna.incubator.apache.org/)
and [podling status](https://incubator.apache.org/projects/taverna.html)).

In 2020 the Taverna community 
[voted](https://lists.apache.org/thread.html/r559e0dd047103414fbf48a6ce1bac2e17e67504c546300f2751c067c%40%3Cdev.taverna.apache.org%3E)
to **retire** Taverna as a project and withdraw the code base from the Apache Software Foundation. 

This code base remains available under the Apache License 2.0 
(see _License_ below), but is now simply called 
_Taverna_ rather than ~~Apache Taverna (incubating)~~.

While the code base is no longer actively maintained, 
Pull Requests are welcome to the 
[GitHub organization taverna](http://github.com/taverna/), 
which may infrequently be considered by remaining 
volunteer caretakers.


### Previous releases

This code base has not yet been formally released.


# Apache Taverna Databundle Viewer

[![Code Climate](https://codeclimate.com/github/Samhane/incubator-taverna-databundle-viewer/badges/gpa.svg)](https://codeclimate.com/github/Samhane/incubator-taverna-databundle-viewer)
[![Test Coverage](https://codeclimate.com/github/Samhane/incubator-taverna-databundle-viewer/badges/coverage.svg)](https://codeclimate.com/github/Samhane/incubator-taverna-databundle-viewer/coverage)
[![Build Status](https://semaphoreci.com/api/v1/projects/f0bcedbf-b6fb-4605-975a-72e724706673/442177/badge.svg)](https://semaphoreci.com/samhane/incubator-taverna-databundle-viewer)

Apache Taverna Databundle Viewer is planned as a web interface
for displaying 
[Taverna databundles](https://github.com/apache/incubator-taverna-language/tree/master/taverna-databundle)
(workflow inputs/outputs/run), as produced by the 
[Apache Taverna](https://web.archive.org/web/*/https://taverna.incubator.apache.org/) workflow
system.

This module is **work in progress** as part of Google Summer of Code 2015.

You can see working prototype there: [DataBundleViewer](http://databundle.herokuapp.com/)



## License

(c) 2014-2020 Apache Software Foundation

This product includes software developed at The [Apache Software
Foundation](http://www.apache.org/).

Licensed under the [Apache License
2.0](https://www.apache.org/licenses/LICENSE-2.0), see the file
[LICENSE](LICENSE) for details.

The file [NOTICE](NOTICE) contain any additional attributions and
details about embedded third-party libraries and source code.


# Contribute

Any contributions received are assumed to be covered by the [Apache License
2.0](https://www.apache.org/licenses/LICENSE-2.0). We might ask you 
to sign a [Contributor License Agreement](https://www.apache.org/licenses/#clas)
before accepting a larger contribution.


# Building and install requirements

**Requirements**

* [rvm](https://rvm.io/rvm/install)
* ruby, installed with rvm (`rvm install 2.2.1`)
* [node](http://nodejs.org) ([on github](https://github.com/joyent/node))
* [bower](https://github.com/bower/bower) (>= 0.10.0) installed with npm
* `libwebkit-dev` or equivalent, try  `sudo apt install libwebkit-dev qt4-qmake libqt4-dev`

**Set up**

1. Run `bin/setup` to install dependencies, create and set up database. By default used PostgreSQL
2. Run `rake bower:install`  to install front-end assets

**Set up omniauth**

Google omniauth:

1. Visit [Console google](https://console.developers.google.com/). Click by link `APIs & auth` -> `Credentials` -> `Create new Client ID`
2. Set Redirect URIs as http://yoursite.com/users/auth/google_oauth2/callback
3. Enable Google+ API. Click by link `APIs & auth` -> `Google+ API` -> `Enable API`
4. Set up environmental variables  GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET

Facebook omniauth:

1. Visit [Developers Facebook](https://developers.facebook.com/)
2. Click by `My Apps` -> `Add a New App`
3. Visit `Settings` -> `Advanced`. Fill in field `Valid OAuth redirect URIs` with http://yoursite.com/users/auth/facebook/callback
4. Set up environmental variables FACEBOOK_CLIENT_ID, FACEBOOK_CLIENT_SECRET

**Set up the AWS S3 for storage files in production environment**

1. Visit [AWS Console](https://aws.amazon.com/)
2. Open the Amazon S3 console.
3. Click Create Bucket.
4. In the Create a Bucket dialog box enter a name and select a region.
5. Click on the name of your account (it is located in the top right corner of the console). Then, in the expanded drop-down list, select Security Credentials.
6. Click the Get Started with IAM Users button.
7. Click the Create New Users
8. Enter User Name(s) and click the Create
9. Click the Download Credentials
10. Set up environmental variables S3_KEY, S3_SECRET, S3_REGION, S3_ASSET_URL, S3_BUCKET_NAME

**Ways to set up environmental variables**

1. Set Unix Environment Variables
2. Use a local .env file. Template you can find in .env.example file
3. Set environmental variables as parameters to command `rails s`

Don't forget: Keeping Environment Variables Private


# Usage

**In development environment**

1. Run server with command `rails s`
2. Open in the browser a address `http://localhost:3000`

**In production environment**

1. Run `rake assets:precompile`
2. Run server with command `RAILS_ENV=production rails s`
3. Open in the browser a address `http://localhost:3000`

Also you can deploy this application to [Heroku](http://heroku.com/)

For upload new databundle file, you need to be logged in.
You may log in with your facebook or google account, or register in DataBundle viewer site.

When you logged in, you can upload databundle file in box 'New Databundle'. Enter name for the databundle and choose file to upload.

After click on 'Save' you will see information about workflow run:

1. Workflow name
2. Authors of the workflow
3. Titles
4. Description

And also you will see dataflow diagram of workflow run. You can click on edges of the graph to see what value produced by this step

# Documentation

Dependencies listed in [Gemfile](Gemfile) (gems) and in [bower.json](bower.json) (front-end assets)

Licenses to every dependency presented in [DEPENDENCY_LICENSES.md](DEPENDENCY_LICENSES.md) file

Main classes of the application:

1. [DataBundleDecorator](app/decorators/data_bundle_decorator.rb): access to data_bundle file as ro_bundle.
Methods for get inputs/outputs/intermediates values

2. [DataBundle](app/models/data_bundle.rb): necessary constants, and logic by extract data_bundle file after upload

Visualization component in [data_bundle.coffee](app/assets/javascripts/data_bundle.coffee)

# Todo

1. Better visualization

2. Show intermediates run results with taverna-prov

3. Docker image with auto install dependencies and run server
