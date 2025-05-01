import 'package:hive/hive.dart';

part 'history_model.g.dart';

@HiveType(typeId: 0)
class HistoryModel {
  @HiveField(0)
  final int opType;
  
  @HiveField(1)
  final String opName;
  
  @HiveField(2)
  final String content;
  
  @HiveField(3)
  final String timestamp;

  HistoryModel({
    required this.opType,
    required this.opName,
    required this.content,
    required this.timestamp,
  });
}