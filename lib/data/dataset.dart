import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatasetDatabase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  User? get user => FirebaseAuth.instance.currentUser;
  String? get userId => user?.uid;

  Map<DateTime, int> dataset = {};
  Stream<void>? _databaseChangeStream;

  DateTime parseDateString(String dateString) {
    List<String> parts = dateString.split('-');
    return DateTime(
      int.parse(parts[0]), // Year
      int.parse(parts[1]), // Month
      int.parse(parts[2]), // Day
    );
  }

  void listenToDatabaseChanges(Function() onDatabaseUpdated) {
    if (userId == null) return;

    _databaseChangeStream = _firestore
        .collection("Users")
        .doc(userId)
        .collection("dataset")
        .snapshots()
        .listen((snapshot) {
      onDatabaseUpdated(); // Call the callback function to reload data
    }) as Stream<void>?;
  }

  Future<void> addData(DateTime date, int value) async {
    if (userId == null) return;

    try {
      String formattedDate = "${date.year}-${date.month}-${date.day}";

      DocumentReference docRef = _firestore
          .collection("Users")
          .doc(userId)
          .collection("dataset")
          .doc(formattedDate);

      await _firestore.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(docRef);
        int currentValue = 0;

        if (snapshot.exists && snapshot.data() != null) {
          currentValue = (snapshot.data() as Map<String, dynamic>)["value"] ?? 0;
        }

        int updatedValue = (currentValue + value).clamp(0, 10); // ✅ Limit value to max 10
        transaction.set(docRef, {"value": updatedValue}, SetOptions(merge: true));
      });

      print("\n✅Updated dataset for $formattedDate: $value\n");
    } catch (e) {
      print("\n❌Error updating dataset: $e\n");
    }
  }

  /// Loads data from Firestore
  Future<void> loadData() async {
    if (userId == null) return;

    try {
      final snapshot = await _firestore
          .collection("Users")
          .doc(userId)
          .collection("dataset")
          .get();

      dataset = {
        for (var doc in snapshot.docs)
          parseDateString(doc.id): (doc.data()["value"] as int).clamp(0, 10)
      };

      print("\n✅Dataset loaded: $dataset \n");
    } catch (e) {
      print("\n❌Error loading dataset from Firestore: $e \n");
    }
  }
}
