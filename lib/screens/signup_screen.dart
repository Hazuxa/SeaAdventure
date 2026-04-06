import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/hybrid_auth_service.dart';
import '../services/dialog_service.dart';
import 'login_screen.dart';
import 'dashboard_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final HybridAuthService _authService = HybridAuthService();
  bool _isCheckingUsername = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<bool> _checkUsernameAvailability(String username) async {
    if (username.trim().isEmpty) return false;

    setState(() {
      _isCheckingUsername = true;
    });

    try {
      bool exists = await _authService.usernameExists(username.trim());
      return !exists; // Return true if username is available
    } catch (e) {
      return false;
    } finally {
      if (mounted) {
        setState(() {
          _isCheckingUsername = false;
        });
      }
    }
  }

  Future<void> _signUpWithEmail() async {
    if (!_formKey.currentState!.validate()) return;

    // Check username availability first
    bool usernameAvailable = !(await _authService.usernameExists(
      _usernameController.text,
    ));
    if (!usernameAvailable) {
      if (mounted) {
        DialogService.showErrorDialog(
          context,
          title: 'Username Taken',
          message:
              'The username "${_usernameController.text}" is already taken. Please choose another one.',
        );
      }
      return;
    }

    // Show loading dialog
    if (mounted) {
      DialogService.showLoadingDialog(
        context,
        message: 'Creating your account...',
      );
    }

    try {
      Map<String, dynamic>? user = await _authService.registerWithEmailPassword(
        _emailController.text.trim(),
        _passwordController.text,
        null, // displayName can be added later if needed
        _usernameController.text.trim(),
      );

      // Hide loading dialog
      if (mounted) {
        DialogService.hideLoadingDialog(context);
      }

      if (user != null && mounted) {
        // Show success dialog
        DialogService.showSuccessDialog(
          context,
          title: 'Account Created!',
          message:
              'Your account has been created successfully. Please login to continue.',
          buttonText: 'Go to Login',
          onButtonPressed: () {
            Navigator.of(context).pop(); // Close dialog first
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
        );
      }
    } catch (e) {
      // Hide loading dialog
      if (mounted) {
        DialogService.hideLoadingDialog(context);
      }

      // Show error dialog with specific error messages
      String errorMessage = 'An error occurred during registration.';

      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'weak-password':
            errorMessage =
                'The password is too weak. Please choose a stronger password.';
            break;
          case 'email-already-in-use':
            errorMessage =
                'This email is already registered. Please use a different email or try logging in.';
            break;
          case 'invalid-email':
            errorMessage =
                'The email address is not valid. Please check and try again.';
            break;
          case 'operation-not-allowed':
            errorMessage =
                'Email/Password registration is not enabled. Please contact support.';
            break;
          default:
            errorMessage =
                e.message ?? 'An error occurred during registration.';
        }
      } else {
        errorMessage = e.toString();
      }

      if (mounted) {
        DialogService.showErrorDialog(
          context,
          title: 'Registration Failed',
          message: errorMessage,
        );
      }
    }
  }

  Future<void> _signUpWithGoogle() async {
    // Show loading dialog
    if (mounted) {
      DialogService.showLoadingDialog(
        context,
        message: 'Signing up with Google...',
      );
    }

    try {
      Map<String, dynamic>? user = await _authService.signUpWithGoogle();

      // Hide loading dialog
      if (mounted) {
        DialogService.hideLoadingDialog(context);
      }

      if (user != null && mounted) {
        // Show success dialog
        DialogService.showSuccessDialog(
          context,
          title: 'Account Created!',
          message:
              'Your Google account has been linked successfully. Please login to continue.',
          buttonText: 'Go to Login',
          onButtonPressed: () {
            Navigator.of(context).pop(); // Close dialog first
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
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
          title: 'Google Sign-Up Failed',
          message:
              'Failed to sign up with Google. Please try again or use email registration.',
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
                  'Create Account',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 30),
                // Email Field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    prefixIcon: const Icon(Icons.email),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(
                      r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                    ).hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Username Field
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'Username',
                    prefixIcon: const Icon(Icons.person),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: _isCheckingUsername
                        ? const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : null,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    if (value.length < 3) {
                      return 'Username must be at least 3 characters';
                    }
                    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value)) {
                      return 'Username can only contain letters, numbers, and underscores';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
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
                const SizedBox(height: 16),
                // Confirm Password Field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey.shade600,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                // Sign Up Button
                ElevatedButton(
                  onPressed: _signUpWithEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade800,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Sign Up', style: TextStyle(fontSize: 16)),
                ),
                const SizedBox(height: 20),
                // Google Sign-Up Button
                OutlinedButton.icon(
                  onPressed: _signUpWithGoogle,
                  icon: const Icon(Icons.g_mobiledata),
                  label: const Text('Sign up with Google'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Login Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already have an account? '),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Login',
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
