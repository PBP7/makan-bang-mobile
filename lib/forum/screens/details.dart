import 'dart:convert';
import 'package:makan_bang/widgets/left_drawer.dart';
import 'package:flutter/material.dart';
import 'package:makan_bang/forum/models/forum_question.dart';
import 'package:makan_bang/forum/screens/forum_form.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class ForumDetailPage extends StatefulWidget {
  final ForumQuestion question;

  const ForumDetailPage({
    super.key,
    required this.question,
  });

  @override
  State<ForumDetailPage> createState() => _ForumDetailPageState();
}

class _ForumDetailPageState extends State<ForumDetailPage> {
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
  final TextEditingController _replyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  Future<void> _postReply(CookieRequest request) async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await request.post(
          'https://fariz-muhammad31-makanbang.pbp.cs.ui.ac.id/forum/create-reply-flutter/${widget.question.id}/',
          jsonEncode({
            'reply': _replyController.text,
          }),
        );

        if (mounted) {
          if (response['status'] == 'success') {
            final replyData = response['reply'];
            final newReply = Reply(
              id: replyData['id'],
              reply: replyData['reply'],
              createdAt: DateTime.parse(replyData['created_at']),
              user: User(
                id: replyData['user']['id'],
                username: replyData['user']['username'],
              ),
            );

            setState(() {
              widget.question.replies.add(newReply);
              widget.question.replycount++;
            });

            _replyController.clear();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${response['message']}')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    final topicColor = _getTopicColor(widget.question.topic);
    final backgroundColor = _getBackgroundColor(widget.question.topic);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('MAKAN BANG',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,)
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          if (widget.question.user.username == request.jsonData['username'] || request.jsonData['username'].toLowerCase() == 'admin') ...[
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ForumFormPage(forum: widget.question),
                  ),
                );
                if (result == true && mounted) {
                  Navigator.of(context).pop(true);
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _showDeleteConfirmation(context, request),
            ),
          ],
        ],
      ),
      drawer: const LeftDrawer(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                        widget.question.topic,
                        style: TextStyle(
                          fontSize: 12,
                          color: topicColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    Text(
                      widget.question.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    Row(
                      children: [
                        Icon(Icons.person_outline, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          widget.question.user.username,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          _formatDate(widget.question.createdAt),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(width: 16),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 251, 250, 247),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        widget.question.question,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    Row(
                      children: [
                        const Text(
                          'Replies',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${widget.question.replycount})',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    
                    if (widget.question.replies.isEmpty)
                      const Text('No replies yet')
                    else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.question.replies.length,
                      itemBuilder: (context, index) {
                        final reply = widget.question.replies[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 254, 252),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: const Color.fromARGB(255, 233, 230, 218),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: Text(
                                      reply.user.username[0].toUpperCase(),
                                      style: TextStyle(
                                        color: Colors.grey[900],
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          reply.user.username,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Row(
                                          children: [
                                            Icon(Icons.access_time, 
                                              size: 14, 
                                              color: Colors.grey[600]
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              _formatDate(reply.createdAt),
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  // add delete button if user is the owner of the reply or admin
                                  if (reply.user.username == request.jsonData['username'] || request.jsonData['username'].toLowerCase() == 'admin')
                                    IconButton(
                                      icon: const Icon(Icons.delete, size: 20),
                                      color: Colors.red,
                                      onPressed: () => _showDeleteReplyConfirmation(context, request, reply.id),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                reply.reply,
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Reply Form
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _replyController,
                      decoration: InputDecoration(
                        hintText: 'Share your thoughts...',
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue[900]!),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your reply';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send),
                    color: Colors.blue[900],
                    onPressed: () => _postReply(request),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showDeleteConfirmation(BuildContext context, CookieRequest request) async {
    final questionId = widget.question.id;
    final isAdmin = request.jsonData['username'].toLowerCase() == 'admin';
    final message = isAdmin && widget.question.user.username != request.jsonData['username']
        ? 'Are you sure you want to delete this forum as admin?'
        : 'Are you sure you want to delete this forum?';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Forum'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final response = await request.post(
          'https://fariz-muhammad31-makanbang.pbp.cs.ui.ac.id/forum/delete-flutter/$questionId/',
          {},
        );

        if (mounted) {
          if (response['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response['message'])),
            );
            Navigator.of(context).pop(true);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${response['message']}')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  Future<void> _showDeleteReplyConfirmation(BuildContext context, CookieRequest request, int replyId) async {
    final isAdmin = request.jsonData['username'].toLowerCase() == 'admin';
    final reply = widget.question.replies.firstWhere((r) => r.id == replyId);
    final message = isAdmin && reply.user.username != request.jsonData['username']
        ? 'Are you sure you want to delete this reply as admin?'
        : 'Are you sure you want to delete this reply?';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Reply'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final response = await request.post(
          'https://fariz-muhammad31-makanbang.pbp.cs.ui.ac.id/forum/delete-reply-flutter/$replyId/',
          {},
        );

        if (mounted) {
          if (response['status'] == 'success') {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(response['message'])),
            );

            setState(() {
              widget.question.replies.removeWhere((reply) => reply.id == replyId);
              widget.question.replycount--;
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${response['message']}')),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }
}