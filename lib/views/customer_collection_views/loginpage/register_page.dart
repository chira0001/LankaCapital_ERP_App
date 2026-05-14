import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _employeeNumberController =
      TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool agree = false;
  bool _isLoading = false;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    if (!agree) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please accept terms")));
      return;
    }

    setState(() => _isLoading = true);

    try {
      final firstName = _firstNameController.text.trim();
      final lastName = _lastNameController.text.trim();

      final url = Uri.parse("http://10.0.2.2:8080/api/v1/auth/register");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": _employeeNumberController.text.trim(),
          "firstName": firstName,
          "lastName": lastName,
          "email": _emailController.text.trim(),
          "phoneNumber": _phoneController.text.trim(),
          "password": _passwordController.text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Registration successful")),
          );
          Navigator.pop(context);
        }
      } else {
        if (mounted) {
          String errorMessage = "Registration failed";
          try {
            final errorData = jsonDecode(response.body);
            // Spring Boot often returns a "message" or "error" field for exceptions
            errorMessage =
                errorData['message'] ?? errorData['error'] ?? response.body;
          } catch (_) {
            // If it's not JSON, just show the plain string (but limit length just in case)
            errorMessage = response.body.length > 50
                ? "An error occurred"
                : response.body;
          }

          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Failed: $errorMessage")));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Server not reachable")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _employeeNumberController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F4F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          "Create Account",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    child: Form(
                      // Wrapped Column in Form
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: const Color(0xFFDDE3EC),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              children: [
                                Image.asset("assets/logo.png", height: 100),
                                const SizedBox(height: 10),
                                const Text(
                                  "N.K.R.S",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Text(
                                  "LANKA CAPITAL",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "First Name",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 8),

                          buildTextField(
                            hint: "John",
                            icon: Icons.person_outline,
                            controller: _firstNameController,
                            validator: (value) => value!.isEmpty
                                ? 'First name is required'
                                : null,
                          ),
                          const SizedBox(height: 15),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Last Name",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 8),

                          buildTextField(
                            hint: "Doe",
                            icon: Icons.person_outline,
                            controller: _lastNameController,
                            validator: (value) =>
                                value!.isEmpty ? 'Last name is required' : null,
                          ),
                          const SizedBox(height: 15),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Email Address",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 8),
                          buildTextField(
                            hint: "john@example.com",
                            icon: Icons.email_outlined,
                            controller: _emailController,
                            validator: (value) {
                              if (value == null || value.isEmpty)
                                // ignore: curly_braces_in_flow_control_structures
                                return 'Email is required';
                              if (!RegExp(
                                r'^[^@]+@[^@]+\.[^@]+',
                              ).hasMatch(value))
                                // ignore: curly_braces_in_flow_control_structures
                                return 'Enter valid email';
                              return null;
                            },
                          ),
                          const SizedBox(height: 15),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Phone Number",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 8),

                          buildTextField(
                            hint: "+94 77 123 4567",
                            icon: Icons.phone_outlined,
                            controller: _phoneController,
                            validator: (value) =>
                                value!.isEmpty ? 'Phone is required' : null,
                          ),
                          const SizedBox(height: 15),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Employee Number",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 8),
                          buildTextField(
                            hint: "EMP123456",
                            icon: Icons.badge_outlined,
                            controller: _employeeNumberController,
                            validator: (value) => value!.isEmpty
                                ? 'Employee number is required'
                                : null,
                          ),
                          const SizedBox(height: 15),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Password",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 8),

                          buildTextField(
                            hint: "••••••••",
                            icon: Icons.lock_outline,
                            obscure: obscurePassword,
                            isPassword: true,
                            controller: _passwordController,
                            validator: (value) => value!.length < 6
                                ? 'Password must be at least 6 characters'
                                : null,
                            onToggle: () {
                              setState(() {
                                obscurePassword = !obscurePassword;
                              });
                            },
                          ),
                          const SizedBox(height: 15),
                          const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Confirm Password",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                          const SizedBox(height: 8),
                          buildTextField(
                            hint: "••••••••",
                            icon: Icons.lock_reset_outlined,
                            obscure: obscureConfirmPassword,
                            isPassword: true,
                            controller: _confirmPasswordController,
                            validator: (value) {
                              if (value!.isEmpty)
                                // ignore: curly_braces_in_flow_control_structures
                                return 'Confirm your password';
                              if (value != _passwordController.text)
                                // ignore: curly_braces_in_flow_control_structures
                                return 'Passwords do not match';
                              return null;
                            },
                            onToggle: () {
                              setState(() {
                                obscureConfirmPassword =
                                    !obscureConfirmPassword;
                              });
                            },
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Checkbox(
                                value: agree,
                                onChanged: (val) {
                                  setState(() {
                                    agree = val!;
                                  });
                                },
                              ),
                              const Expanded(
                                child: Text(
                                  "I agree to the Terms and Conditions and Privacy Policy",
                                  style: TextStyle(color: Colors.black54),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: ElevatedButton(
                              onPressed: _isLoading
                                  ? null
                                  : _register, // Triggers API Call
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  0,
                                  94,
                                  255,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      "Register Now",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Already have an account? "),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "Log in",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 50),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              FooterItem(text: "SECURE"),
                              FooterItem(text: "ENCRYPTED"),
                              FooterItem(text: "REGULATED"),
                            ],
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // Updated custom text field method to handle Form validation and Controllers
  Widget buildTextField({
    required String hint,
    required IconData icon,
    bool obscure = false,
    bool isPassword = false,
    VoidCallback? onToggle,
    TextEditingController? controller,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      // Changed from TextField to TextFormField
      controller: controller,
      validator: validator,
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: onToggle,
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class FooterItem extends StatelessWidget {
  final String text;

  const FooterItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.verified_user_outlined, size: 16),
        const SizedBox(width: 5),
        Text(text, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
