// show_profile_dialog_widget.dart
import 'package:flutter/material.dart';

class ShowProfileDialogWidget extends StatelessWidget {
  final String? imageUrl;
  final String? fullName;
  final String? email;
  final String? phone;
  final String? gender;
  final String? city;
  final String? hourlyRate;
  final String? subject;
  final String? university;
  final String? experience;
  final String? about;

  const ShowProfileDialogWidget({
    super.key,
    this.imageUrl,
    this.fullName,
    this.email,
    this.phone,
    this.gender,
    this.city,
    this.hourlyRate,
    this.subject,
    this.university,
    this.experience,
    this.about,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        constraints: const BoxConstraints(maxHeight: 700),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Profile Image
              ClipRRect(
                borderRadius: BorderRadius.circular(80),
                child: Image.network(
                  imageUrl ?? '',
                  width: 140,
                  height: 140,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const CircleAvatar(
                    radius: 70,
                    child: Icon(Icons.person, size: 60),
                  ),
                ),
              ),

              const SizedBox(height: 16),
              Text(
                fullName ?? 'N/A',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                subject ?? 'No subjects',
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),

              const SizedBox(height: 24),

              // Info Table
              _buildInfoRow(Icons.email, 'Email', email),
              _buildInfoRow(Icons.phone, 'Phone', phone),
              _buildInfoRow(Icons.person, 'Gender', gender),
              _buildInfoRow(Icons.location_city, 'City', city),
              _buildInfoRow(Icons.attach_money, 'Hourly Rate', hourlyRate),
              _buildInfoRow(Icons.school, 'University', university),
              _buildInfoRow(Icons.work, 'Experience', experience),
              _buildInfoRow(Icons.book, 'Subjects', subject),

              const SizedBox(height: 20),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('About', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 8),
              Text(about ?? 'No description available.'),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value ?? 'N/A')),
        ],
      ),
    );
  }
}