[![Pub Package](https://img.shields.io/pub/v/dhttpd.svg)](https://pub.dev/packages/dhttpd)
[![Build Status](https://travis-ci.org/kevmoo/dhttpd.svg?branch=master)](https://travis-ci.org/kevmoo/dhttpd)

A simple HTTP server that can serve up any directory, built with Dart.
Inspired by `python -m SimpleHTTPServer`.

## Install

Use the `pub global` command to install this into your system.

```console
$ pub global activate dhttpd
```

## Use

If you have [modified your PATH][path], you can run this server from any
local directory.

```console
$ dhttpd
```

Otherwise you can use the `pub global` command.

```console
$ pub global run dhttpd
```

Here's an example of creating a web app with [Stagehand](http://stagehand.pub/)
and then running it with this server:

```console
$ stagehand web-angular
$ pub get
$ pub build
$ dhttpd --path build/web/  # Serves app at http://localhost:8080
```

## Configure

```console
$ dhttpd --help
-p, --port=<port>    The port to listen on.
                     (defaults to "8080")
    --path=<path>    The path to serve. If not set, the curret directory is used.
    --host=<host>    The hostname to listen on.
                     (defaults to "localhost")
-h, --help           Displays the help.
```
[path]: https://dart.dev/tools/pub/cmd/pub-global#running-a-script-from-your-path
