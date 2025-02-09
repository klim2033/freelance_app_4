import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/add_product_dialog.dart';
import '../widgets/base_screen.dart';

class FridgeScreen extends StatefulWidget {
  const FridgeScreen({super.key});

  @override
  State<FridgeScreen> createState() => _FridgeScreenState();
}

class _FridgeScreenState extends State<FridgeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  String _selectedCategory = 'Все';
  final TextEditingController _searchController = TextEditingController();

  final List<String> categories = [
    'Все',
    'Молочные',
    'Мясо',
    'Овощи',
    'Фрукты',
    'Напитки',
    'Другое',
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _showAddProductDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddProductDialog(
        onAdd: (product) {
          context.read<ProductService>().addProduct(product);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Холодильник',
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryList(),
          Expanded(
            child: Consumer<ProductService>(
              builder: (context, productService, child) {
                final products = productService.getFilteredProducts(
                  _selectedCategory,
                  _searchController.text,
                );

                if (products.isEmpty) {
                  return Center(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text('Холодильник пуст'),
                    ),
                  );
                }

                return SlideTransition(
                  position: _slideAnimation,
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return _buildProductCard(products[index]);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddProductDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Поиск продуктов...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Theme.of(context).cardColor,
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildCategoryList() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = category == _selectedCategory;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
              },
              backgroundColor:
                  isSelected ? Theme.of(context).colorScheme.primary : null,
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : null,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductCard(Product product) {
    final daysUntilExpiration =
        product.expirationDate.difference(DateTime.now()).inDays;
    final isExpiringSoon = daysUntilExpiration <= 3 && daysUntilExpiration >= 0;
    final isExpired = daysUntilExpiration < 0;

    return Dismissible(
      key: ValueKey(product.id),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        context.read<ProductService>().deleteProduct(product.id);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: isExpired
                ? Colors.red
                : isExpiringSoon
                    ? Colors.orange
                    : Colors.green,
            child: Icon(
              _getCategoryIcon(product.category),
              color: Colors.white,
            ),
          ),
          title: Text(product.name),
          subtitle: Text(
            'До: ${product.expirationDate.day}.${product.expirationDate.month}.${product.expirationDate.year}',
            style: TextStyle(
              color: isExpired
                  ? Colors.red
                  : isExpiringSoon
                      ? Colors.orange
                      : null,
            ),
          ),
          trailing: Text(
            '${product.quantity} ${product.unit}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'молочные':
        return Icons.breakfast_dining;
      case 'мясо':
        return Icons.restaurant;
      case 'овощи':
        return Icons.eco;
      case 'фрукты':
        return Icons.apple;
      case 'напитки':
        return Icons.local_drink;
      default:
        return Icons.kitchen;
    }
  }
}
