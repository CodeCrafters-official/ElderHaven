import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// Model class for Story
class Story {
  String title;
  String content;

  Story({required this.title, required this.content});

  Map<String, String> toMap() {
    return {'title': title, 'content': content};
  }

  factory Story.fromMap(Map<String, dynamic> map) {
    return Story(
      title: map['title'] ?? '',
      content: map['content'] ?? '',
    );
  }
}

// Service for handling storage of stories
class StoryService {
  Future<List<Story>> getStories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? storiesJson = prefs.getString('stories');
    if (storiesJson != null) {
      List<Map<String, dynamic>> storyList = List<Map<String, dynamic>>.from(json.decode(storiesJson));
      return storyList.map((storyMap) => Story.fromMap(Map<String, dynamic>.from(storyMap))).toList();
    }
    return [];
  }

  Future<void> saveStories(List<Story> stories) async {
    final prefs = await SharedPreferences.getInstance();
    final String storiesJson = json.encode(stories.map((story) => story.toMap()).toList());
    await prefs.setString('stories', storiesJson);
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Elder App - Stories',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StoryListScreen(),
    );
  }
}

class StoryListScreen extends StatefulWidget {
  @override
  _StoryListScreenState createState() => _StoryListScreenState();
}

class _StoryListScreenState extends State<StoryListScreen> {
  final StoryService storyService = StoryService();
  List<Story> stories = [];
  bool isPremiumUser = false; // Mock check for premium user

  @override
  void initState() {
    super.initState();
    loadStories();
    // For testing, we assume user is premium
    checkPremiumAccess();
  }

  Future<void> loadStories() async {
    stories = await storyService.getStories();
    setState(() {});
  }

  Future<void> addStory(Story story) async {
    stories.add(story);
    await storyService.saveStories(stories);
    setState(() {});
  }

  void checkPremiumAccess() {
    setState(() {
      isPremiumUser = true; // Set to true to enable premium features
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Stories')),
      body: isPremiumUser
          ? ListView.builder(
        itemCount: stories.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(stories[index].title),
            subtitle: Text(stories[index].content),
          );
        },
      )
          : Center(
        child: Text(
          'Upgrade to premium to view stories.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
      floatingActionButton: isPremiumUser
          ? FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final newStory = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StoryAddScreen()),
          );
          if (newStory != null) {
            await addStory(newStory);
          }
        },
      )
          : null,
    );
  }
}

class StoryAddScreen extends StatefulWidget {
  @override
  _StoryAddScreenState createState() => _StoryAddScreenState();
}

class _StoryAddScreenState extends State<StoryAddScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add New Story')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Save Story'),
              onPressed: () {
                final newStory = Story(
                  title: titleController.text,
                  content: contentController.text,
                );
                Navigator.pop(context, newStory);
              },
            ),
          ],
        ),
      ),
    );
  }
}
