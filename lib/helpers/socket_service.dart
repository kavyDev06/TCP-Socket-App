import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart';

class SocketHelper {
  SocketHelper._();

  static final SocketHelper instance = SocketHelper._();

  Socket? _socket;

  /// Connect to server
  Future<void> connect(String serverAddress, int serverPort) async {
    try {
      _socket = await Socket.connect(serverAddress, serverPort);
      log("Connected to: ${_socket!.remoteAddress.address}:${_socket!.remotePort}");

      _socket!.listen(
            (data) {
          log("Server: ${String.fromCharCodes(data)}");
        },
        onDone: () {
          log("Server disconnected.");
          _socket!.destroy();
        },
        onError: (error) {
          log("Error: $error");
          _socket!.destroy();
        },
      );
    } catch (e) {
      log("Connection Error: $e");
    }
  }

  /// Send image to server
  Future<void> sendImage(File imageFile) async {
    if (_socket == null) {
      log("Not connected to server.");
      return;
    }

    try {
      final Uint8List imageBytes = await imageFile.readAsBytes();
      final String fileName = basename(imageFile.path);
      final int fileNameLength = fileName.length;
      final int imageSize = imageBytes.length;

      // 1. Send filename length (4 bytes)
      _socket!.add(_intToBytes(fileNameLength, 4));

      // 2. Send filename as bytes
      _socket!.add(Utf8Encoder().convert(fileName));

      // 3. Send image size (8 bytes)
      _socket!.add(_intToBytes(imageSize, 8));

      // 4. Send image bytes
      _socket!.add(imageBytes);

      await _socket!.flush();
      log("Image sent: $fileName ($imageSize bytes)");
    } catch (e) {
      log("Failed to send image: $e");
    }
  }

  /// Convert int to bytes (big-endian)
  List<int> _intToBytes(int value, int byteCount) {
    final bytes = ByteData(byteCount);
    if (byteCount == 4) {
      bytes.setUint32(0, value, Endian.big);
    } else if (byteCount == 8) {
      bytes.setUint64(0, value, Endian.big);
    }
    return bytes.buffer.asUint8List();
  }

  /// Close the socket
  void close() {
    _socket?.destroy();
    log("🔌 Socket closed.");
  }
}
