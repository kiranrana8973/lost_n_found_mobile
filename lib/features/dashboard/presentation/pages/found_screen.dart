import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/theme_extensions.dart';
import '../widgets/found_item_card.dart';

class FoundScreen extends StatefulWidget {
  const FoundScreen({super.key});

  @override
  State<FoundScreen> createState() => _FoundScreenState();
}

class _FoundScreenState extends State<FoundScreen> {
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Electronics',
    'Personal',
    'Accessories',
    'Documents',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            _buildCategories(context),
            const SizedBox(height: 20),
            _buildItemsGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Found Items',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Browse and claim your items',
                  style: TextStyle(fontSize: 14, color: context.textSecondary),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: AppColors.softShadow,
            ),
            child: Icon(Icons.filter_list_rounded, color: context.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () => setState(() => _selectedCategory = category),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  gradient: isSelected ? AppColors.primaryGradient : null,
                  color: isSelected ? null : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: isSelected ? AppColors.buttonShadow : AppColors.softShadow,
                ),
                child: Center(
                  child: Text(
                    category,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildItemsGrid() {
    final items = [
      {'title': 'Phone', 'foundBy': 'John Doe', 'location': 'Block A', 'time': '1h ago'},
      {'title': 'Wallet', 'foundBy': 'John Doe', 'location': 'Block B', 'time': '2h ago'},
      {'title': 'Keys', 'foundBy': 'John Doe', 'location': 'Block C', 'time': '3h ago'},
      {'title': 'Laptop', 'foundBy': 'John Doe', 'location': 'Block D', 'time': '4h ago'},
      {'title': 'Bag', 'foundBy': 'John Doe', 'location': 'Block A', 'time': '5h ago'},
      {'title': 'Watch', 'foundBy': 'John Doe', 'location': 'Block B', 'time': '6h ago'},
      {'title': 'Glasses', 'foundBy': 'John Doe', 'location': 'Block C', 'time': '7h ago'},
      {'title': 'Book', 'foundBy': 'John Doe', 'location': 'Block D', 'time': '8h ago'},
    ];

    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return FoundItemCard(
            title: item['title']!,
            foundBy: item['foundBy']!,
            location: item['location']!,
            time: item['time']!,
            index: index,
            onTap: () {},
          );
        },
      ),
    );
  }
}
