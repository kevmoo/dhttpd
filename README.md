simple_http_server
==================

A simple HTTP server that can serve up any directory.
Inspired by `python -m SimpleHTTPServer`.

## Install

Use the `pub global` command to install this into your system.

    $ pub global activate simple_http_server

## Use

If you have [modified your PATH][path], you can run this server from any
local directory.

```
$ dhttpd
```

Otherwise you can use the `pub global` command.

```
$ pub global run dhttpd
```

## Configure

* `--port` - Set the port. Defaults to 8080.
* `--path` - Set the path to server. Defaults to cwd.
* `--host` - Hostname to listen on. Defaults to localhost.
* `--allow-origin` - Value for the 'Access-Control-Allow-Origin' header.

[path]: https://www.dartlang.org/tools/pub/cmd/pub-global.html#running-a-script-from-your-path
