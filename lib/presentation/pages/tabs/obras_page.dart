import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import '../../../core/theme/colors.dart';
import '../../../core/services/book_cover_service.dart';

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
}

class ObrasPage extends StatefulWidget {
  const ObrasPage({super.key});

  @override
  State<ObrasPage> createState() => _ObrasPageState();
}

class _ObrasPageState extends State<ObrasPage> {
  List<Obra> _todasObras = [];
  String _movimentoSelecionado = 'Todos';
  bool _isLoading = true;

  final List<String> _movimentosFiltro = const [
    'Todos',
    'Quinhentismo',
    'Humanismo',
    'Barroco',
    'Arcadismo',
    'Romantismo',
    'Naturalismo',
    'Realismo',
    'Pré-Modernismo',
    'Modernismo',
  ];

  @override
  void initState() {
    super.initState();
    _carregarObras();
  }

  Future<void> _carregarObras() async {
    try {
      final String response = await rootBundle.loadString(
        'assets/data/obras.json',
      );
      final List<dynamic> data = json.decode(response);
      setState(() {
        _todasObras = data.map((item) => Obra.fromJson(item)).toList();
        _isLoading = false;
      });
    } catch (_) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Obra> get _obrasFiltradas {
    if (_movimentoSelecionado == 'Todos') {
      return _todasObras;
    }
    return _todasObras
        .where(
          (o) =>
              o.movimento.toLowerCase().trim() ==
              _movimentoSelecionado.toLowerCase().trim(),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final obrasExibidas = _obrasFiltradas;

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
                    '${obrasExibidas.length} OBRAS',
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _movimentosFiltro.map((movimento) {
                  final bool isSelected = _movimentoSelecionado == movimento;
                  return ChoiceChip(
                    label: Text(
                      movimento,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    selectedColor: AppColors.accent,
                    backgroundColor: AppColors.secondary,
                    showCheckmark: false,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    side: BorderSide(
                      color: isSelected ? AppColors.accent : Colors.white12,
                    ),
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _movimentoSelecionado = movimento;
                        });
                      }
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.accent,
                        ),
                      )
                    : obrasExibidas.isEmpty
                    ? const Center(
                        child: Text(
                          'Nenhuma obra encontrada para este movimento.',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      )
                    : RefreshIndicator(
                        color: AppColors.accent,
                        backgroundColor: AppColors.secondary,
                        onRefresh: _carregarObras,
                        child: ListView.builder(
                          itemCount: obrasExibidas.length,
                          itemBuilder: (context, index) {
                            return _buildObraCard(obrasExibidas[index]);
                          },
                        ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<String?>(
            future: BookCoverService.fetchCoverUrl(obra.titulo, obra.autor),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  width: 70,
                  height: 105,
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
                    height: 105,
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
          const SizedBox(width: 14),
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
                const SizedBox(height: 4),
                Text(
                  obra.titulo,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  obra.autor,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  obra.resumo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textSecondary.withOpacity(0.8),
                    fontSize: 11.5,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),
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
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 2),
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
      height: 105,
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
