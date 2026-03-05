import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  final String id;
  final String content;
  final String role; // 'user' or 'assistant'
  final DateTime timestamp;
  final String productId;

  const ChatMessage({
    required this.id,
    required this.content,
    required this.role,
    required this.timestamp,
    required this.productId,
  });

  @override
  List<Object?> get props => [id, content, role, timestamp, productId];
}
