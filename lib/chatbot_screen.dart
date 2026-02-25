import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';
import 'picoclaw_chat_service.dart';

class ChatStartScreen extends StatefulWidget {
  const ChatStartScreen({super.key});

  @override
  State<ChatStartScreen> createState() => _ChatStartScreenState();
}

class _ChatStartScreenState extends State<ChatStartScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final PicoclawChatService _picoclawService = PicoclawChatService();
  
  // Initial message
  final List<Map<String, dynamic>> _messages = [
    {
      "text": "Hello! I'm PicoClaw. How can I help you with your shopping today?",
      "isUser": false,
      "time": DateTime.now(),
    }
  ];

  bool _isTyping = false;

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() async {
    final userMsg = _controller.text.trim();
    if (userMsg.isEmpty) return;

    // 1. Add User Message
    setState(() {
      _messages.add({
        "text": userMsg,
        "isUser": true,
        "time": DateTime.now(),
      });
      _controller.clear();
      _isTyping = true;
    });

    _scrollToBottom();

    // 2. Get Response from Ollama
    final botReply = await _picoclawService.sendMessage(userMsg);

    // 3. Add Bot Message
    if (mounted) {
      setState(() {
        _messages.add({
          "text": botReply,
          "isUser": false,
          "time": DateTime.now(),
        });
        _isTyping = false;
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    // Small delay to ensure the list updates before scrolling
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text("WorthIt Support", style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16)),
                const Row(
                    children: [
                        Icon(Icons.circle, color: Colors.green, size: 8),
                        SizedBox(width: 4),
                        Text("Online (PicoClaw)", style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                )
            ],
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        actions: [
            IconButton(
              icon: const Icon(Icons.refresh), 
              onPressed: () {
                setState(() {
                  _picoclawService.clearHistory();
                  _messages.clear();
                  _messages.add({
                    "text": "Chat history cleared. How can I help?",
                    "isUser": false,
                    "time": DateTime.now(),
                  });
                });
              },
              tooltip: "Clear Context",
            ),
        ],
      ),
      body: Column(
        children: [
          // 💬 CHAT AREA
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isUser = msg['isUser'];
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isUser ? AppTheme.primaryColor : Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                        bottomRight: isUser ? Radius.zero : const Radius.circular(16),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        )
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg['text'],
                          style: GoogleFonts.poppins(
                            color: isUser ? Colors.white : AppTheme.darkText,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _formatTime(msg['time']),
                          style: TextStyle(
                            color: isUser ? Colors.white70 : Colors.grey[400],
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // ⌨️ TYPING INDICATOR
          if (_isTyping)
             Padding(
               padding: const EdgeInsets.only(left: 16, bottom: 8),
               child: Row(
                 children: [
                   const SizedBox(
                     width: 15, height: 15, 
                     child: CircularProgressIndicator(strokeWidth: 2)
                   ),
                   const SizedBox(width: 8),
                   Text("PicoClaw is thinking...", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                 ],
               ),
             ),

          // 📝 INPUT AREA
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.black12)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Ask about orders, refunds...",
                        hintStyle: TextStyle(color: Colors.grey[400]),
                        filled: true,
                        fillColor: AppTheme.backgroundColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  FloatingActionButton(
                    onPressed: _sendMessage,
                    backgroundColor: AppTheme.primaryColor,
                    mini: true,
                    elevation: 0,
                    child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    return "${time.hour}:${time.minute.toString().padLeft(2, '0')}";
  }
}
