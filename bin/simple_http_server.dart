import 'package:simple_http_server/src/_boot.dart';

main(List<String> args) {
  print('Warning: using simple_http_server to start the server is deprecated.');
  print('Please use dhttpd instead. Thanks!');
  bootServer(args);
}
