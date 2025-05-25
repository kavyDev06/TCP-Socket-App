
import 'dart:developer';
import 'dart:io';

class SocketHelper{

  SocketHelper._();

  SocketHelper socketHelper = SocketHelper._();

  Future<void> connect(String serverAddress,int serverport)async{
    try{
      final socket = await Socket.connect(serverAddress, serverport);

      socket.writeln("Hello Server,from client");

      socket.listen((data){
        log("Data : $data");
      },onDone: (){
        log("Server discontinued");
        socket.destroy();
      },onError: (){
        log("Error");
        socket.destroy();
      });
    }
    catch(e){
      log("Error : $e");
    }
  }
}