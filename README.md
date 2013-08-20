HelloGlass
==========

This is a very simple Hello Glass application written using [Sinatra](http://www.sinatrarb.com/) (Ruby).

All this does right now is allows a user to authenticate, and pushes the message "Hello Glass" to Glass.

At the time I worked on this app, the Glass team haven't published a quick-start demo for working with the Mirror API in ruby. (Now there is a [quick-start demo on ruby from the Glass team](https://developers.google.com/glass/quickstart/ruby))

Once your server is running go to http://localhost:5000 and you will be prompted with a permissions resquest page like this:

![permissions request page](http://media.tumblr.com/feb3fd723f815a28bf9bfa4a08a2b93b/tumblr_inline_mru9isXsbV1qz4rgp.jpg)

After you accept the permissions, you will land in a page showing your G+ user

![landing page](http://media.tumblr.com/30b1e35713cc782436544c0525d3da17/tumblr_inline_mru9ij2GFO1qz4rgp.jpg)

And in your Glass timeline you will have a 'Hello Glass' card

![hello glass card](http://media.tumblr.com/9021e1ed93b043e0a5cd7ea057548d77/tumblr_inline_mru9i8ZiU31qz4rgp.png)

##Prerequisites

Follow the [instructions in the Mirror API documentation for registering a new app](https://developers.google.com/glass/quickstart/ruby).

##Configure the project

Copy the `.env-sample` file to `.env` and edit it to add the `client id` and `client secret` for your application (obtained when you register your app in the Google API console)

```
GLASS_CLIENT_ID="your-app-client-id"
GLASS_CLIENT_SECRET="your-app-client-secret"
```

##Run the app

First, clone this repo, and install all the required gems using `bundler`:

```
$ bundle install
```

and start the server using `foreman`:

```
$ foreman start
```

