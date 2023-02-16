import 'package:google_docs_clone/clients/socket_client.dart';
import 'package:google_docs_clone/extensions.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketRepository {
  final _socketClient = SocketClient.instance.socket;

  Socket get socket => _socketClient!;

  void joinDocumentRoom(String docId) {
    "Joining room $docId".logWarning();
    _socketClient!.emit("join", docId);
  }
}
