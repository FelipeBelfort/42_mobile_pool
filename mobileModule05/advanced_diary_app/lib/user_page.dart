import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firestore.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});
  final FirestoreService _firestoreService = FirestoreService();
  final List<String> moods = ["🥳", "😀", "🤓", "🤯", "💩", ];
  final User? _user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Expanded(child: Text("Welcome ${_user?.displayName ?? _user?.email}")),
          Text("Welcome ${_user?.displayName ?? _user?.email}"),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.deepPurple[100],
                borderRadius: BorderRadius.circular(25),
              ),
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
                int count = entries.length > 2 ? 2 : entries.length;
                return getEntriesList(count, entries);
              },
            ),
            ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: _firestoreService.getUserEntries(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                int totEntries = snapshot.data!.docs.length;
                return Text("You have $totEntries notes in your diary!");
              },
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                color: Colors.deepPurple[100],
                borderRadius: BorderRadius.circular(25),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestoreService.getUserEntries(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return CircularProgressIndicator();

                  Map<String, int> moodCounts = {};
                  for (var doc in snapshot.data!.docs) {
                    String mood = doc["mood"];
                    moodCounts[mood] = (moodCounts[mood] ?? 0) + 1;
                  }
                  return Column(
                    children: moodCounts.entries.map((entry) {
                      double percentage = (entry.value / snapshot.data!.docs.length) * 100;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("${entry.key} "),
                          Text(" <=====>"),
                          Text(" ${percentage.toStringAsFixed(1)}%"),
                        ]
                        );
                    }).toList(),
                  );
                },
              ),
              ),
              )
              )
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

  Widget getEntriesList(int count, var entries) {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, index) {
        var entry = entries[index];
        return ListTile(
          title: Text(entry["title"]),
          subtitle: Row(
            children: [
              Text(_getFormatedDate(entry['date'])),
              Text('  |  '),
              Text(" ${entry["mood"]}"),
            ]
            ),
          onTap: () { _showEntryDetails(context, entry);},
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.blueGrey),
            onPressed: () => _firestoreService.deleteEntry(entry.id),
          ),
        );
      },
    );
  }

  String _getFormatedDate(var entry) {
    Timestamp timestamp = entry;
    DateTime date = timestamp.toDate();

    return "${date.day}/${date.month}/${date.year}";
  }

  void _updateEntryDetails(BuildContext context, var entry) {

    TextEditingController titleController = TextEditingController(text: entry["title"]);
    TextEditingController contentController = TextEditingController(text: entry["content"]);
    String selectedMood = moods[0];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text("Edit Note"),),
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
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(_getFormatedDate(entry['date'])),
                    Expanded(child: Container()),
                  ],
                ),
                DropdownButton<String>(
                  value: selectedMood,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      selectedMood = newValue;
                    }
                  },
                  items: moods.map((String mood) {
                    return DropdownMenuItem<String>(
                      value: mood,
                      child: Text(mood),
                    );
                  }).toList(),
                ),
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
              if (titleController.text.trim().isEmpty || selectedMood.trim().isEmpty || contentController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required")));
                return;
              }
              _firestoreService.updateEntry(entry.id, titleController.text, selectedMood, contentController.text);
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
                    Text(_getFormatedDate(entry['date'])),
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
    String selectedMood = moods[0];
    String content = "";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add Note"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(onChanged: (val) => title = val, decoration: InputDecoration(labelText: "Title")),
            DropdownButton<String>(
                  value: selectedMood,
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      selectedMood = newValue;
                    }
                  },
                  items: moods.map((String mood) {
                    return DropdownMenuItem<String>(
                      value: mood,
                      child: Text(mood),
                    );
                  }).toList(),
                ),
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
              if (title.trim().isEmpty || selectedMood.trim().isEmpty || content.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("All fields are required")));
                return;
              }
              _firestoreService.addEntry(title, selectedMood, content);
              Navigator.pop(context);
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }
}
