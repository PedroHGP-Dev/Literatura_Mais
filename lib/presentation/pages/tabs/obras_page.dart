import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../../../core/services/book_cover_service.dart';

class Obra {
  final String titulo;
  final String autor;
  final String seculo;
  final String movimento;

  const Obra({
    required this.titulo,
    required this.autor,
    required this.seculo,
    required this.movimento,
  });
}

class ObrasPage extends StatefulWidget {
  const ObrasPage({super.key});

  @override
  State<ObrasPage> createState() => _ObrasPageState();
}

class _ObrasPageState extends State<ObrasPage> {
  final List<Obra> _obras = const [
    Obra(
      titulo: 'Dom Casmurro',
      autor: 'Machado de Assis',
      seculo: 'SEC. XIX',
      movimento: 'Realismo',
    ),
    Obra(
      titulo: 'Memórias Póstumas de Brás Cubas',
      autor: 'Machado de Assis',
      seculo: 'SEC. XIX',
      movimento: 'Realismo',
    ),
    Obra(
      titulo: 'O Cortiço',
      autor: 'Aluísio Azevedo',
      seculo: 'SEC. XIX',
      movimento: 'Naturalismo',
    ),
    Obra(
      titulo: 'Vidas Secas',
      autor: 'Graciliano Ramos',
      seculo: 'SEC. XX',
      movimento: 'Modernismo',
    ),
    Obra(
      titulo: 'Macunaíma',
      autor: 'Mário de Andrade',
      seculo: 'SEC. XX',
      movimento: 'Modernismo',
    ),
    Obra(
      titulo: 'A Hora da Estrela',
      autor: 'Clarice Lispector',
      seculo: 'SEC. XX',
      movimento: 'Modernismo',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorScaffold,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Obras Literárias',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    '${_obras.length} OBRAS',
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: _obras.length,
                  itemBuilder: (context, index) {
                    final obra = _obras[index];
                    return _buildObraCard(obra);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildObraCard(Obra obra) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          FutureBuilder<String?>(
            future: BookCoverService.fetchCoverUrl(obra.titulo, obra.autor),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: 70,
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: AppColors.accent,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                );
              }

              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data!.isNotEmpty) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    snapshot.data!,
                    width: 70,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return _buildCoverPlaceholder();
                    },
                  ),
                );
              }

              return _buildCoverPlaceholder();
            },
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      obra.seculo,
                      style: const TextStyle(
                        color: AppColors.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white10,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        obra.movimento,
                        style: const TextStyle(
                          color: AppColors.purpleLight,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  obra.titulo,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  obra.autor,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 20),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'VER ANÁLISE',
                          style: TextStyle(
                            color: AppColors.accent,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right,
                          color: AppColors.accent,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoverPlaceholder() {
    return Container(
      width: 70,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white12),
      ),
      child: const Center(
        child: Icon(Icons.menu_book, color: AppColors.textSecondary, size: 28),
      ),
    );
  }
}
