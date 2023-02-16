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

  void typing(Map<String, dynamic> data) {
    _socketClient!.emit('typing', data);
  }

  void autoSave(Map<String, dynamic> data) {
    _socketClient!.emit('save', data);
  }

  void changeListener(Function(Map<String, dynamic>) func) {
    _socketClient!.on('changes', (data) => func(data));
  }
}
 