import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _telefoneController = TextEditingController();
  bool _carregando = false;

  Future<void> _cadastrar() async {
    if (_nomeController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _senhaController.text.isEmpty) {
      _mostrarErro('Preencha todos os campos obrigatórios.');
      return;
    }

    setState(() => _carregando = true);
    try {
      final client = Supabase.instance.client;

      // 1) Cria o usuário no Auth
      final response = await client.auth.signUp(
        email: _emailController.text.trim(),
        password: _senhaController.text,
        data: {'nome': _nomeController.text.trim()},
      );

      final user = response.user;
      if (user == null) throw Exception('Falha ao criar usuário.');

      // 2) Insere na tabela `usuarios`
      await client.from('usuarios').insert({
        'id': user.id,
        'nome': _nomeController.text.trim(),
        'email': _emailController.text.trim(),
        'telefone': _telefoneController.text.trim(),
        'role': 'cliente',
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cadastro realizado! Faça login.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } on AuthException catch (e) {
      _mostrarErro('Erro no cadastro: ${e.message}');
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
                        const SizedBox(height: 10),
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
                          child: Image.asset('assets/logo.png', width: 180),
                        ),
                        const SizedBox(height: 15),
                      ],
                    ),
                    // 👇 BONEQUINHO DO CHEF no canto inferior direito
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Image.asset('assets/img_boneco.png', width: 60),
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
                        'Crie sua conta',
                        style: TextStyle(
                          color: Color(0xFFD2451E),
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    _label('Nome:'),
                    _input(_nomeController, 'Digite seu nome completo'),
                    const SizedBox(height: 15),
                    _label('Email:'),
                    _input(
                      _emailController,
                      'exemplo@gmail.com',
                      keyboard: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),
                    _label('Crie uma senha:'),
                    _input(_senhaController, '********', obscure: true),
                    const SizedBox(height: 15),
                    _label('Telefone:'),
                    _input(
                      _telefoneController,
                      '(xx) xxxxx-xxxx',
                      keyboard: TextInputType.phone,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _carregando ? null : _cadastrar,
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
                                'Cadastrar',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
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

  Widget _label(String texto) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(
      texto,
      style: const TextStyle(
        color: Color(0xFFD2451E),
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget _input(
    TextEditingController controller,
    String hint, {
    bool obscure = false,
    TextInputType keyboard = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
