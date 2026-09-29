import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';

class InicioPage extends StatelessWidget {
  const InicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        const Text(
          'Linha do Tempo',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'MOVIMENTOS COMPLETADOS',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.purpleLight,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              '5 / 10',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: const LinearProgressIndicator(
            value: 0.5,
            minHeight: 6,
            backgroundColor: AppColors.secondary,
            color: AppColors.accent,
          ),
        ),
        const SizedBox(height: 20),
        _buildCardMovimento(
          seculo: 'SÉCULO XVI',
          titulo: 'Quinhentismo',
          subtitulo: 'A literatura de informação',
          progressoText: '50%',
          progressoVal: 0.5,
          concluido: false,
        ),
        _buildCardMovimento(
          seculo: 'SÉCULO XVII',
          titulo: 'Barroco',
          subtitulo: 'A arte dos contrastes',
          progressoText: 'COMPLETO',
          progressoVal: 1.0,
          concluido: true,
        ),
        _buildCardMovimento(
          seculo: 'SÉCULO XVIII',
          titulo: 'Arcadismo',
          subtitulo: 'Iluminismo no Brasil',
          progressoText: '0%',
          progressoVal: 0.0,
          concluido: false,
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.purpleLight),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
          ),
          onPressed: () {},
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ver Todos os Movimentos',
                style: TextStyle(color: AppColors.textPrimary, fontSize: 14),
              ),
              SizedBox(width: 6),
              Icon(Icons.keyboard_arrow_down, color: AppColors.textPrimary),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.secondary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white12),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Dica do dia para o ENEM:',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Foco em Machado de Assis: O autor mais cobrado usa a ironia e a conversa direta com o leitor (metalinguagem) para expor as contradições humanas no realismo.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  height: 1.35,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardMovimento({
    required String seculo,
    required String titulo,
    required String subtitulo,
    required String progressoText,
    required double progressoVal,
    required bool concluido,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.secondary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                seculo,
                style: const TextStyle(
                  color: AppColors.purpleLight,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white24,
                child: Icon(
                  concluido ? Icons.check : Icons.arrow_forward,
                  size: 18,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          Text(
            titulo,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontStyle: FontStyle.italic,
            ),
          ),
          Text(
            subtitulo,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 14),
          if (concluido) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: const LinearProgressIndicator(
                value: 1.0,
                minHeight: 6,
                backgroundColor: AppColors.primary,
                color: AppColors.accent,
              ),
            ),
            const SizedBox(height: 6),
            const Center(
              child: Text(
                'COMPLETO',
                style: TextStyle(
                  color: AppColors.purpleLight,
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ] else ...[
            Row(
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progressoVal,
                      minHeight: 6,
                      backgroundColor: AppColors.primary,
                      color: AppColors.accent,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  progressoText,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
