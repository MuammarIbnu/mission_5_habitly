import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../routes.dart';
import '../theme/app_color.dart';
import '../theme/app_text.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  String gender = 'Female';

  final BorderRadius _radius = BorderRadius.circular(12);

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = FirebaseAuth.instance.currentUser;

      if (user != null && context.mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan, coba lagi')),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message = 'Register gagal';
      if (e.code == 'email-already-in-use') {
        message = 'Email sudah terdaftar';
      } else if (e.code == 'weak-password') {
        message = 'Password terlalu lemah';
      } else if (e.code == 'invalid-email') {
        message = 'Email tidak valid';
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColor.darkBackground : AppColor.lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 8),

              /// LOGO
              Image.asset(
                'assets/images/aebbbec190680b790fb1afab99e36740075f92f4.png',
                width: 200,
              ),

              const SizedBox(height: 12),

              /// FORM CARD
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColor.black,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          'Account Register',
                          style: AppText.title(context).copyWith(color: AppColor.white),
                        ),
                      ),

                      const SizedBox(height: 20),

                      _label(context, 'Full Name'),
                      InputField(controller: fullNameController),

                      _label(context, 'Email'),
                      InputField(controller: emailController),

                      _label(context, 'Gender'),
                      _genderDropdown(),

                      _label(context, 'Mobile'),
                      Row(
                        children: [
                          _CountryCode(radius: _radius),
                          const SizedBox(width: 8),
                          Expanded(child: InputField(controller: mobileController)),
                        ],
                      ),

                      _label(context, 'Password'),
                      InputField(controller: passwordController, obscure: true, isPassword: true),

                      _label(context, 'Confirm Password'),
                      InputField(
                        controller: confirmPasswordController,
                        obscure: true,
                        isPassword: true,
                        customValidator: (value) {
                          if (value != passwordController.text) return 'Password tidak sama';
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      /// REGISTER BUTTON
                      _PrimaryButton(
                        text: 'Register',
                        onPressed: _register,
                      ),

                      const SizedBox(height: 16),

                      /// LOGIN BUTTON
                      _PrimaryButton(
                        text: 'Login',
                        color: const Color(0xFFE2FCD9),
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.login);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 6),
      child: RichText(
        text: TextSpan(
          text: text,
          style: AppText.caption(context).copyWith(color: AppColor.white),
          children: const [
            TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }

  Widget _genderDropdown() {
    return DropdownButtonFormField<String>(
      value: gender,
      dropdownColor: AppColor.white,
      items: const [
        DropdownMenuItem(value: 'Female', child: Text('Female')),
        DropdownMenuItem(value: 'Male', child: Text('Male')),
      ],
      onChanged: (v) => setState(() => gender = v!),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColor.white,
        border: OutlineInputBorder(
          borderRadius: _radius,
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}

class InputField extends StatefulWidget {
  final bool obscure;
  final bool isPassword;
  final TextEditingController? controller;
  final String? Function(String?)? customValidator;

  const InputField({super.key, this.obscure = false, this.isPassword = false, this.controller, this.customValidator});

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      validator: widget.customValidator ?? (v) => v == null || v.isEmpty ? 'Required' : null,
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColor.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
          onPressed: () => setState(() => _obscureText = !_obscureText),
        )
            : null,
      ),
    );
  }
}

class _CountryCode extends StatelessWidget {
  final BorderRadius radius;

  const _CountryCode({required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      decoration: BoxDecoration(color: AppColor.white, borderRadius: radius),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('🇮🇩', style: TextStyle(fontSize: 16)),
          SizedBox(width: 4),
          Text('+62', style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;

  const _PrimaryButton({required this.text, required this.onPressed, this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColor.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(text, style: AppText.body(context).copyWith(color: AppColor.white)),
      ),
    );
  }
}