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
        title: const Text(
          'Forum',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        centerTitle: true,
      ),
      drawer: const LeftDrawer(),
      body: Column(
        children: [
          // Header Image
          Container(
            height: 200,
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/forum.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 48,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ElevatedButton.icon(
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text(
                      'Add New Forum',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                // Topic Dropdown
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
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
                const SizedBox(height: 12),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
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
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            decoration: BoxDecoration(
                              color: !_showOnlyUserPosts ? Colors.white : null,
                              borderRadius: BorderRadius.circular(8),
                              border: !_showOnlyUserPosts
                                  ? Border.all(color: Colors.grey[700]!)
                                  : null,
                            ),
                            child: Text(
                              'All Posts',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: !_showOnlyUserPosts
                                    ? Colors.grey[700]
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
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            decoration: BoxDecoration(
                              color: _showOnlyUserPosts ? Colors.white : null,
                              borderRadius: BorderRadius.circular(8),
                              border: _showOnlyUserPosts
                                  ? Border.all(color: Colors.grey[700]!)
                                  : null,
                            ),
                            child: Text(
                              'Your Posts',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: _showOnlyUserPosts
                                    ? Colors.grey[700]
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
              ],
            ),
          ),
          // Forum List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _fetchQuestions,
                    child: _questions.isEmpty
                        ? const Center(child: Text('No discussions found'))
                        : ListView.builder(
                            padding: const EdgeInsets.all(16.0),
                            itemCount: _questions.length,
                            itemBuilder: (context, index) {
                              final question = _questions[index];
                              return ForumQuestionCard(question: question);
                            },
                          ),
                  ),
          ),
        ],
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

  Color _getTopicColor(String topic) {
    switch (topic) {
      case 'Information':
        return Colors.blue;
      case 'Foods':
        return Colors.teal;
      case 'Restaurants':
        return Colors.pink;
      case 'Recommendation':
        return Colors.orange;
      case 'Experience':
        return Colors.deepOrange;
      default:
        return Colors.grey;
    }
  }

  Color _getBackgroundColor(String topic) {
    switch (topic) {
      case 'Information':
        return Colors.blue[50] ?? Colors.blue.withOpacity(0.1);
      case 'Foods':
        return Colors.teal[50] ?? Colors.teal.withOpacity(0.1);
      case 'Restaurants':
        return Colors.pink[50] ?? Colors.pink.withOpacity(0.1);
      case 'Recommendation':
        return Colors.orange[50] ?? Colors.orange.withOpacity(0.1);
      case 'Experience':
        return Colors.deepOrange[50] ?? Colors.deepOrange.withOpacity(0.1);
      default:
        return Colors.grey[50] ?? Colors.grey.withOpacity(0.1);
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}-${date.month}-${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final topicColor = _getTopicColor(question.topic);
    final backgroundColor = _getBackgroundColor(question.topic);

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
        side: BorderSide(color: Colors.grey[300]!),
      ),
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
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey[600]),
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
                  horizontal: 12.0,
                  vertical: 6.0,
                ),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(2),
                ),
                child: Text(
                  question.topic,
                  style: TextStyle(
                    fontSize: 12,
                    color: topicColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.reply, size: 16, color: Colors.grey[600]),
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