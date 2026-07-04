import 'package:flutter/material.dart';
import 'package:nkrs_app/data/services/auth_service.dart';
import 'package:nkrs_app/views/customer_collection_views/loginpage/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final AuthService _authService = AuthService();

  // Controllers
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _nicController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;
  String? _userId;
  Map<String, dynamic>? _profileData;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final profile = await _authService.getCustomerProfile();
    final userId = await _authService.getUserIdFromToken();

    if (mounted) {
      setState(() {
        _profileData = profile;
        _userId = userId;
        _isLoading = false;

        if (profile != null) {
          _firstNameController.text = profile['firstName'] ?? '';
          _lastNameController.text = profile['lastName'] ?? '';
          _nicController.text = profile['nic']?.toString() ?? '';
          _phoneController.text = profile['phoneNumber'] ?? '';
          _emailController.text = profile['email'] ?? '';
          _addressController.text = profile['address'] ?? '';
        }
      });
    }
  }

  // Validation helpers
  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    final digitsOnly = phone.replaceAll(RegExp(r'\D'), '');
    return digitsOnly.length == 10;
  }

  Future<void> _saveProfile() async {
    if (_userId == null || _profileData == null) return;

    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final nic = _nicController.text.trim();
    final phone = _phoneController.text.trim();
    final email = _emailController.text.trim();
    final address = _addressController.text.trim();

    // Validation
    if (firstName.isEmpty || lastName.isEmpty) {
      _showSnackBar('First name and Last name are required');
      return;
    }

    if (nic.isEmpty) {
      _showSnackBar('NIC is required');
      return;
    }

    if (!_isValidPhone(phone)) {
      _showSnackBar('Phone number must be 10 digits');
      return;
    }

    if (!_isValidEmail(email)) {
      _showSnackBar('Please enter a valid email address');
      return;
    }

    setState(() => _isSaving = true);

    final updatedData = {
      ..._profileData!,
      'firstName': firstName,
      'lastName': lastName,
      'nic': nic.isNotEmpty
          ? int.tryParse(nic)
          : null, // Backend expects Long/Integer
      'phoneNumber': phone,
      'email': email,
      'address': address,
    };

    final success = await _authService.updateCustomerProfile(
      _userId!,
      updatedData,
    );

    if (mounted) {
      setState(() => _isSaving = false);
      _showSnackBar(
        success ? 'Profile updated successfully!' : 'Failed to update profile.',
      );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _logout() async {
    await _authService.logout();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _nicController.dispose();
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
                            color: Colors.grey.withValues(alpha: 26),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Profile Image
                          Center(
                            child: Stack(
                              children: [
                                const CircleAvatar(
                                  radius: 50,
                                  backgroundImage: AssetImage(
                                    "assets/avatar.png",
                                  ),
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

                          _label("FIRST NAME"),
                          _textField(_firstNameController),
                          const SizedBox(height: 16),

                          _label("LAST NAME"),
                          _textField(_lastNameController),
                          const SizedBox(height: 16),

                          _label("NIC"),
                          _textField(
                            _nicController,
                            prefixIcon: Icons.credit_card,
                          ),
                          const SizedBox(height: 16),

                          _label("PHONE NUMBER"),
                          _textField(
                            _phoneController,
                            prefixIcon: Icons.phone_outlined,
                          ),
                          const SizedBox(height: 16),

                          _label("EMAIL ADDRESS"),
                          _textField(
                            _emailController,
                            prefixIcon: Icons.email_outlined,
                          ),
                          const SizedBox(height: 16),

                          _label("RESIDENTIAL ADDRESS"),
                          _textField(
                            _addressController,
                            prefixIcon: Icons.location_on_outlined,
                          ),
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
                          onPressed: _isSaving ? null : _saveProfile,
                          icon: _isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(
                                  Icons.save_outlined,
                                  color: Colors.white,
                                ),
                          label: Text(
                            _isSaving ? "Saving..." : "Save Changes",
                            style: const TextStyle(
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
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: _logout,
                          icon: const Icon(Icons.logout, color: Colors.red),
                          label: const Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
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

  Widget _textField(
    TextEditingController controller, {
    IconData? prefixIcon,
    bool readOnly = false,
  }) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: prefixIcon == Icons.phone_outlined
          ? TextInputType.phone
          : prefixIcon == Icons.email_outlined
          ? TextInputType.emailAddress
          : TextInputType.text,
      style: TextStyle(color: readOnly ? Colors.grey.shade700 : Colors.black),
      decoration: InputDecoration(
        prefixIcon: prefixIcon != null ? Icon(prefixIcon, size: 20) : null,
        filled: readOnly,
        fillColor: readOnly ? Colors.grey.shade100 : Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
