simple_http_server
==================

A simple HTTP server that can serve up any directory.
Inspired by `python -m SimpleHTTPServer`.

## Install

Use the `pub global` command to install this into your system.

    $ pub global activate simple_http_server

## Use

You can run this server from any local directory.

    $ pub global run simple_http_server

## Configure

* `--port` - Set the port. Defaults to 8080.

## Known issues

* Startup is slow. Tracking: https://code.google.com/p/dart/issues/detail?id=20212
* Does not support SSL.
