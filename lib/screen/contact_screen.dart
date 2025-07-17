import 'package:flutter/material.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Liên hệ'),
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.facebook), text: 'Facebook'),
              Tab(icon: Icon(Icons.chat), text: 'Messenger'),
              Tab(icon: Icon(Icons.more_horiz), text: 'Other'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildSocialTab(
              'Facebook',
              Icons.facebook,
              Colors.blue,
              'Facebook',
            ),
            _buildSocialTab(
              'Messenger',
              Icons.chat,
              Colors.blue[700]!,
              'Messenger',
            ),
            _buildSocialTab('Other', Icons.more_horiz, Colors.grey, 'Other'),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialTab(
    String title,
    IconData icon,
    Color color,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 50, color: color),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement URL launcher
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Kết nối',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
