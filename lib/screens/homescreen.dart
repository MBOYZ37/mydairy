import 'dart:io';
import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/diary.dart';
import 'add_edit_diary.dart';
import 'view_diary.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Diary> diaryList = [];

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final data = await DatabaseHelper.instance.queryAll();
    setState(() {
      diaryList = data;
    });
  }

  // Delete logic
  void _deleteEntry(int id) async {
    await DatabaseHelper.instance.delete(id);
    _loadEntries();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Memory deleted')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("MyDairy",),
        backgroundColor: const Color.fromARGB(255, 254, 88, 143),
      ),
      body: diaryList.isEmpty
          ? Center(
              child: Text(
                "No memories yet.\nTap + to add one!",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: diaryList.length,
              itemBuilder: (context, index) {
                final entry = diaryList[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(10),
                    leading: entry.imagePath != null && File(entry.imagePath!).existsSync()
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(File(entry.imagePath!), width: 60, height: 60, fit: BoxFit.cover),
                          )
                        : Container(
                            width: 60, height: 60,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.book, color: Colors.grey),
                          ),
                    title: Text(entry.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(entry.date, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _confirmDelete(entry.id!),
                    ),
                    onTap: () async {
                      bool? result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewDiary(diaryEntry: entry),
                        ),
                      );
                      if (result == true) _loadEntries();
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          bool? result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddEditDiary()),
          );
          if (result == true) _loadEntries();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _confirmDelete(int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Memory?"),
        content: const Text("Are you sure you want to delete this?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteEntry(id);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}