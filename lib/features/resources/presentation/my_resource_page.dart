import 'package:flutter/material.dart';

class MyResourcePage extends StatelessWidget {
  const MyResourcePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Resource'),
        backgroundColor: const Color.fromARGB(139, 161, 244, 179),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const Text(
              'Learning Resources',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Here you can find helpful links and documents for your study.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            Card(
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.book, color: Colors.blue),
                title: const Text('Flutter Documentation'),
                subtitle: const Text('Official Flutter guides and API reference.'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Open Flutter Documentation')),
                  );
                },
              ),
            ),

            Card(
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.video_library, color: Colors.red),
                title: const Text('YouTube Tutorials'),
                subtitle: const Text('Watch Flutter video tutorials.'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Open YouTube Tutorials')),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
