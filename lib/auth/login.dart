import 'package:active_read/widgets/textformfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController ncontroller = TextEditingController();
  final TextEditingController econtroller = TextEditingController();
  final TextEditingController pcontroller = TextEditingController();
  final TextEditingController ccontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool isLogin = true;
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    ncontroller.dispose();
    econtroller.dispose();
    pcontroller.dispose();
    ccontroller.dispose();
    super.dispose();
  }

  Future<void> login() async {
    final email = econtroller.text.trim();
    final password = pcontroller.text.trim();

    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      econtroller.clear();
      pcontroller.clear();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Welcome back! 🎉", style: GoogleFonts.poppins()),
            backgroundColor: Colors.purple.shade600,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    } on AuthException catch (e) {
      if (!mounted) return;

      String message = e.message;
      if (e.message.contains("Invalid login credentials")) {
        message = "Incorrect email or password. Please try again.";
      } else if (e.message.contains("Email not confirmed")) {
        message = "Please check your email to confirm your account.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red.shade600,
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Something went wrong"),
          backgroundColor: Colors.red.shade600,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> signup() async {
    final name = ncontroller.text.trim();
    final email = econtroller.text.trim();
    final password = pcontroller.text.trim();
    

    setState(() => _isLoading = true);

    try {
      await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
        data: {"name": name},
      );

      ncontroller.clear();
      econtroller.clear();
      pcontroller.clear();
      ccontroller.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Check your email to confirm your account! 📧",
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.purple.shade600,
          duration: const Duration(seconds: 5),
        ),
      );
    } on AuthException catch (e) {
      if (!mounted) return;

      String message = e.message;
      if (e.message.contains("User already registered")) {
        message = "Email already exists. Try logging in.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red.shade600,
          duration: const Duration(seconds: 5),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Signup failed"),
          backgroundColor: Colors.red.shade600,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade100,
              Colors.pink.shade100,
              Colors.purple.shade100,
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "ActiveRead",
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Read • Save Words • Learn Beautifully 💝",
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: Colors.purple.shade700,
                    ),
                  ),
                  const SizedBox(height: 40),

                  Container(
                    constraints: const BoxConstraints(maxWidth: 420),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 237, 231, 229),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade200,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () => setState(() => isLogin = true),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isLogin
                                            ? const Color.fromARGB(255, 237, 231, 229)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Text(
                                        "Login",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: isLogin
                                              ? Colors.purple.shade900
                                              : Colors.purple.shade600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () =>setState(() => isLogin = false),
                                    child: AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 300,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      decoration: BoxDecoration(
                                        color: !isLogin
                                            ? const Color.fromARGB(255, 237, 231, 229)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      child: Text(
                                        "Register",
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: !isLogin
                                              ? Colors.purple.shade900
                                              : Colors.purple.shade600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),

                          if (!isLogin)
                            Column(
                              children: [
                                TextformField(
                                  controller: ncontroller,
                                  obscure: false,
                                  keyboardType: TextInputType.name,
                                  label: "Full Name",
                                  hint: "Sadia Lima",
                                  icon: Icons.person_outline,
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty)
                                      return "Name required";
                                    if (v.trim().length < 2)
                                      return "Name too short";
                                    if (!RegExp(
                                      r'^[a-zA-Z\s.]+$',
                                    ).hasMatch(v.trim()))
                                      return "Only letters allowed";
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),

                          TextformField(
                            controller: econtroller,
                            obscure: false,
                            keyboardType: TextInputType.emailAddress,
                            label: "Email",
                            hint: "you@example.com",
                            icon: Icons.email_outlined,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty)
                                return "Email required";
                              if (!RegExp(
                                r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                              ).hasMatch(v.trim()))
                                return "Invalid email";
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),

                          TextformField(
                            controller: pcontroller,
                            obscure: !_showPassword,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _showPassword
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                              onPressed: () => setState(() => _showPassword = !_showPassword,),
                            ),
                            keyboardType: TextInputType.text,
                            label: "Password",
                            hint: "••••••••",
                            icon: Icons.lock_outline,
                            validator: (v) {
                              if (v == null || v.isEmpty)
                                return "Password required";
                              if (!isLogin && v.length < 8)
                                return "Password must be 8+ characters";
                              return null;
                            },
                          ),

                          if (!isLogin)
                            Column(
                              children: [
                                const SizedBox(height: 16),
                                TextformField(
                                  controller: ccontroller,
                                  obscure: !_showConfirmPassword,
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _showConfirmPassword
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () => setState(
                                      () => _showConfirmPassword =!_showConfirmPassword,
                                    ),
                                  ),
                                  keyboardType: TextInputType.text,
                                  label: "Confirm Password",
                                  hint: "••••••••",
                                  icon: Icons.lock_reset_outlined,
                                  validator: (v) {
                                    if (v == null || v.isEmpty)
                                      return "Confirm password";
                                    if (v != pcontroller.text)
                                      return "Passwords do not match";
                                    return null;
                                  },
                                ),
                              ],
                            ),

                          const SizedBox(height: 30),

                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _isLoading? null: () {
                                      if (_formKey.currentState!.validate()) {
                                        isLogin ? login() : signup();
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple.shade600,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 8,
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : Text(
                                      isLogin ? "Login" : "Create Account",
                                      style: GoogleFonts.playfairDisplay(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
