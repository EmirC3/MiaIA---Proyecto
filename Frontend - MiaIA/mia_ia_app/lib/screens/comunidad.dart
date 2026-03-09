import 'package:flutter/material.dart';

class ComunidadScreen extends StatelessWidget {
  const ComunidadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // --- CONFIGURACIÓN DE COLORES ---
    final Color backgroundColor = const Color(0xFFF0F7FF); 
    final Color darkBlueText = const Color(0xFF1E4E8C); 
    final Color softBlueCards = const Color(0xFF5B9EE1).withOpacity(0.6); 

    final List<Map<String, dynamic>> categorias = [
      {'titulo': 'Historias de superación', 'posts': '25 post', 'icon': Icons.auto_graph_rounded},
      {'titulo': 'Consejos que ayudaron', 'posts': '37 post', 'icon': Icons.tips_and_updates_rounded},
      {'titulo': 'Palabras que abrazan', 'posts': '215 post', 'icon': Icons.volunteer_activism_rounded},
      {'titulo': 'Lecciones aprendidas', 'posts': '85 post', 'icon': Icons.menu_book_rounded},
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 30), 
            
            // --- TÍTULO Y FRASE ---
            Text(
              'Comunidad Mia',
              style: TextStyle(
                fontSize: 22, 
                fontWeight: FontWeight.w800, 
                color: darkBlueText,
                letterSpacing: -0.5,
              ),
            ),
            Text(
              'Espacio seguro, crecemos juntos',
              style: TextStyle(
                fontSize: 15, 
                color: darkBlueText.withOpacity(0.5),
                fontWeight: FontWeight.w500,
              ),
            ),

         
            // --- CONTENEDOR DE IMAGEN AJUSTABLE (ANCHO 200) ---
            Expanded(
              flex: 3, 
              child: Center( 
                child: SizedBox(
                  width: 1000, // <--- Ajustado a 200 como pediste
                  child: Image.asset(
                    'assets/fondo2.jpg', 
                    fit: BoxFit.contain, 
                  ),
                ),
              ),
            ),

            // --- CUADRÍCULA (MANTIENE SU POSICIÓN) ---
            Expanded(
              flex: 4, 
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 5, 24, 10), 
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: categorias.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    childAspectRatio: 1.1, 
                  ),
                  itemBuilder: (context, index) {
                    final cat = categorias[index];
                    return _buildCategoryCard(
                      context: context,
                      titulo: cat['titulo'],
                      posts: cat['posts'],
                      icon: cat['icon'],
                      cardColor: softBlueCards, 
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required String titulo,
    required String posts,
    required IconData icon,
    required Color cardColor,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailScreen(categoryName: titulo),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              cardColor,
              cardColor.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: cardColor.withOpacity(0.15), 
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                titulo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  height: 1.1,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                posts,
                style: const TextStyle(
                  color: Colors.white, 
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryDetailScreen extends StatelessWidget {
  final String categoryName;
  const CategoryDetailScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: const Color(0xFF5B9EE1),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(child: Text('Contenido de $categoryName')),
    );
  }
}