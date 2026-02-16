import 'package:equatable/equatable.dart';

class FCMMessageEntity extends Equatable {
  final String? notificationId;
  final String? type;
  final String? title;
  final String? body;
  final Map<String, dynamic> data;

  const FCMMessageEntity({
    this.notificationId,
    this.type,
    this.title,
    this.body,
    required this.data,
  });

  // Helper methods to extract nested data
  String? get transactionId => _getDataValue('transaction_id');

  String? get transactionReference =>
      _getDataValue('transaction_reference');

  String? get amount => _getDataValue('amount');

  String? get action => _getDataValue('action');

  String? _getDataValue(String key) {
    return data[key]?.toString();
  }

  @override
  List<Object?> get props => [notificationId, type, title, body, data];
}
