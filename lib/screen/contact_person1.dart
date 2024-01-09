import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactPersonScreen extends StatefulWidget {
  @override
  _ContactPersonScreenState createState() => _ContactPersonScreenState();
}

class _ContactPersonScreenState extends State<ContactPersonScreen> {
  // Informasi kontak admin
  final String adminName = 'Budi';
  final String adminContact = '082245111828';
  final String adminEmail = 'baksotepung@gmail.com';
  final String adminInstagram = 'ampundj';
  final String adminTwitter = 'roh halus';
  final String officeAddress = 'Jln.Bakso Medan No 22, Blitar Utara';

  final TextEditingController _textController = TextEditingController();
  List<ChatMessage> _chatMessages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Person'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                'https://i.ibb.co/vxbFHLs/ababil-removebg-preview.png',
                height: 100,
                width: 100,
                // Adjust the height and width as needed
                fit: BoxFit.contain,
              ),
              SizedBox(height: 16),
              Text(
                'Nama Admin: $adminName',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mail, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    'Kontak Admin: $adminContact',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.email, color: Colors.blue),
                  SizedBox(width: 8),
                  Text(
                    'Email Admin: $adminEmail',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.instagram, color: Colors.purple),
                  SizedBox(width: 8),
                  Text(
                    'Instagram: $adminInstagram',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(FontAwesomeIcons.twitter, color: Colors.lightBlue),
                  SizedBox(width: 8),
                  Text(
                    'Twitter: $adminTwitter',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Alamat Kantor:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                officeAddress,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 32),
              Text(
                'Chat untuk Keluhan:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ..._chatMessages,
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _textController,
                      decoration: InputDecoration(
                        hintText: 'Tulis keluhan Anda di sini...',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      String userMessage = _textController.text.trim();
                      if (userMessage.isNotEmpty) {
                        // Kirim pesan dari user ke chat
                        _addMessage(ChatMessage(
                          message: userMessage,
                          isUser: true,
                        ));

                        // Simulasi balasan dari bot
                        _simulateBotResponse(userMessage);
                      }
                    },
                    icon: FaIcon(FontAwesomeIcons.exclamationCircle),
                    label: Text('Kirim'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _simulateBotResponse(String userMessage) {
    // Simulasi logika bot
    String botResponse = "Terima kasih atas keluhan Anda! Kami akan segera menanggapi.";

    // Kirim pesan dari bot ke chat
    _addMessage(ChatMessage(
      message: botResponse,
      isUser: false,
    ));

    // Bersihkan input text controller
    _textController.clear();
  }

  void _addMessage(ChatMessage message) {
    setState(() {
      _chatMessages.add(message);
    });
  }
}

class ChatMessage extends StatelessWidget {
  final String message;
  final bool isUser;

  ChatMessage({required this.message, required this.isUser});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: isUser ? Colors.blue : Colors.grey[300],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Text(
            message,
            style: TextStyle(fontSize: 16, color: isUser ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }
}
