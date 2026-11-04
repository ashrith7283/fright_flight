import 'package:fright_flight/services/storage_service.dart';

class FakeStorageService implements StorageService {
  FakeStorageService({this.stored});

  int? stored;
  bool failReads = false;
  bool failWrites = false;
  final List<int> writes = [];

  @override
  Future<int?> readHighScore() async {
    if (failReads) throw Exception('read failed');
    return stored;
  }

  @override
  Future<void> writeHighScore(int value) async {
    if (failWrites) throw Exception('write failed');
    writes.add(value);
    stored = value;
  }

  bool? storedMuted;
  bool failMutedReads = false;
  bool failMutedWrites = false;
  final List<bool> mutedWrites = [];

  @override
  Future<bool?> readMuted() async {
    if (failMutedReads) throw Exception('read failed');
    return storedMuted;
  }

  @override
  Future<void> writeMuted(bool value) async {
    if (failMutedWrites) throw Exception('write failed');
    mutedWrites.add(value);
    storedMuted = value;
  }
}
