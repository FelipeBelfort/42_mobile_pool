import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // 🔹 Add a new diary entry
  Future<void> addEntry(String title, String mood, String content) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    await _db.collection("entries").add({
      "userId": user.email,
      "date": FieldValue.serverTimestamp(),
      "title": title,
      "mood": mood,
      "content": content,
    });
  }

  // 🔹 Get all entries for the logged-in user
  Stream<QuerySnapshot> getUserEntries() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception("User not logged in");

    return _db
        .collection("entries")
        .where("userId", isEqualTo: user.email)
        .orderBy("date", descending: true)
        .snapshots();
  }

  // 🔹 Delete an entry
  Future<void> deleteEntry(String entryId) async {
    await _db.collection("entries").doc(entryId).delete();
  }
}
