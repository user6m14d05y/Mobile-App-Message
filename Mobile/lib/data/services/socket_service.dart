import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../core/constants/app_constants.dart';
import '../models/user_model.dart';

class SocketService {
  
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? socket;

  // Khởi tạo kết nối Socket
  void connect(UserModel user) {
    socket = IO.io(
      AppConstants.socketUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect() // Tránh tự kết nối khi chưa có config
          .build(),
    );

    socket?.connect();

    socket?.onConnect((_) {
      print('Connected to Socket.IO Server');
      // Báo cho server biết user này đăng nhập thành công
      socket?.emit('setup', user.toJson());
    });

    socket?.onDisconnect((_) => print('Disconnected from Socket.IO'));
  }

  // --- CÁC HÀM GỬI LÊN SERVER (EMIT) ---

  void joinChat(String conversationId) {
    socket?.emit('join chat', conversationId);
  }

  void typing(String conversationId) {
    socket?.emit('typing', conversationId);
  }

  void stopTyping(String conversationId) {
    socket?.emit('stop typing', conversationId);
  }

  void sendMessage(Map<String, dynamic> messageData) {
    socket?.emit('new message', messageData);
  }

  // --- CÁC HÀM LẮNG NGHE TỪ SERVER (ON) ---

  void onMessageReceived(Function(dynamic) callback) {
    socket?.on('message recieved', (data) {
      callback(data);
    });
  }

  void onTyping(Function callback) {
    socket?.on('typing', (_) => callback());
  }

  void onStopTyping(Function callback) {
    socket?.on('stop typing', (_) => callback());
  }

  void onUserStatusChanged(Function(dynamic) callback) {
    socket?.on('user status changed', (data) {
      callback(data);
    });
  }

  // Hủy kết nối
  void disconnect() {
    socket?.disconnect();
    socket?.dispose();
  }
}
