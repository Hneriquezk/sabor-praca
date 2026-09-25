import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'cadastro_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _carregando = false;
  bool _senhaVisivel = false;

  Future<void> _login() async {
    setState(() => _carregando = true);
    try {
      await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text.trim(),
        password: _senhaController.text,
      );
      if (mounted) Navigator.pop(context, true);
    } on AuthException catch (e) {
      _mostrarErro('Erro ao entrar: ${e.message}');
    } catch (e) {
      _mostrarErro('Erro inesperado: $e');
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void _mostrarErro(String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8B2E0F),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ===== TOPO LARANJA COM LOGO =====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 20,
                  horizontal: 20,
                ),
                color: const Color(0xFF8B2E0F),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Botão voltar
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Row(
                            children: [
                              Icon(Icons.arrow_back, color: Color(0xFFF5A623)),
                              SizedBox(width: 5),
                              Text(
                                'Voltar',
                                style: TextStyle(color: Color(0xFFF5A623)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 15),
                        const Center(
                          child: Text(
                            'Seja bem-vindo ao restaurante',
                            style: TextStyle(
                              color: Color(0xFFF5A623),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // 👇 LOGO
                        Center(
                          child: Image.asset('assets/logo.png', width: 200),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                    // 👇 BONEQUINHO DO CHEF no canto inferior direito
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Image.asset('assets/img_boneco.png', width: 70),
                    ),
                  ],
                ),
              ),

              // ===== CARD CREME COM FORMULÁRIO =====
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(30),
                decoration: const BoxDecoration(
                  color: Color(0xFFF5E6C8),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Entre na sua conta',
                        style: TextStyle(
                          color: Color(0xFFD2451E),
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Email:',
                      style: TextStyle(
                        color: Color(0xFFD2451E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: 'exemplo@gmail.com',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Senha:',
                      style: TextStyle(
                        color: Color(0xFFD2451E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _senhaController,
                      obscureText: !_senhaVisivel,
                      decoration: InputDecoration(
                        hintText: '********',
                        filled: true,
                        fillColor: Colors.white,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _senhaVisivel
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () =>
                              setState(() => _senhaVisivel = !_senhaVisivel),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Esqueci minha senha',
                          style: TextStyle(
                            color: Color(0xFFD2451E),
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _carregando ? null : _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFD2451E),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: _carregando
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'Entrar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Center(
                      child: Text(
                        'Ou entre com',
                        style: TextStyle(color: Color(0xFFD2451E)),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _botaoSocial(Icons.g_mobiledata, Colors.white),
                        const SizedBox(width: 15),
                        _botaoSocial(Icons.facebook, Colors.blue),
                        const SizedBox(width: 15),
                        _botaoSocial(Icons.apple, Colors.black),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const CadastroScreen(),
                            ),
                          );
                        },
                        child: RichText(
                          text: const TextSpan(
                            text: 'Ainda não tem uma conta? ',
                            style: TextStyle(color: Colors.black87),
                            children: [
                              TextSpan(
                                text: 'Crie uma',
                                style: TextStyle(
                                  color: Color(0xFFD2451E),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _botaoSocial(IconData icon, Color color) {
    return Container(
      width: 60,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFD2451E)),
      ),
      child: Icon(icon, color: color, size: 30),
    );
  }
}
