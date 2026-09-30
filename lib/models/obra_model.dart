class Obra {
  final String titulo;
  final String autor;
  final String seculo;
  final String movimento;
  final String resumo;

  const Obra({
    required this.titulo,
    required this.autor,
    required this.seculo,
    required this.movimento,
    required this.resumo,
  });

  factory Obra.fromJson(Map<String, dynamic> json) {
    return Obra(
      titulo: json['titulo'] ?? '',
      autor: json['autor'] ?? '',
      seculo: json['seculo'] ?? '',
      movimento: json['movimento'] ?? '',
      resumo: json['resumo'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'titulo': titulo,
      'autor': autor,
      'seculo': seculo,
      'movimento': movimento,
      'resumo': resumo,
    };
  }
}
