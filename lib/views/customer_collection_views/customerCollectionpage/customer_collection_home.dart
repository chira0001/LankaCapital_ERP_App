import 'package:flutter/material.dart';

class CustomerCollectionHome extends StatefulWidget {
  const CustomerCollectionHome({super.key});

  @override
  State<CustomerCollectionHome> createState() => _CustomerCollectionHomeState();
}

class _CustomerCollectionHomeState extends State<CustomerCollectionHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),

              // Top Bar
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade900,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.account_balance,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        "Lanka Capital",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const CircleAvatar(
                    radius: 23,
                    backgroundImage: AssetImage("assets/avatar.png"),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Greeting
              const Text(
                "Hello, Alex",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text(
                "Manage your daily collections and loan requests.",
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),

              const SizedBox(height: 20),

              // Cards
              _buildCard(
                icon: Icons.person_search,
                iconColor: Colors.blue,
                title: "Customer Collection",
                subtitle:
                    "Add installment or view existing collection history for any borrower.",
              ),

              _buildCard(
                icon: Icons.post_add,
                iconColor: Colors.orange,
                title: "New Loan Request",
                subtitle:
                    "Submit a fresh loan application for a new or existing customer.",
              ),

              _buildCard(
                icon: Icons.print,
                iconColor: Colors.indigoAccent,
                title: "Add printer",
                subtitle: "Add New Thermal printer or Existing one.",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
            ],
          ),

          SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
