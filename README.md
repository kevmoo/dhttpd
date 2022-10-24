[![Pub Package](https://img.shields.io/pub/v/dhttpd.svg)](https://pub.dev/packages/dhttpd)
[![CI](https://github.com/kevmoo/dhttpd/actions/workflows/ci.yml/badge.svg?branch=master)](https://github.com/kevmoo/dhttpd/actions/workflows/ci.yml)
[![package publisher](https://img.shields.io/pub/publisher/dhttpd.svg)](https://pub.dev/packages/dhttpd/publisher)

A simple HTTP server that can serve up any directory, built with Dart.
Inspired by `python -m SimpleHTTPServer`.

## Install

Use the `dart pub global` command to install this into your system.

```console
$ dart pub global activate dhttpd
```

## Use

If you have [modified your PATH][path], you can run this server from any
local directory.

```console
$ dhttpd
```

Otherwise you can use the `dart pub global` command.

```console
$ dart pub global run dhttpd
```

Here's an example of creating a web app
and then running it with this server:

```console
$ dart create -t web-simple web-app
$ cd web-app
$ dart pub get
$ dart run build_runner build -o build
$ dhttpd --path build/web/  # Serves app at http://localhost:8080
```

## Configure

```console
$ dhttpd --help
-p, --port=<port>    The port to listen on.
                     (defaults to "8080")
    --path=<path>    The path to serve. If not set, the current directory is used.
    --host=<host>    The hostname to listen on.
                     (defaults to "localhost")
-h, --help           Displays the help.
```

[path]: https://dart.dev/tools/pub/cmd/pub-global#running-a-script-from-your-path
