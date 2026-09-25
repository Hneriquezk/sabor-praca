import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/app_drawer.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _nomeUsuario;

  @override
  void initState() {
    super.initState();
    _carregarUsuario();
    Supabase.instance.client.auth.onAuthStateChange.listen((_) {
      _carregarUsuario();
    });
  }

  Future<void> _carregarUsuario() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (mounted) setState(() => _nomeUsuario = null);
      return;
    }
    try {
      final data = await Supabase.instance.client
          .from('usuarios')
          .select('nome')
          .eq('id', user.id)
          .maybeSingle();
      if (mounted) setState(() => _nomeUsuario = data?['nome'] ?? 'Cliente');
    } catch (_) {
      if (mounted) setState(() => _nomeUsuario = 'Cliente');
    }
  }

  Future<void> _abrirLogin() async {
    final logado = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
    if (logado == true) _carregarUsuario();
  }

  @override
  Widget build(BuildContext context) {
    final logado = _nomeUsuario != null;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5E6C8),
      drawer: logado ? AppDrawer(nome: _nomeUsuario!) : null,
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B2E0F),
        elevation: 0,
        title: logado
            ? null
            : const Text(
                'Sabor & Praça',
                style: TextStyle(color: Color(0xFFF5A623)),
              ),
        actions: [
          if (!logado)
            TextButton.icon(
              onPressed: _abrirLogin,
              icon: const Icon(Icons.login, color: Color(0xFFF5A623)),
              label: const Text(
                'Entrar',
                style: TextStyle(color: Color(0xFFF5A623)),
              ),
            )
          else
            IconButton(
              icon: const Icon(Icons.menu, color: Color(0xFFF5A623)),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ===== TOPO: LOGO + 3 PRATOS + BONECO =====
            Stack(
              children: [
                Container(
                  color: const Color(0xFFF5E6C8),
                  padding: const EdgeInsets.only(top: 20, bottom: 30),
                  width: double.infinity,
                  child: Column(
                    children: [
                      // Logo
                      Image.asset('assets/logo.png', width: 220),
                      const SizedBox(height: 15),
                      // 3 pratos do topo
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _pratoTopo('assets/img_topo_1.png'),
                          _pratoTopo('assets/img_topo_2.png'),
                          _pratoTopo('assets/img_topo_3.png'),
                        ],
                      ),
                    ],
                  ),
                ),
                // Bonequinho do chef no canto
                Positioned(
                  right: 10,
                  bottom: 0,
                  child: Image.asset('assets/img_boneco.png', width: 90),
                ),
              ],
            ),

            // ===== MAIS PEDIDOS =====
            Container(
              width: double.infinity,
              color: const Color(0xFF6B1F0A),
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Column(
                children: [
                  const Text(
                    'Mais pedidos',
                    style: TextStyle(
                      color: Color(0xFFF5E6C8),
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 240,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      children: [
                        _CardMaisPedido(
                          imagem: 'assets/img_gioza.png',
                          titulo: 'Guioza',
                          descricao:
                              'Temos as versões suína e vegana. Qual vai ser a sua?',
                          nota: '5.0',
                          cor: const Color(0xFFD2451E),
                        ),
                        const SizedBox(width: 15),
                        _CardMaisPedido(
                          imagem: 'assets/img_avocado.png',
                          titulo: 'Avocado Toast',
                          descricao:
                              'Avocado Toast do seu jeito! Escolha a versão que mais combina com você.',
                          nota: '5.0',
                          cor: const Color(0xFFE0A800),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ===== CARDÁPIO =====
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25),
              child: Column(
                children: [
                  const Text(
                    'Cardápio',
                    style: TextStyle(
                      color: Color(0xFFD2451E),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      children: [
                        _filtro('Principais', true),
                        _filtro('Entradas', false),
                        _filtro('Bebidas', false),
                        _filtro('Sobremesas', false),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      childAspectRatio: 0.78,
                      children: const [
                        _CardPrato(
                          nome: 'Bowl de Frango',
                          imagem: 'assets/img_bowl_frango.png',
                        ),
                        _CardPrato(
                          nome: 'Massa Rústica',
                          imagem: 'assets/img_massa_rustica.png',
                        ),
                        _CardPrato(
                          nome: 'Frango Grelhado',
                          imagem: 'assets/img_frango_grelhado.png',
                        ),
                        _CardPrato(
                          nome: 'Arroz Carreteiro',
                          imagem: 'assets/img_arroz_carreteiro.png',
                        ),
                        _CardPrato(
                          nome: 'Sopa Dourada',
                          imagem: 'assets/img_sopa_dourada.png',
                        ),
                        _CardPrato(
                          nome: 'Tofu com Curry',
                          imagem: 'assets/img_tofu_curry.png',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _pratoTopo(String imagem) {
    return Container(
      width: 110,
      height: 110,
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
      child: ClipOval(child: Image.asset(imagem, fit: BoxFit.cover)),
    );
  }

  Widget _filtro(String texto, bool ativo) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: ativo ? const Color(0xFFD2451E) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD2451E)),
      ),
      child: Text(
        texto,
        style: TextStyle(
          color: ativo ? Colors.white : const Color(0xFFD2451E),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

// ===== WIDGET: Card "Mais pedidos" =====
class _CardMaisPedido extends StatelessWidget {
  final String imagem;
  final String titulo;
  final String descricao;
  final String nota;
  final Color cor;

  const _CardMaisPedido({
    required this.imagem,
    required this.titulo,
    required this.descricao,
    required this.nota,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      decoration: BoxDecoration(
        color: cor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF5E6C8),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(imagem, fit: BoxFit.cover),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Entrada',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 11,
            ),
          ),
          Text(
            titulo,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              descricao,
              style: const TextStyle(color: Colors.white, fontSize: 11),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              Text(
                nota,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ===== WIDGET: Card do cardápio =====
class _CardPrato extends StatelessWidget {
  final String nome;
  final String imagem;

  const _CardPrato({required this.nome, required this.imagem});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD2451E),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  nome,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Ver mais',
                  style: TextStyle(color: Colors.white, fontSize: 9),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                imagem,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
