import 'package:active_read/auth/login.dart';
import 'package:active_read/pages/homepage.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context,snapshot){
        if(snapshot.connectionState==ConnectionState.waiting){
          return const Scaffold(body:Center(child:CircularProgressIndicator()));
        }
        final session =Supabase.instance.client.auth.currentSession;
        if(session!=null){
          return const HomePage();
        }
        else{
          return const LoginPage();
        }
      });
  }
}