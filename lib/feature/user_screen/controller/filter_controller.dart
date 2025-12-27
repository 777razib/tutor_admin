import 'package:get/get.dart';

class FilterController extends GetxController {
  // Roles and subjects
  final List<String> userRoles = ['Teacher', 'Student'];
  final List<String> subjects = [
    'Math', 'English', 'Bengali', 'Physics',
    'Chemistry', 'Biology', 'ICT', 'Geography', 'More'
  ];

  // Selected items
  var selectedUser = <String>[].obs;
  var selectedSubjects = <String>[].obs;

  // Toggle User
  void toggleUser(String role) {
    if (selectedUser.contains(role)) {
      selectedUser.remove(role);
      if (role == 'Student') selectedSubjects.clear();
    } else {
      selectedUser.add(role);
      if (role == 'Student') selectedSubjects.clear();
    }
  }

  // Toggle Subject (only if Teacher is selected)
  void toggleSubject(String subject) {
    if (!selectedUser.contains('Teacher')) return;
    if (selectedSubjects.contains(subject)) {
      selectedSubjects.remove(subject);
    } else {
      selectedSubjects.add(subject);
    }
  }

  // Reset all
  void reset() {
    selectedUser.clear();
    selectedSubjects.clear();
  }

  // Check if subjects can be selected
  bool get canSelectSubjects => selectedUser.contains('Teacher');

  // Return selected filter
  Map<String, List<String>> get filterResult => {
    "roles": selectedUser,
    "subjects": selectedSubjects,
  };
}
