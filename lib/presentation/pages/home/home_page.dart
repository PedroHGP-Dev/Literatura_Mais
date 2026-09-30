import 'package:flutter/material.dart';
import '../../../core/theme/colors.dart';
import '../perfil/perfil_page.dart';
import '../tabs/inicio_page.dart';
import '../tabs/obras_page.dart';
import '../tabs/estatisticas_page.dart';
import '../tabs/questoes_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _telas = const [
    InicioPage(),
    ObrasPage(),
    EstatisticasPage(),
    QuestoesPage(),
  ];

  void _abrirPerfil() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const PerfilPage()))
        .then((_) {
          setState(() {});
        });
  }

  @override
  Widget build(BuildContext context) {
    final primeiroNome = PerfilPage.nome.trim().split(' ').first;

    return Scaffold(
      backgroundColor: AppColors.colorScaffold,
      appBar: AppBar(
        backgroundColor: AppColors.colorAppBar,
        elevation: 0,
        title: Text(
          'Vamos estudar, $primeiroNome?',
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: Colors.white24, height: 1.0),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: _abrirPerfil,
              child: Container(
                padding: const EdgeInsets.all(1.5),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.avatarBorder, width: 1.0),
                ),
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: PerfilPage.imagemBytes != null
                      ? MemoryImage(PerfilPage.imagemBytes!) as ImageProvider
                      : const AssetImage('assets/images/rodolfo.png'),
                ),
              ),
            ),
          ),
        ],
      ),
      drawer: _buildMenuDrawer(context),
      body: _telas[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.primary,
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        iconSize: 28,
        selectedFontSize: 12,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Obras'),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Estatísticas',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.quiz), label: 'Questões'),
        ],
      ),
    );
  }

  Widget _buildMenuDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.primary,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.menu, color: AppColors.textPrimary),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(
                    child: Text(
                      'Menu',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            const Divider(color: Colors.white12, height: 1),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildMenuItem(
                    'Meu Perfil',
                    onTap: () {
                      Navigator.of(context).pop();
                      _abrirPerfil();
                    },
                  ),
                  _buildMenuItem('Notificações', onTap: () {}),
                  _buildMenuItem('Obras Salvas', onTap: () {}),
                  _buildMenuItem('Configurações', onTap: () {}),
                  _buildMenuItem('Ajuda & Suporte', onTap: () {}),
                  _buildMenuItem('Sair da Conta', onTap: () {}),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white, width: 3.0),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: Image.asset(
                    'assets/images/icon.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, {required VoidCallback onTap}) {
    return Column(
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(vertical: 6.0),
          title: Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20,
              fontStyle: FontStyle.italic,
            ),
          ),
          onTap: onTap,
        ),
        const Divider(color: Colors.white12, height: 1),
      ],
    );
  }
}
