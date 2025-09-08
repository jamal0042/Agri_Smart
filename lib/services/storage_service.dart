import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:AgriSmart/models/scan_result.dart';

class StorageService {
  static const String _scanHistoryKey = 'scan_history';
  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveScanResult(ScanResult result) async {
    final history = await getScanHistory();
    history.insert(0, result);
    
    // Keep only the latest 50 results
    if (history.length > 50) {
      history.removeRange(50, history.length);
    }
    
    final jsonList = history.map((result) => result.toJson()).toList();
    await _prefs?.setString(_scanHistoryKey, jsonEncode(jsonList));
  }

  static Future<List<ScanResult>> getScanHistory() async {
    final jsonString = _prefs?.getString(_scanHistoryKey);
    if (jsonString == null) return [];
    
    final jsonList = List<Map<String, dynamic>>.from(jsonDecode(jsonString));
    return jsonList.map((json) => ScanResult.fromJson(json)).toList();
  }

  static Future<void> clearScanHistory() async {
    await _prefs?.remove(_scanHistoryKey);
  }

  static Future<List<ScanResult>> getRecentScans({int limit = 5}) async {
    final history = await getScanHistory();
    return history.take(limit).toList();
  }
}