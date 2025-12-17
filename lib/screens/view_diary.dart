import 'dart:io';
import 'package:flutter/material.dart';
import '../models/diary.dart';
import 'add_edit_diary.dart';

class ViewDiary extends StatefulWidget {
  final Diary diaryEntry;

  const ViewDiary({super.key, required this.diaryEntry});

  @override
  State<ViewDiary> createState() => _ViewDiaryState();
}

class _ViewDiaryState extends State<ViewDiary> {
  late Diary entry;

  @override
  void initState() {
    super.initState();
    entry = widget.diaryEntry;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(entry.date.split('–')[0].trim()), 
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              bool? result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditDiary(diaryEntry: entry),
                ),
              );
              if (result == true && mounted) {
                Navigator.pop(context, true);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (entry.imagePath != null && File(entry.imagePath!).existsSync())
              Container(
                width: double.infinity,
                height: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: DecorationImage(
                    image: FileImage(File(entry.imagePath!)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              entry.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.brown),
            ),
            const SizedBox(height: 10),
            Text(
              entry.date,
              style: TextStyle(color: Colors.grey[600], fontStyle: FontStyle.italic),
            ),
            const Divider(height: 30),
            Text(
              entry.content,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}