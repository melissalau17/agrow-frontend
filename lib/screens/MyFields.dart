import 'package:flutter/material.dart';
import 'package:agrow/screens/AddFieldPage.dart';

void navigateToFieldDetails(BuildContext context, String fieldName) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Navigating to $fieldName Details')),
  );
}

// Navigation to the Add Field page.
void navigateToAddField(BuildContext context) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const AddFieldPage(),
    ),
  );
}

class ControlsPage extends StatelessWidget {
  const ControlsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'My Fields',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF004D40), 
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('See All Fields')),
              );
            },
            child: const Text(
              'See All',
              style: TextStyle(
                color: Color(0xFF00A550), 
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // First Field Card
            FieldCard(
              imageUrl: 'https://placehold.co/600x400/D4F1C5/000000?text=Chili+Field+LIVE',
              fieldName: 'Chili Field',
              isLive: true,
              onTap: () => navigateToFieldDetails(context, 'Chili Field'),
            ),
            const SizedBox(height: 20),
            // Second Field Card
            FieldCard(
              imageUrl: 'https://placehold.co/600x400/D4F1C5/000000?text=Tomato+Field+LIVE',
              fieldName: 'Tomato Field',
              isLive: true,
              onTap: () => navigateToFieldDetails(context, 'Tomato Field'),
            ),
            const SizedBox(height: 20),
            // Add Field Button
            AddFieldButton(
              onTap: () => navigateToAddField(context),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for displaying individual field cards
class FieldCard extends StatelessWidget {
  final String imageUrl;
  final String fieldName;
  final bool isLive;
  final VoidCallback onTap;

  const FieldCard({
    required this.imageUrl,
    required this.fieldName,
    required this.isLive,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.1), BlendMode.darken),
          ),
        ),
        child: Stack(
          children: [
            if (isLive)
              Positioned(
                top: 10,
                left: 10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'LIVE',
                    style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            Positioned(
              bottom: 15,
              left: 15,
              child: Text(
                fieldName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(blurRadius: 5, color: Colors.black54)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget for the 'Add Field' button
class AddFieldButton extends StatelessWidget {
  final VoidCallback onTap;

  const AddFieldButton({
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 180,
        decoration: BoxDecoration(
          color: Colors.grey.shade200, // Light grey background
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.add_circle_outline,
              size: 50,
              color: Colors.grey,
            ),
            SizedBox(height: 10),
            Text(
              'Add Field',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}