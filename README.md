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
# Apache Taverna Databundle Viewer

[![Code Climate](https://codeclimate.com/github/Samhane/incubator-taverna-databundle-viewer/badges/gpa.svg)](https://codeclimate.com/github/Samhane/incubator-taverna-databundle-viewer)
[![Test Coverage](https://codeclimate.com/github/Samhane/incubator-taverna-databundle-viewer/badges/coverage.svg)](https://codeclimate.com/github/Samhane/incubator-taverna-databundle-viewer/coverage)
[![Build Status](https://semaphoreci.com/api/v1/projects/f0bcedbf-b6fb-4605-975a-72e724706673/442177/badge.svg)](https://semaphoreci.com/samhane/incubator-taverna-databundle-viewer)

Apache Taverna Databundle Viewer is planned as a web interface
for displaying 
[Taverna databundles](https://github.com/apache/incubator-taverna-language/tree/master/taverna-databundle)
(workflow inputs/outputs/run), as produced by the 
[Apache Taverna](http://taverna.incubator.apache.org/) workflow
system.

This module is **work in progress** as part of Google Summer of Code 2015.

You can see working prototype there: [DataBundleViewer](http://databundle.herokuapp.com/)



## License

(c) 2015 Apache Software Foundation

This product includes software developed at The [Apache Software
Foundation](http://www.apache.org/).

Licensed under the [Apache License
2.0](https://www.apache.org/licenses/LICENSE-2.0), see the file
[LICENSE](LICENSE) for details.

The file [NOTICE](NOTICE) contain any additional attributions and
details about embedded third-party libraries and source code.


# Contribute

Please subscribe to and contact the 
[dev@taverna](http://taverna.incubator.apache.org/community/lists#dev mailing list)
for any questions, suggestions and discussions about the 
Apache Taverna Databundle Viewer.

Bugs and feature plannings are tracked in the Jira
[Issue tracker](https://issues.apache.org/jira/browse/TAVERNA/component/12326902)
under the `TAVERNA` component _GSOC Taverna Databundle Viewer_. Feel free 
to add an issue!

To suggest changes to this source code, feel free to raise a 
[GitHub pull request](https://github.com/apache/incubator-taverna-databundle-viewer/pulls).
Any contributions received are assumed to be covered by the [Apache License
2.0](https://www.apache.org/licenses/LICENSE-2.0). We might ask you 
to sign a [Contributor License Agreement](https://www.apache.org/licenses/#clas)
before accepting a larger contribution.


# Building and install requirements

1. Install Ruby 2.2.1. With using rvm - `rvm install 2.2.1`
2. Run `bin/setup` to install dependencies, create and set up database. By default used PostgreSQL
3. Run server with command `rails s`

For using omniauth you need set up environmental variables FACEBOOK_CLIENT_ID, FACEBOOK_CLIENT_SECRET, GOOGLE_CLIENT_ID, GOOGLE_CLIENT_SECRET.

For Google omniauth:

1. Visit [Console google](https://console.developers.google.com/). Click by link `APIs & auth` -> `Credentials` -> `Create new Client ID`
2. Set Redirect URIs as http://yoursite.com/users/auth/google_oauth2/callback
3. Enable Google+ API. Click by link `APIs & auth` -> `Google+ API` -> `Enable API`

For Facebook omniauth:

1. Visit [Developers Facebook](https://developers.facebook.com/)
2. Click by `My Apps` -> `Add a New App`
3. Visit `Settings` -> `Advanced`. Fill in field `Valid OAuth redirect URIs` with http://yoursite.com/users/auth/facebook/callback


_TODO_

* ...


# Usage

_TODO_

* ...

# Documentation

_TODO_

* ...
