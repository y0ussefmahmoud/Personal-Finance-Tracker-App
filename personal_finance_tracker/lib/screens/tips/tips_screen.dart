import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tips_provider.dart';
import '../../models/tip.dart';
import '../../widgets/bottom_nav_bar.dart';

class TipsScreen extends StatefulWidget {
  const TipsScreen({super.key});

  @override
  State<TipsScreen> createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'الكل';
  List<String> categories = ['الكل', 'ادخار', 'استثمار', 'زكاة', 'ميزانية', 'توعية'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TipsProvider>().fetchTips();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('النصائح المالية'),
      ),
      body: Consumer<TipsProvider>(
        builder: (context, tipsProvider, child) {
          if (tipsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final filteredTips = _getFilteredTips(tipsProvider.tips);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'البحث في النصائح',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) => setState(() {}),
                ),
              ),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final isSelected = _selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: FilterChip(
                        label: Text(category),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = category;
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
              // Featured Carousel
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: filteredTips.length,
                  itemBuilder: (context, index) {
                    final tip = filteredTips[index];
                    return Container(
                      width: 300,
                      margin: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.green, Colors.greenAccent],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Card(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[800]
                            : Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tip.title,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(tip.content),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => tipsProvider.fetchTips(),
                  child: ListView.builder(
                    itemCount: filteredTips.length,
                    itemBuilder: (context, index) {
                      final tip = filteredTips[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: ListTile(
                          leading: Icon(_getCategoryIcon(tip.category)),
                          title: Text(tip.title),
                          subtitle: Text(tip.content.length > 50
                              ? '${tip.content.substring(0, 50)}...'
                              : tip.content),
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            _showTipDialog(tip);
                            tipsProvider.markAsRead(tip.id!);
                          },
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 4),
    );
  }

  List<Tip> _getFilteredTips(List<Tip> tips) {
    return tips.where((tip) {
      final matchesSearch = _searchController.text.isEmpty ||
          tip.title.contains(_searchController.text) ||
          tip.content.contains(_searchController.text);
      final matchesCategory = _selectedCategory == 'الكل' ||
          _mapCategory(tip.category) == _selectedCategory;
      return matchesSearch && matchesCategory;
    }).toList();
  }

  String _mapCategory(String category) {
    switch (category) {
      case 'saving':
        return 'ادخار';
      case 'investment':
        return 'استثمار';
      case 'budgeting':
        return 'ميزانية';
      default:
        return 'الكل';
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'saving':
        return Icons.savings;
      case 'investment':
        return Icons.trending_up;
      case 'budgeting':
        return Icons.account_balance_wallet;
      default:
        return Icons.info;
    }
  }

  void _showTipDialog(Tip tip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(tip.title),
        content: Text(tip.content),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
