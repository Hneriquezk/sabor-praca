import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppDrawer extends StatelessWidget {
  final String nome;
  const AppDrawer({super.key, required this.nome});

  Future<void> _sair(BuildContext context) async {
    await Supabase.instance.client.auth.signOut();
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
              bottom: 30,
            ),
            decoration: const BoxDecoration(
              color: Color(0xFFD2451E),
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(50)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.cancel_outlined,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Bem-vinda,\n$nome',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.white,
                      child: Icon(
                        Icons.person,
                        size: 40,
                        color: Color(0xFFD2451E),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.person, color: Color(0xFFD2451E)),
            title: const Text(
              'Editar perfil',
              style: TextStyle(
                color: Color(0xFFD2451E),
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.bookmark, color: Color(0xFFD2451E)),
            title: const Text(
              'Minhas reservas',
              style: TextStyle(
                color: Color(0xFFD2451E),
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFFD2451E)),
            title: const Text(
              'Sair da conta',
              style: TextStyle(
                color: Color(0xFFD2451E),
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () => _sair(context),
          ),
        ],
      ),
    );
  }
}
