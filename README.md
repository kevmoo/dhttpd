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

* `--port` - Set the port. Defaults to 8080.
* `--path` - Set the path to serve. Defaults to cwd.
* `--host` - Hostname to listen on. Defaults to localhost.

[path]: https://www.dartlang.org/tools/pub/cmd/pub-global#running-a-script-from-your-path
