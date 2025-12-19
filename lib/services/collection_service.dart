import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CollectionService {
  static final CollectionService _instance = CollectionService._internal();

  factory CollectionService() {
    return _instance;
  }

  CollectionService._internal();

  List<int> _unlockedTeamIds = [];
  List<Map<String, dynamic>> _scanHistory = [];

  // Initialize and load data
  Future<void> init() async {
    await _loadData();
  }

  // Get path to storage file
  Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/nba_collection_data.json');
  }

  // Load data from file
  Future<void> _loadData() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        final data = json.decode(contents);

        _unlockedTeamIds = List<int>.from(data['unlockedIds'] ?? []);
        _scanHistory = List<Map<String, dynamic>>.from(data['history'] ?? []);
      }
    } catch (e) {
      print('Error loading collection data: $e');
    }
  }

  // Save data to file
  Future<void> _saveData() async {
    try {
      final file = await _localFile;
      final data = {
        'unlockedIds': _unlockedTeamIds,
        'history': _scanHistory,
      };
      await file.writeAsString(json.encode(data));
    } catch (e) {
      print('Error saving collection data: $e');
    }
  }

  // Unlock a team
  Future<bool> unlockTeam(int teamId) async {
    if (!_unlockedTeamIds.contains(teamId)) {
      _unlockedTeamIds.add(teamId);
      await _saveData();
      return true; // Newly unlocked
    }
    return false; // Already unlocked
  }

  // Add to history
  Future<void> addToHistory(String teamName, double confidence) async {
    _scanHistory.insert(0, {
      'teamName': teamName,
      'confidence': confidence,
      'timestamp': DateTime.now().toIso8601String(),
    });
    // Keep only last 50 entries
    if (_scanHistory.length > 50) {
      _scanHistory = _scanHistory.sublist(0, 50);
    }
    await _saveData();
  }

  // Clear history
  Future<void> clearHistory() async {
    _scanHistory.clear();
    await _saveData();
  }

  bool isTeamUnlocked(int teamId) {
    return _unlockedTeamIds.contains(teamId);
  }

  int get unlockedCount => _unlockedTeamIds.length;
  List<int> get unlockedIds => _unlockedTeamIds;
  List<Map<String, dynamic>> get history => _scanHistory;
}
