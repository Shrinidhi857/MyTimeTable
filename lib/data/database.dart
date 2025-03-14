import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TimeTableDatabase {
  final _myBox = Hive.box('mybox');
  Map<String, List<Map<String, String>>> timeTable = {}; // Initialize empty map
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔹 Ensure user-specific storage
  String? get userId => FirebaseAuth.instance.currentUser?.uid;
  User? user = FirebaseAuth.instance.currentUser;
  String get collectionPath => "Users/$userId/timetable";

  void createInitializeData() {
    timeTable = {
      'Monday': [],
      'Tuesday': [],
      'Wednesday': [],
      'Thursday': [],
      'Friday': [],
      'Saturday': [],
      'Sunday': [],
    };
    print("\n✅ Hive Table initialized\n");
  }

  // 🔹 Load timetable from Hive (local) or Firestore (cloud)
  Future<void> loadData() async {
    final rawData = _myBox.get("TIMETABLE");

    if (rawData is Map) {
      timeTable = rawData.map<String, List<Map<String, String>>>(
            (key, value) => MapEntry(
          key.toString(),
          (value as List).map((e) => Map<String, String>.from(e)).toList(),
        ),
      );
    } else {
      createInitializeData(); // Default timetable if no data found
    }

    if (userId != null) {
      try {
        final snapshot = await _firestore.collection(collectionPath).get();
        if (snapshot.docs.isNotEmpty) {
          for (var doc in snapshot.docs) {
            timeTable[doc.id] = List<Map<String, String>>.from(
              (doc.data()["schedule"] as List)
                  .map((e) => Map<String, String>.from(e)),
            );
          }
        }

        // 🔹 Save Firestore data to Hive (Local Backup)
        _myBox.put("TIMETABLE", timeTable);
        print("\n✅ Table loaded from 🔥Firebase ->📁 Hive\n");
      } catch (e) {
        print("❌Error loading timetable from Firestore: $e");
      }
    }
  }





  void updateDatabase() async {
    if (userId == null) return;

    try {
      for (var entry in timeTable.entries) {
        await _firestore.collection(collectionPath).doc(entry.key).set({
          "schedule": entry.value,
        }, SetOptions(merge: true)); // 🔹 Merge data instead of overwriting
      }
      print("\n✅ Table loaded from 📁Hive ->🔥 Firebase\n");
    } catch (e) {
      print("\n❌Error saving timetable to Firestore: $e \n");
    }

    // 🔹 Save to Hive (local backup)
    _myBox.put("TIMETABLE", timeTable);
  }
}
