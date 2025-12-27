import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_colors.dart';
import '../controller/filter_controller.dart';


class FilterScreen extends StatelessWidget {
  final FilterController controller = Get.put(FilterController());

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55,
      maxChildSize: 0.9,
      minChildSize: 0.4,
      builder: (context, scrollController) => Material(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Center(
                child: Text("Filter",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              SizedBox(height: 24),

              // User Selection
              Text("Select User",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(height: 12),
              Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.userRoles.map((role) {
                  bool isSelected = controller.selectedUser.contains(role);
                  return FilterChip(
                    label: Text(role),
                    selected: isSelected,
                    onSelected: (_) => controller.toggleUser(role),
                    labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textColor),
                    backgroundColor: Color(0xffF7F7F7),
                    selectedColor: Colors.teal,
                  );
                }).toList(),
              )),

              SizedBox(height: 24),

              // Subjects Selection
              Text("Subjects",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              SizedBox(height: 12),
              Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.subjects.map((subject) {
                  bool isSelected = controller.selectedSubjects.contains(subject);
                  return FilterChip(
                    label: Text(subject),
                    selected: isSelected,
                    onSelected: controller.canSelectSubjects
                        ? (_) => controller.toggleSubject(subject)
                        : null,
                    labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textColor),
                    backgroundColor: Color(0xffF7F7F7),
                    selectedColor: Colors.teal,
                  );
                }).toList(),
              )),

              SizedBox(height: 30),

              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => controller.reset(),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.secondColor,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: AppColors.secondColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text('Reset',
                          style: TextStyle(color: Colors.teal, fontSize: 16)),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context, controller.filterResult);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text('Filter',
                          style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
