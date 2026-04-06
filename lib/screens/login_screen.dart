import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/hybrid_auth_service.dart';
import '../services/dialog_service.dart';
import 'signup_screen.dart';
import 'dashboard_screen.dart';
import 'admin_home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final HybridAuthService _authService = HybridAuthService();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    // Show loading dialog
    if (mounted) {
      DialogService.showLoadingDialog(context, message: 'Signing you in...');
    }

    try {
      Map<String, dynamic>? user = await _authService.signInWithEmailPassword(
        _emailController.text.trim(),
        _passwordController.text,
      );

      // Hide loading dialog
      if (mounted) {
        DialogService.hideLoadingDialog(context);
      }

      if (user != null && mounted) {
        // Check if user is admin
        final isAdmin = user['isAdmin'] == true;

        // Show success dialog
        DialogService.showSuccessDialog(
          context,
          title: 'Welcome Back!',
          message: isAdmin
              ? 'Welcome Administrator! Redirecting to Admin Panel...'
              : 'You have successfully logged in. Welcome to See Adventure!',
          buttonText: 'Continue',
          onButtonPressed: () {
            Navigator.of(context).pop(); // Close dialog first
            if (isAdmin) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminHomeScreen(),
                ),
                (route) => false,
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const DashboardScreen(),
                ),
              );
            }
          },
        );
      }
    } catch (e) {
      // Hide loading dialog
      if (mounted) {
        DialogService.hideLoadingDialog(context);
      }

      // Show error dialog with specific error messages
      String errorMessage = 'An error occurred during login.';

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            errorMessage =
                'No account found with this email/username. Please check your credentials or sign up.';
            break;
          case 'wrong-password':
            errorMessage =
                'Incorrect password. Please try again or reset your password.';
            break;
          case 'invalid-email':
            errorMessage =
                'The email address is not valid. Please check and try again.';
            break;
          case 'user-disabled':
            errorMessage =
                'This account has been disabled. Please contact support.';
            break;
          case 'too-many-requests':
            errorMessage = 'Too many failed attempts. Please try again later.';
            break;
          default:
            errorMessage = e.message ?? 'An error occurred during login.';
        }
      } else {
        errorMessage = e.toString();
      }

      if (mounted) {
        DialogService.showErrorDialog(
          context,
          title: 'Login Failed',
          message: errorMessage,
        );
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    // Show loading dialog
    if (mounted) {
      DialogService.showLoadingDialog(
        context,
        message: 'Signing in with Google...',
      );
    }

    try {
      Map<String, dynamic>? user = await _authService.signInWithGoogle();

      // Hide loading dialog
      if (mounted) {
        DialogService.hideLoadingDialog(context);
      }

      if (user != null && mounted) {
        // Check if user is admin (Google users are not admin by default)
        final isAdmin = user['isAdmin'] == true;

        // Show success dialog
        DialogService.showSuccessDialog(
          context,
          title: 'Welcome Back!',
          message: isAdmin
              ? 'Welcome Administrator! Redirecting to Admin Panel...'
              : 'You have successfully logged in with Google. Welcome to See Adventure!',
          buttonText: 'Continue',
          onButtonPressed: () {
            Navigator.of(context).pop(); // Close dialog first
            if (isAdmin) {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdminHomeScreen(),
                ),
                (route) => false,
              );
            } else {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const DashboardScreen(),
                ),
              );
            }
          },
        );
      }
    } catch (e) {
      // Hide loading dialog
      if (mounted) {
        DialogService.hideLoadingDialog(context);
      }

      // Show error dialog
      if (mounted) {
        DialogService.showErrorDialog(
          context,
          title: 'Google Sign-In Failed',
          message: 'Failed to sign in with Google. Please try again.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                // Logo or Title
                Icon(Icons.explore, size: 100, color: Colors.blue.shade800),
                const SizedBox(height: 20),
                Text(
                  'See Adventure',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade800,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Welcome Back!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 30),
                // Email/Username Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email or Username',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email or username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // Login Button
                ElevatedButton(
                  onPressed: _signInWithEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Login', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 20),
                // Google Sign-In Button
                OutlinedButton.icon(
                  onPressed: _signInWithGoogle,
                  icon: const Icon(Icons.g_mobiledata),
                  label: const Text('Sign in with Google'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignupScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                          color: Colors.blue.shade800,
                          fontWeight: FontWeight.bold,
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
}
