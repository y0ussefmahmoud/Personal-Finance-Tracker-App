import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/category.dart';
import '../../providers/category_provider.dart';
import '../../utils/helpers.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<CategoryProvider>(context, listen: false);
      if (provider.categories.isEmpty) {
        provider.fetchCategories();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('التصنيفات'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCategoryFormSheet(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'الكل'),
            Tab(text: 'دخل'),
            Tab(text: 'مصروف'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _CategoryTabView(filter: null),
          _CategoryTabView(filter: 'income'),
          _CategoryTabView(filter: 'expense'),
        ],
      ),
    );
  }

  void _showCategoryFormSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _CategoryFormSheet(),
    );
  }
}

class _CategoryTabView extends StatelessWidget {
  final String? filter;

  const _CategoryTabView({this.filter});

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        List<Category> filteredCategories = _filterCategories(provider.categories, filter);
        if (filteredCategories.isEmpty) {
          return const Center(child: Text('لا توجد تصنيفات'));
        }
        return ListView.builder(
          itemCount: filteredCategories.length,
          itemBuilder: (context, index) {
            final category = filteredCategories[index];
            return _CategoryListTile(
              category: category,
              onEdit: () => _showEditSheet(context, category),
              onDelete: () => _confirmDelete(context, category),
            );
          },
        );
      },
    );
  }

  List<Category> _filterCategories(List<Category> categories, String? filter) {
    if (filter == null) return categories;
    return categories.where((cat) => cat.type == filter || cat.type == 'both').toList();
  }

  void _showEditSheet(BuildContext context, Category category) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _CategoryFormSheet(category: category),
    );
  }

  void _confirmDelete(BuildContext context, Category category) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف التصنيف'),
        content: Text('هل أنت متأكد من حذف تصنيف \'${category.name}\'؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final provider = context.read<CategoryProvider>();
              try {
                await provider.deleteCategory(category.id!);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم حذف ${category.name}')));
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('فشل في الحذف: $e')));
                }
              }
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
  }
}

class _CategoryListTile extends StatelessWidget {
  final Category category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryListTile({
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final icon = iconFromString(category.icon);
    final color = Color(category.color);
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Icon(icon, color: Colors.white),
      ),
      title: Text(category.name),
      subtitle: Text(_getTypeLabel(category.type)),
      trailing: category.isCustom
          ? Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: onDelete,
                ),
              ],
            )
          : null,
    );
  }

  String _getTypeLabel(String type) {
    switch (type) {
      case 'income':
        return 'دخل';
      case 'expense':
        return 'مصروف';
      case 'both':
        return 'كلاهما';
      default:
        return '';
    }
  }
}

class _CategoryFormSheet extends StatefulWidget {
  final Category? category;

  const _CategoryFormSheet({this.category});

  @override
  State<_CategoryFormSheet> createState() => _CategoryFormSheetState();
}

class _CategoryFormSheetState extends State<_CategoryFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late String _selectedType;
  late String _selectedIcon;
  late int _selectedColor;

  final List<String> _availableIcons = [
    'restaurant',
    'shopping_bag',
    'health_and_safety',
    'receipt_long',
    'directions_car',
    'theater_comedy',
    'volunteer_activism',
    'payments',
  ];

  final List<int> _availableColors = [
    0xFF4285F4, // blue
    0xFFEA4335, // red
    0xFFFBBC05, // yellow
    0xFF34A853, // green
    0xFF8E24AA, // purple
    0xFFFF9800, // orange
    0xFF009688, // teal
    0xFF795548, // brown
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.category?.name ?? '');
    _selectedType = widget.category?.type ?? 'both';
    _selectedIcon = widget.category?.icon ?? 'restaurant';
    _selectedColor = widget.category?.color ?? _availableColors[0];
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'الاسم'),
              validator: (value) => value?.isEmpty ?? true ? 'الاسم مطلوب' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _selectedType,
              decoration: const InputDecoration(labelText: 'النوع'),
              items: const [
                DropdownMenuItem(value: 'income', child: Text('دخل')),
                DropdownMenuItem(value: 'expense', child: Text('مصروف')),
                DropdownMenuItem(value: 'both', child: Text('كلاهما')),
              ],
              onChanged: (value) => setState(() => _selectedType = value!),
            ),
            const SizedBox(height: 16),
            const Text('الأيقونة'),
            const SizedBox(height: 8),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemCount: _availableIcons.length,
              itemBuilder: (context, index) {
                final iconName = _availableIcons[index];
                final isSelected = iconName == _selectedIcon;
                return InkWell(
                  onTap: () => setState(() => _selectedIcon = iconName),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(iconFromString(iconName)),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            const Text('اللون'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableColors.map((color) {
                final isSelected = color == _selectedColor;
                return InkWell(
                  onTap: () => setState(() => _selectedColor = color),
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Color(color),
                      border: Border.all(
                        color: isSelected ? Colors.black : Colors.transparent,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _save,
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final newCategory = Category(
      id: widget.category?.id,
      name: _nameController.text,
      color: _selectedColor,
      icon: _selectedIcon,
      type: _selectedType,
      isCustom: widget.category?.isCustom ?? true,
    );
    final provider = context.read<CategoryProvider>();
    try {
      if (widget.category == null) {
        await provider.addCategory(newCategory);
      } else {
        await provider.updateCategory(newCategory);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('فشل في حفظ التصنيف: $e')));
      return;
    }
    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حفظ التصنيف')));
    }
  }
}
