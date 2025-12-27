import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/const/app_colors.dart';
import '../controller/home_controller.dart';

class BarChart extends StatefulWidget {
  const BarChart({super.key});

  @override
  State<BarChart> createState() => _TutorGrapState();
}

class _TutorGrapState extends State<BarChart> {
  String selectedValue = 'Week'; // default view
  final HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    super.initState();
    controller.fetchHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // if (controller.isLoading.value) {
      //   return const Center(child: CircularProgressIndicator());
      // }
      if (controller.homeModel.value == null) {
        return const Center(child: Text("No data available"));
      }

      final isMonthView = selectedValue == 'Month';
      final values = isMonthView
          ? controller.last30Days.map((e) => e.amountPaid ?? 0).toList()
          : controller.last7Days.map((e) => e.amountPaid ?? 0).toList();

      final days = isMonthView
          ? controller.last30Days.map((e) => (e.date?.day ?? 0).toString()).toList()
          : controller.last7Days.map((e) => (e.date?.day ?? 0).toString()).toList();

      final maxValue = values.isNotEmpty ? values.reduce((a, b) => a > b ? a : b) : 100;

      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Earning',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
              ),
              DropdownButton<String>(
                value: selectedValue,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedValue = newValue!;
                  });
                },
                items: <String>['Week', 'Month']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                underline: Container(),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // ===== GRAPH =====
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  offset: const Offset(2, 2),
                  blurRadius: 6,
                )
              ],
            ),
            child: SizedBox(
              height: 220,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Y axis labels
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(5, (i) {
                      final label = (maxValue - (maxValue / 4) * i).toStringAsFixed(0);
                      return Text(label, style: const TextStyle(fontSize: 10));
                    }),
                  ),
                  const SizedBox(width: 12),
                  // Graph bars
                  Expanded(
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: List.generate(values.length, (index) {
                        final normalizedValue = values[index] / (maxValue == 0 ? 1 : maxValue);
                        return _buildGraphColumn(
                          value: normalizedValue,
                          label: days[index],
                          amount: values[index],
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildGraphColumn({
    required double value,
    required String label,
    required double amount,
  }) {
    double columnHeight = 140 * value;

    return Container(
      width: 30,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text("\$${amount.toStringAsFixed(0)}",
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Container(
            width: 25,
            height: columnHeight,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 6),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
