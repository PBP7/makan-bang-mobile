import 'package:flutter/material.dart';
import 'package:makan_bang/forum/models/forum_question.dart';
import 'package:makan_bang/forum/screens/details.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class ForumFormPage extends StatefulWidget {
  final ForumQuestion? forum;
  
  const ForumFormPage({super.key, this.forum});

  @override
  State<ForumFormPage> createState() => _ForumFormPageState();
}

class _ForumFormPageState extends State<ForumFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _questionController;
  String _selectedTopic = 'Information';

  final List<String> _topics = [
    'Information',
    'Foods',
    'Restaurants',
    'Recommendation',
    'Experience'
  ];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.forum?.title ?? '');
    _questionController = TextEditingController(text: widget.forum?.question ?? '');
    if (widget.forum != null) {
      _selectedTopic = widget.forum!.topic;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _questionController.dispose();
    super.dispose();
  }
    
  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.forum == null ? 'New Forum Discussion' : 'Edit Forum',
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // title Field
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue[900]!),
                    ),
                    floatingLabelStyle: TextStyle(color: Colors.blue[900]),
                    labelStyle: TextStyle(color: Colors.grey[700]),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    if (value.length > 100) {
                      return 'Title must be less than 100 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // questions field
                TextFormField(
                  controller: _questionController,
                  decoration: InputDecoration(
                    labelText: 'Discussion',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue[900]!),
                    ),
                    floatingLabelStyle: TextStyle(color: Colors.blue[900]),
                    labelStyle: TextStyle(color: Colors.grey[700]),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter discussion content';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // topic dropdown
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Topic',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue[900]!),
                    ),
                    floatingLabelStyle: TextStyle(color: Colors.blue[900]),
                    labelStyle: TextStyle(color: Colors.grey[700]),
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
                    }
                  },
                ),
                const SizedBox(height: 24),

                // submit button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ).copyWith(
                    overlayColor: WidgetStateProperty.resolveWith<Color?>(
                      (Set<WidgetState> states) {
                        if (states.contains(WidgetState.pressed) ||
                            states.contains(WidgetState.hovered)) {
                          return Colors.pink[800];
                        }
                        return null;
                      },
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      final response = await request.postJson(
                        widget.forum == null
                          ? "http://127.0.0.1:8000/forum/create-flutter/"
                          : "http://127.0.0.1:8000/forum/edit-flutter/${widget.forum!.id}/",
                        jsonEncode({
                          'title': _titleController.text,
                          'question': _questionController.text,
                          'topic': _selectedTopic,
                        }),
                      );

                      if (context.mounted) {
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(response['message'])),
                          );
                          
                          if (widget.forum == null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForumDetailPage(
                                  question: ForumQuestion.fromJson(response['forum']),
                                ),
                              ),
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ForumDetailPage(
                                  question: ForumQuestion.fromJson(response['forum']),
                                ),
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: ${response['message']}')),
                          );
                        }
                      }
                    }
                  },
                  child: Text(widget.forum == null ? 'Post Forum' : 'Save Changes'),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}