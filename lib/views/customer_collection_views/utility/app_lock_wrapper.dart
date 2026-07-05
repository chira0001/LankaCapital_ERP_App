import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';
import 'package:nkrs_app/data/services/auth_service.dart';
import 'package:nkrs_app/views/customer_collection_views/loginpage/login_page.dart';

class AppLockWrapper extends StatefulWidget {
  final Widget child;
  final bool initialAuthenticated;
  const AppLockWrapper({
    super.key, 
    required this.child, 
    this.initialAuthenticated = false,
  });

  @override
  State<AppLockWrapper> createState() => _AppLockWrapperState();
}

class _AppLockWrapperState extends State<AppLockWrapper> with WidgetsBindingObserver {
  final LocalAuthentication auth = LocalAuthentication();
  final AuthService _authService = AuthService();
  
  late bool _isAuthenticated;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _isAuthenticated = widget.initialAuthenticated;
    WidgetsBinding.instance.addObserver(this);
    if (!_isAuthenticated) {
      _checkAndAuthenticate();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (!_isAuthenticated && !_isAuthenticating) {
         _checkAndAuthenticate();
      }
    } else if (state == AppLifecycleState.paused) {
      // Lock the app ONLY when it goes fully to the background (paused).
      // 'inactive' state (notifications, recent tasks) will no longer trigger a lock.
      setState(() {
        _isAuthenticated = false;
      });
    }
  }

  Future<void> _checkAndAuthenticate() async {
    if (_isAuthenticating) return;

    // Check if the user is still logged in
    final isLoggedIn = await _authService.isLoggedIn();
    if (!isLoggedIn) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      return;
    }

    bool canCheckBiometrics = false;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    }

    if (!canCheckBiometrics) {
      // If biometrics are not available, allow them in (or we could force password)
      if (mounted) {
        setState(() {
          _isAuthenticated = true;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isAuthenticating = true;
      });
    }

    bool authenticated = false;
    try {
      // Trying the signature matching login_page.dart
      // ignore: deprecated_member_use
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint or face to unlock',
        biometricOnly: true,
      );
    } on PlatformException catch (e) {
      debugPrint(e.toString());
    } catch (e) {
      debugPrint(e.toString());
    }

    if (mounted) {
      setState(() {
        _isAuthenticated = authenticated;
        _isAuthenticating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthenticated) {
      return widget.child;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.lock_outline, size: 80, color: Colors.blue.shade900),
            const SizedBox(height: 20),
            const Text(
              "App Locked",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "Please authenticate to continue",
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            if (!_isAuthenticating)
              ElevatedButton.icon(
                onPressed: _checkAndAuthenticate,
                icon: const Icon(Icons.fingerprint),
                label: const Text("Unlock"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade900,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            if (_isAuthenticating)
              const CircularProgressIndicator(),
              
            const SizedBox(height: 20),
            if (!_isAuthenticating)
              TextButton(
                onPressed: () async {
                  await _authService.logout();
                  if (!context.mounted) return;
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: const Text("Logout"),
              )
          ],
        ),
      ),
    );
  }
}
