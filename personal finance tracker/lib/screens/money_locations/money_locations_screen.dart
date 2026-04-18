import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/money_location.dart';
import '../../providers/money_location_provider.dart';
import '../../providers/settings_provider.dart';
import '../../utils/helpers.dart';

class MoneyLocationsScreen extends StatefulWidget {
  const MoneyLocationsScreen({super.key});

  @override
  State<MoneyLocationsScreen> createState() => _MoneyLocationsScreenState();
}

class _MoneyLocationsScreenState extends State<MoneyLocationsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<MoneyLocationProvider>(context, listen: false);
      provider.fetchMoneyLocations();
      if (provider.moneyLocations.isEmpty) {
        provider.seedDefaultMoneyLocations();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة أماكن المال'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showMoneyLocationFormSheet(context),
          ),
        ],
      ),
      body: Consumer2<MoneyLocationProvider, SettingsProvider>(
        builder: (context, provider, settings, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              _SummaryCard(
                totalExpected: provider.totalExpectedAmount,
                totalActual: provider.totalActualAmount,
                totalDeficit: provider.totalDeficit,
                currency: settings.currencySymbol,
              ),
              Expanded(
                child: provider.moneyLocations.isEmpty
                    ? const Center(child: Text('لا توجد أماكن مال'))
                    : ListView.builder(
                        itemCount: provider.moneyLocations.length,
                        itemBuilder: (context, index) {
                          final location = provider.moneyLocations[index];
                          final expectedAmount = provider.calculateExpectedAmount(location.id!);
                          return _MoneyLocationListTile(
                            location: location,
                            expectedAmount: expectedAmount,
                            currency: settings.currencySymbol,
                            onEdit: () => _showEditSheet(context, location),
                            onDelete: () => _confirmDelete(context, location),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showMoneyLocationFormSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const _MoneyLocationFormSheet(),
    );
  }

  void _showEditSheet(BuildContext context, MoneyLocation location) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _MoneyLocationFormSheet(location: location),
    );
  }

  void _confirmDelete(BuildContext context, MoneyLocation location) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف مكان المال'),
        content: Text('هل أنت متأكد من حذف \'${location.name}\'؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context).pop();
              final provider = context.read<MoneyLocationProvider>();
              try {
                await provider.deleteMoneyLocation(location.id!);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم حذف ${location.name}')));
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

class _SummaryCard extends StatelessWidget {
  final double totalExpected;
  final double totalActual;
  final double totalDeficit;
  final String currency;

  const _SummaryCard({
    required this.totalExpected,
    required this.totalActual,
    required this.totalDeficit,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('إجمالي الرصيد المتوقع:'),
                Text('$currency${totalExpected.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('إجمالي الرصيد الفعلي:'),
                Text('$currency${totalActual.toStringAsFixed(2)}'),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'العجز:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '$currency${totalDeficit.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: totalDeficit > 0.01 ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MoneyLocationListTile extends StatelessWidget {
  final MoneyLocation location;
  final double expectedAmount;
  final String currency;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _MoneyLocationListTile({
    required this.location,
    required this.expectedAmount,
    required this.currency,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final icon = iconFromString(location.icon);
    final color = Color(location.color);
    final deficit = location.actualAmount - expectedAmount;
    final hasDeficit = deficit < -0.01;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(location.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('رصيد متوقع: $currency${expectedAmount.toStringAsFixed(2)}'),
            Text('رصيد فعلي: $currency${location.actualAmount.toStringAsFixed(2)}'),
            if (hasDeficit)
              Text(
                'عجز: $currency${deficit.toStringAsFixed(2)}',
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
          ],
        ),
        trailing: Row(
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
        ),
      ),
    );
  }
}

class _MoneyLocationFormSheet extends StatefulWidget {
  final MoneyLocation? location;

  const _MoneyLocationFormSheet({this.location});

  @override
  State<_MoneyLocationFormSheet> createState() => _MoneyLocationFormSheetState();
}

class _MoneyLocationFormSheetState extends State<_MoneyLocationFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _actualAmountController;
  late String _selectedIcon;
  late int _selectedColor;

  final List<String> _availableIcons = [
    'account_balance_wallet',
    'account_balance',
    'smartphone',
    'credit_card',
    'savings',
    'attach_money',
    'payments',
    'wallet',
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
    _nameController = TextEditingController(text: widget.location?.name ?? '');
    _actualAmountController = TextEditingController(
      text: widget.location?.actualAmount.toString() ?? '0',
    );
    _selectedIcon = widget.location?.icon ?? 'account_balance_wallet';
    _selectedColor = widget.location?.color ?? _availableColors[0];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _actualAmountController.dispose();
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
            TextFormField(
              controller: _actualAmountController,
              decoration: const InputDecoration(labelText: 'المبلغ الفعلي'),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value?.isEmpty ?? true) return 'المبلغ مطلوب';
                if (double.tryParse(value!) == null) return 'قيمة غير صحيحة';
                return null;
              },
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

    final actualAmount = double.parse(_actualAmountController.text);

    final newLocation = MoneyLocation(
      id: widget.location?.id,
      name: _nameController.text,
      actualAmount: actualAmount,
      icon: _selectedIcon,
      color: _selectedColor,
      createdAt: widget.location?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final provider = context.read<MoneyLocationProvider>();
    try {
      if (widget.location == null) {
        await provider.addMoneyLocation(newLocation);
      } else {
        await provider.updateMoneyLocation(newLocation);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في الحفظ: $e')),
        );
      }
      return;
    }

    if (mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم الحفظ بنجاح')),
      );
    }
  }
}
