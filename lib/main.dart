import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class User {
  String name;
  String imagePath;
  User({required this.name, required this.imagePath});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ChatListScreen(),
    );
  }
}

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final List<User> users = [
    User(name: "Karishma", imagePath: "assets/image/images1.jpeg"),
    User(name: "Shiv", imagePath: "assets/image/images2.jpeg"),
  ];

  final TextEditingController nameController = TextEditingController();

  void addUser() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New User"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: "Enter user name"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              nameController.clear();
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.trim().isEmpty) return;

              setState(() {
                // Naye user ko Shiv ke niche add karenge
                int shivIndex = users.indexWhere((user) => user.name == "Shiv");
                if (shivIndex != -1) {
                  users.insert(shivIndex + 1, User(
                    name: nameController.text.trim(),
                    imagePath: "assets/image/default.jpeg", // default image
                  ));
                } else {
                  users.add(User(
                    name: nameController.text.trim(),
                    imagePath: "assets/image/default.jpeg",
                  ));
                }
              });
              Navigator.pop(context);
              nameController.clear();
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'All User',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: ListView.separated(
        itemCount: users.length,
        separatorBuilder: (context, index) => const Divider(
          thickness: 1,
          color: Colors.grey,
          indent: 10,
          endIndent: 10,
        ),
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(user.imagePath),
            ),
            title: Text(
              user.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(name: user.name),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addUser,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String name;
  const ChatScreen({super.key, required this.name});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<Map<String, String>> messages = [];
  final TextEditingController controller = TextEditingController();

  void sendMessage(String text) {
    if (text.trim().isEmpty) return;
    setState(() {
      messages.add({'sender': 'user', 'text': text});
      messages.add({'sender': 'bot', 'text': "Bot: You said '$text'"});
    });
    controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isUser = msg['sender'] == 'user';
                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    decoration: BoxDecoration(
                      color: isUser ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg['text']!,
                      style: TextStyle(color: isUser ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.grey[200],
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Type a message",
                      border: InputBorder.none,
                    ),
                    onSubmitted: sendMessage,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () => sendMessage(controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
