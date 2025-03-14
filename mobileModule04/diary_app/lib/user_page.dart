import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
      return Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestoreService.getUserEntries(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {return Center(child: 
                // CircularProgressIndicator()
                Text('No entries...')
                );}

                var entries = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    var entry = entries[index];
                    return ListTile(
                      title: Text(entry["title"]),
                      subtitle: Text("Mood: ${entry["mood"]}"),
                      trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.blueGrey),
                        onPressed: () => _firestoreService.deleteEntry(entry.id),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () => _showAddEntryDialog(context),
              child: Text("New Entry"),
            ),
          ),
        ],
    );
  }

  void _showAddEntryDialog(BuildContext context) {
    String title = "";
    String mood = "";
    String content = "";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("New Entry"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(onChanged: (val) => title = val, decoration: InputDecoration(labelText: "Title")),
            TextField(onChanged: (val) => mood = val, decoration: InputDecoration(labelText: "Mood")),
            TextField(onChanged: (val) => content = val, decoration: InputDecoration(labelText: "Content")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              _firestoreService.addEntry(title, mood, content);
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}
