import 'package:google_docs_clone/constants.dart';
import 'package:google_docs_clone/extensions.dart';
import 'package:socket_io_client/socket_io_client.dart' as soc;

class SocketClient {
  soc.Socket? socket;
  static SocketClient? _instance;

  SocketClient._internal() {
    socket = soc.io(host, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    "Socket Client Created".logSuccess();

    socket!.connect();
  }

  static SocketClient get instance {
    _instance ??= SocketClient._internal();
    return _instance!;
  }
}
