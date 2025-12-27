import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/payment_screen_controller.dart';
import '../models/payment_screen_model.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final PaymentController controller = Get.put(PaymentController());

  String selectedFilter = "Last 7 days";
  String selectedTransactionPeriod = "Last 7 days";

  final List<String> filterOptions = ["Last 7 days", "Last 30 days", "All Time"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        title: const Text("My Wallet", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Obx(() {
          if (controller.isError.value) {
            return Center(child: Text(controller.errorMessage.value));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBalanceCard(),
              const SizedBox(height: 24),
              _buildTransactionHeader(),
              const SizedBox(height: 12),
              _buildTransactionList(controller.users),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Current Balance", style: TextStyle(fontSize: 14, color: Colors.grey)),
              _buildDropdown(
                value: selectedFilter,
                onChanged: (val) {
                  if (val != null) setState(() => selectedFilter = val);
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            "\$${controller.totalPayments.toStringAsFixed(2)}",
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            "+${controller.percentageChange} This week",
            style: const TextStyle(color: Colors.teal, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButton<String>(
      value: value,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      dropdownColor: Colors.white,
      style: const TextStyle(color: Colors.teal),
      underline: const SizedBox(),
      icon: const Icon(Icons.keyboard_arrow_down, color: Colors.teal),
      borderRadius: BorderRadius.circular(10),
      items: filterOptions
          .map((e) => DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildTransactionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Recent Transactions",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        _buildDropdown(
          value: selectedTransactionPeriod,
          onChanged: (val) => setState(() => selectedTransactionPeriod = val!),
        ),
      ],
    );
  }

  Widget _buildTransactionList(List<User> users) {
    if (users.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 20),
        child: Center(child: Text("No transactions found")),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: users.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: CircleAvatar(
            radius: 22,
            backgroundImage: user.student?.profileImage != null
                ? NetworkImage(user.student!.profileImage!)
                : const AssetImage('assets/images/profile.png') as ImageProvider,
          ),
          title: Text(user.student?.fullName ?? "Unknown"),
          subtitle: Text(user.studentId ?? ""),
          trailing: Text(
            "+\$${user.amountPaid?.toStringAsFixed(2) ?? '0.00'}",
            style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}
