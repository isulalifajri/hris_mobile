import 'package:flutter/material.dart';
import '../../auth/models/user_model.dart';

class HomeScreen extends StatelessWidget {
  final UserModel user;

  const HomeScreen({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    final initial = user.name.isNotEmpty ? user.name[0].toUpperCase() : '?';

    return Scaffold(
      appBar: AppBar(
        actions: [
          CircleAvatar(child: Text(initial)),
          const SizedBox(width: 16),
        ],
      ),
      body: Center(
        child: Text(
          user.name,
          style: const TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
