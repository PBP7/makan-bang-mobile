import 'package:flutter/material.dart';
import 'package:makan_bang/forum/models/forum_question.dart';
import 'package:makan_bang/forum/screens/details.dart';
import 'package:makan_bang/forum/screens/forum_form.dart';
import 'package:makan_bang/widgets/left_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class ForumPage extends StatefulWidget {
  const ForumPage({super.key});

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  List<ForumQuestion> _questions = [];
  bool _isLoading = true;
  String _selectedTopic = 'All Topic';
  bool _showOnlyUserPosts = false;

  final List<String> _topics = [
    'All Topic',
    'Information',
    'Foods',
    'Restaurants',
    'Recommendation',
    'Experience'
  ];

  @override
  void initState() {
    super.initState();
    _fetchQuestions();
  }

  Future<void> _fetchQuestions() async {
    final request = context.read<CookieRequest>();
    setState(() => _isLoading = true);
    try {
      final response = await request.get(
        'http://127.0.0.1:8000/forum/json/questions/?topic=$_selectedTopic'
      );

      if (response != null) {
        final questionsList = forumQuestionFromJson(json.encode(response));
        setState(() {
          if (_showOnlyUserPosts) {
            _questions = questionsList.where(
              (q) => q.user.username == request.jsonData['username']
            ).toList();
          } else {
            _questions = questionsList;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    context.watch<CookieRequest>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forum'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(96.0), // Increased height for both widgets
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  value: _selectedTopic,
                  items: _topics.map((String topic) {
                    return DropdownMenuItem<String>(
                      value: topic,
                      child: Text(topic),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedTopic = newValue;
                      });
                      _fetchQuestions();
                    }
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showOnlyUserPosts = false;
                                  });
                                  _fetchQuestions();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  decoration: BoxDecoration(
                                    color: !_showOnlyUserPosts ? Colors.white : null,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: !_showOnlyUserPosts
                                        ? Border.all(color: Colors.blue)
                                        : null,
                                  ),
                                  child: Text(
                                    'All Posts',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: !_showOnlyUserPosts
                                          ? Colors.blue
                                          : Colors.grey[600],
                                      fontWeight: !_showOnlyUserPosts
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _showOnlyUserPosts = true;
                                  });
                                  _fetchQuestions();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                                  decoration: BoxDecoration(
                                    color: _showOnlyUserPosts ? Colors.white : null,
                                    borderRadius: BorderRadius.circular(8.0),
                                    border: _showOnlyUserPosts
                                        ? Border.all(color: Colors.blue)
                                        : null,
                                  ),
                                  child: Text(
                                    'Your Posts',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: _showOnlyUserPosts
                                          ? Colors.blue
                                          : Colors.grey[600],
                                      fontWeight: _showOnlyUserPosts
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ForumFormPage(),
            ),
          );
          if (result == true && context.mounted) {
            Navigator.of(context).pop(true);
          }
        },
        child: const Icon(Icons.add),
      ),
      drawer: const LeftDrawer(),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchQuestions,
              child: _questions.isEmpty
                  ? const Center(child: Text('No discussions found'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(8.0),
                      itemCount: _questions.length,
                      itemBuilder: (context, index) {
                        final question = _questions[index];
                        return ForumQuestionCard(question: question);
                      },
                    ),
            ),
    );
  }
}

class ForumQuestionCard extends StatelessWidget {
  final ForumQuestion question;

  const ForumQuestionCard({
    super.key,
    required this.question,
  });

  String _formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 2,
      child: ListTile(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ForumDetailPage(question: question),
            ),
          );
        },
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.person_outline, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  question.user.username,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(width: 16),
                Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  _formatDate(question.createdAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  question.topic,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.blue[900],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(Icons.comment_outlined, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                '${question.replycount} replies',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}