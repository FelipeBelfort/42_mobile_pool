import 'package:flutter/material.dart';
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
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No diary entries yet."));
                }

                var entries = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    var entry = entries[index];
                    return ListTile(
                      title: Text(entry["title"]),
                      subtitle: Text("Mood: ${entry["mood"]}"),
                      onTap: () { _showEntryDetails(context, entry);},
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
              child: Text("Add Note"),
            ),
          ),
        ],
    );
  }

  void _updateEntryDetails(BuildContext context, var entry) {

    TextEditingController titleController = TextEditingController(text: entry["title"]);
    TextEditingController moodController = TextEditingController(text: entry["mood"]);
    TextEditingController contentController = TextEditingController(text: entry["content"]);
    Timestamp timestamp = entry["date"];
    DateTime date = timestamp.toDate();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text(""),),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(controller: titleController,),
                  ),
              ],
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("${date.day}/${date.month}/${date.year}"),
                    Expanded(child: Container()),
                  ],
                ),
                TextField(controller: moodController,),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: TextField(controller: contentController,),
                    ),
                  ),
                ),
              ),
          ],
      ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (titleController.text.trim().isEmpty || moodController.text.trim().isEmpty || contentController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required")));
                return;
              }
              _firestoreService.updateEntry(entry.id, titleController.text, moodController.text, contentController.text);
              Navigator.pop(context);
            },
            child: Text("Update"),
          ),
        ],
      ),
    );
  }

  void _showEntryDetails(BuildContext context, var entry) {

    String title = entry["title"];
    String mood = entry["mood"];
    String content = entry["content"];
    Timestamp timestamp = entry["date"];
    DateTime date = timestamp.toDate();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          children: [
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    _firestoreService.deleteEntry(entry.id);
                    Navigator.pop(context);
                  },
                  child: Icon(Icons.delete_forever, color: Colors.red,),
                ),
                Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _updateEntryDetails(context, entry);
                  },
                  child: Icon(Icons.edit_note),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: Text(title, overflow: TextOverflow.ellipsis, maxLines: 1, softWrap: false,),
                  ),
              ],
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("${date.day}/${date.month}/${date.year}"),
                    Expanded(child: Container()),
                  ],
                ),
                Text(mood),
              ],
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Scrollbar(
                  child: SingleChildScrollView(
                    child: Text(content),
                    ),
                  ),
                ),
              ),
          ],
      ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showAddEntryDialog(BuildContext context) {
    String title = "";
    String mood = "";
    String content = "";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Note"),
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
              if (title.trim().isEmpty || mood.trim().isEmpty || content.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required")));
                return;
              }
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
