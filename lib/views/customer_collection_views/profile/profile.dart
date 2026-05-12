import 'package:flutter/material.dart';
import 'package:nkrs_app/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isLoading = true;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    
    // 1. Get the current user ID from the decoded JWT token
    _userId = await _authService.getUserIdFromToken();
    if (_userId != null) {
      // 2. Fetch customer details from the backend
      final profileData = await _authService.getCustomerProfile();
      if (profileData != null) {
        _nameController.text = "${profileData['firstName'] ?? ''} ${profileData['lastName'] ?? ''}".trim();
        _phoneController.text = profileData['phoneNumber'] ?? '';
        _emailController.text = profileData['email'] ?? '';
        _addressController.text = profileData['address'] ?? ''; // Employee entity might not have this, but keeping it as fallback
      }
    }
    
    setState(() => _isLoading = false);
  }

  Future<void> _saveProfile() async {
    if (_userId == null) return;
    
    setState(() => _isLoading = true);
    
    final names = _nameController.text.trim().split(' ');
    final firstName = names.isNotEmpty ? names.first : '';
    final lastName = names.length > 1 ? names.sublist(1).join(' ') : '';

    final updatedData = {
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": _phoneController.text.trim(),
      "email": _emailController.text.trim(),
      "address": _addressController.text.trim(),
    };
    
    // 3. Send updated data to the backend
    final success = await _authService.updateCustomerProfile(_userId!, updatedData);
    
    setState(() => _isLoading = false);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? "Profile updated successfully!" : "Failed to update profile.")),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: const BackButton(color: Colors.black),
        title: const Text(
          "Edit Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Profile Image (Centered)
                          Center(
                            child: Stack(
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey.shade200,
                                  child: const Icon(Icons.person, size: 50, color: Colors.grey),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Colors.blue,
                                    child: const Icon(
                                      Icons.edit,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          _label("FULL NAME"),
                          _textField(controller: _nameController),
                          const SizedBox(height: 16),

                          _label("PHONE NUMBER"),
                          _textField(controller: _phoneController, prefixIcon: Icons.phone_outlined),
                          const SizedBox(height: 16),

                          _label("EMAIL ADDRESS"),
                          _textField(controller: _emailController, prefixIcon: Icons.email_outlined),
                          const SizedBox(height: 16),

                          _label("RESIDENTIAL ADDRESS"),
                          _textField(controller: _addressController, prefixIcon: Icons.location_on_outlined),
                        ],
                      ),
                    ),
                  ),
                ),

                // Bottom Buttons
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D6CDF),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _saveProfile,
                          icon: const Icon(Icons.save_outlined, color: Colors.white),
                          label: const Text(
                            "Save Changes",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.close, color: Colors.red),
                          label: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color.fromARGB(234, 107, 102, 102),
        ),
      ),
    );
  }

  Widget _textField({required TextEditingController controller, IconData? prefixIcon}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
