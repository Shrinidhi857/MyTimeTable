import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuple/tuple.dart';

class TodayClass {
  final _myBox = Hive.box('mybox');
  List<Tuple3<String, bool, bool>> todayClasses = [];

  void initializeTodayClass() {
    todayClasses = [];
    print("\n✅ Hive TodayClasses initialized\n");
  }

  Future<void> loadTodayClass() async {
    try {
      final rawdata = _myBox.get("TODAYCLASS");
      Map<String, Map<bool, bool>> todayClasses = rawdata.map<String, Map<bool, bool>>(
            (key, value) => MapEntry(
          key.toString(),
          Map<bool, bool>.fromIterable(
            value as List,
            key: (e) => e[0] as bool, // Adjust index based on your data structure
            value: (e) => e[1] as bool,
          ),
        ),
      );


      _myBox.put("TODAYCLASS", todayClasses);
      print("\n✅ Loaded TodayClasses from 🔥Firebase ->📁 Hive\n");
    } catch (e) {
      print("❌ Error loading TodayClasses from Firestore: $e");
    }
  }

  Future<void> updateTodayClass() async {
    try {
      _myBox.put("TODAYCLASS", todayClasses);
      print("\n✅ TodayClasses updated from 📁Hive ->🔥 Firebase\n");
    } catch (e) {
      print("\n❌ Error saving TodayClasses to Firestore: $e \n");
    }
  }
}
