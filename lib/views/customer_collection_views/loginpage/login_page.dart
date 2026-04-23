import 'package:flutter/material.dart';
import 'package:nkrs_app/views/customer_collection_views/customerCollectionpage/customer_collection_home.dart';
import 'package:nkrs_app/views/customer_collection_views/loginpage/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 245, 245),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset("Assets/logo.png", height: 100),

                const SizedBox(height: 10),

                const Text(
                  "N.K.R.S",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),

                const Text(
                  "LANKA CAPITAL",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),

                const SizedBox(height: 15),

                const Text(
                  "Securely manage your transfers",
                  style: TextStyle(color: Colors.grey),
                ),

                const SizedBox(height: 30),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Welcome Back",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Please enter your details to sign in.",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 20),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Email Address",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 8),

                // EMAIL FIELD
                TextField(
                  decoration: InputDecoration(
                    hintText: "Enter your email",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    prefixIcon: const Icon(Icons.email_outlined),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Password",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),

                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "Forgot password?",
                        style: TextStyle(
                          color: Color.fromARGB(255, 77, 124, 190),
                        ),
                      ),
                    ),
                  ],
                ),

                // PASSWORD FIELD
                TextField(
                  obscureText: obscurePassword,
                  decoration: InputDecoration(
                    hintText: "Enter your password",
                    hintStyle: TextStyle(color: Colors.grey.shade500),
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: const [
                    Checkbox(value: false, onChanged: null),
                    Text("Remember this device"),
                  ],
                ),
                const SizedBox(height: 10),

                // LOGIN BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CustomerCollectionHome(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 0, 140, 255),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Row(
                  children: const [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("OR CONTINUE WITH"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    socialButton(Icons.fingerprint),
                    const SizedBox(width: 15),
                    socialButton(Icons.face),
                  ],
                ),

                const SizedBox(height: 25),

                // SIGN UP
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget socialButton(IconData icon) {
    return Container(
      height: 55,
      width: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Icon(icon),
    );
  }
}
