## 4.0.2-wip

- Update minimum Dart SDK to `3.0.0`.

## 4.0.1

- Improve README

## 4.0.0

- Update minimum Dart SDK to `2.12.0`.
- Enable null safety.

## 3.0.2

- Update minimum Dart SDK to `2.6.0`.
- Fix many lints affecting package score.

## 3.0.1

- Updated a number of dependencies.

## 3.0.0

* Set Dart SDK constraint to '>=2.0.0-dev.48.0 <3.0.0'.
* Removed top-level fields `DEFAULT_PORT` and `DEFAULT_HOST` from library. 

## 2.0.0

* Removed `allow-origin` flag. In reality, this flag never worked because the
  `shelf` pipeline was not configured correctly.

* Source moved to [github.com/kevmoo/dhttpd](https://github.com/kevmoo/dhttpd).

## 1.0.0

* No change in functionality, just version and doc tweaks.

## 0.3.1

* Fixed bug with setting the path from the command line.
* Start the server with `dhttpd`.

## 0.3.0

* New `host` command-line flag, to set
  the hostname to listen on. Defaults
  to `localhost`

## 0.2.0

* New `allow-origin` command-line flag for CORS headers.
  Thanks to @gmosx for the patch.
