import 'package:hive/hive.dart';
import '../models/history_model.dart';

class HistoryService {
  final Box<HistoryModel> _historyBox = Hive.box<HistoryModel>('history');

  List<HistoryModel> getHistory() => _historyBox.values.toList();

  void addHistory(HistoryModel history) => _historyBox.add(history);

  void deleteHistory(int index) => _historyBox.deleteAt(index);
}
