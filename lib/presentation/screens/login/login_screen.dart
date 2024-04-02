import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_player/di/providers.dart';
import 'package:music_player/domain/entity/user_data.dart';
import 'package:music_player/presentation/config/assets.dart';
import 'package:music_player/presentation/config/palette.dart';
import 'package:music_player/presentation/helper/view_utils.dart';

class LoginScreen extends ConsumerStatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;
  bool _isErrorShown = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(loginControllerProvider);
    if (state.error != null && !_isErrorShown) {
      showToast(state.error!);
      _isLoading = false;
      _isErrorShown = true;
    } else if (state.data != null) {
      UserData data = state.data!;
      showToast(data.id);
    } else if (state.loading) {
      setState(() {
        _isLoading = true;
        _isErrorShown = false;
      });
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.bgArtist),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withOpacity(0.3),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.music_note,
                size: 100, // Adjust the size of the music icon as needed
                color: Palette.primaryLight,
              ).animate().shimmer(duration: const Duration(seconds: 2)).flipH(),
              const SizedBox(height: 20.0),
              _buildLoginCard(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoginCard() {
    return Center(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10),
        color: Palette.backgroundDark.withOpacity(0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 10,
        shadowColor: Colors.black.withOpacity(0.2),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Palette.secondaryLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    filled: true,
                    fillColor: Palette.secondaryLight,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off),
                      color: Palette.primaryLight,
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            _isLoading ? null : () => _handleLogin(),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text('Login/Signup'),
                      ),
                    ),
                    if (_isLoading)
                      const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Palette.secondaryLight),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ).animate().flipV(),
    );
  }

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || !email.contains('@') || password.length < 6) {
      showToast(
          'Please enter a valid email and password (at least 6 characters)');
      return;
    } else {
      ref.read(loginControllerProvider.notifier).loginOrSignup(email, password);
    }
  }
}
