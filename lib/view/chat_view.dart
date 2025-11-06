import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  void _sendMessage(String sender, String text) {
    if (text.trim().isEmpty) return;

    setState(() {
      _messages.add({
        'sender': sender,
        'message': text.trim(),
        'timestamp': DateTime.now().toString(),
      });

      // Jika pasien yang mengirim pesan -> psikolog balas otomatis
      if (sender == 'patient') {
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            _messages.add({
              'sender': 'psychologist',
              'message': _generateAutoReply(),
              'timestamp': DateTime.now().toString(),
            });
          });
        });
      }
    });

    _controller.clear();
  }

  // Contoh balasan otomatis dari psikolog
  String _generateAutoReply() {
    List<String> responses = [
      "Baik, bisa kamu ceritakan lebih detail?",
      "Terima kasih sudah berbagi, bagaimana perasaanmu saat ini?",
      "Aku mengerti. Mari kita bahas lebih lanjut.",
      "Kamu sudah melakukan hal yang hebat dengan membicarakannya.",
      "Jangan khawatir, kita akan melewati ini bersama.",
    ];
    responses.shuffle();
    return responses.first;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: const Text(
          "Chat with Psychologist",
          style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isPatient = msg['sender'] == 'patient';

                return Align(
                  alignment: isPatient
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isPatient
                          ? const Color(0xFF3D8BFF)
                          : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      msg['message'],
                      style: TextStyle(
                        color: isPatient ? Colors.white : Colors.black87,
                        fontSize: 15,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Input Field
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      filled: true,
                      fillColor: const Color(0xFFF5F6FA),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFF3D8BFF)),
                  onPressed: () => _sendMessage('patient', _controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
