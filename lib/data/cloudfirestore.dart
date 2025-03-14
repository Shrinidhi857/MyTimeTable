import 'package:cloud_firestore/cloud_firestore.dart';

class cloudDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = "timetable";

  late Map<String, List<Map<String, String>>> timeTable;

  // Initialize default data
  void createInitializeDate() {
    timeTable = {
      'Monday': [
        {'subject': 'Math', 'starttime': "09:00", 'endtime': "10:00"},
        {'subject': 'Physics', 'starttime': "10:00", 'endtime': "11:00"},
      ],
      'Tuesday': [
        {'subject': 'Biology', 'starttime': "09:00", 'endtime': "10:00"},
        {'subject': 'Chemistry', 'starttime': "10:00", 'endtime': "11:00"},
        {'subject': 'English', 'starttime': "11:00", 'endtime': "12:00"},
      ],
      'Wednesday': [
        {'subject': 'Math', 'starttime': "09:00", 'endtime': "10:00"},
        {'subject': 'Physics', 'starttime': "10:00", 'endtime': "11:00"},
      ],
      'Thursday': [
        {'subject': 'History', 'starttime': "09:00", 'endtime': "10:00"},
      ],
      'Friday': [
        {'subject': 'History', 'starttime': "09:00", 'endtime': "10:00"},
      ],
      'Saturday': [
        {'subject': 'History', 'starttime': "09:00", 'endtime': "10:00"},
      ],
      'Sunday': [],
    };
  }

  // Save data to Firestore
  Future<void> updateDatabase() async {
    try {
      for (var entry in timeTable.entries) {
        await _firestore.collection(collectionPath).doc(entry.key).set({
          "subject": entry.value,
        });
      }
    } catch (e) {
      print("Error saving timetable: $e");
    }
  }

  // Load data from Firestore
  Future<void> loadData() async {
    try {
      final snapshot = await _firestore.collection(collectionPath).get();
      timeTable = {};
      for (var doc in snapshot.docs) {
        timeTable[doc.id] = List<Map<String, String>>.from(
            (doc.data()["schedule"] as List).map((e) => Map<String, String>.from(e)));
      }
    } catch (e) {
      print("Error loading timetable: $e");
      timeTable = {}; // Initialize empty if error occurs
    }
  }
}
