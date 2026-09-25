class Usuario {
  final String id;
  final String nome;
  final String email;
  final String? telefone;
  final String? avatarUrl;
  final String role;

  Usuario({
    required this.id,
    required this.nome,
    required this.email,
    this.telefone,
    this.avatarUrl,
    required this.role,
  });

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      telefone: map['telefone'],
      avatarUrl: map['avatar_url'],
      role: map['role'] ?? 'cliente',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'avatar_url': avatarUrl,
      'role': role,
    };
  }
}
