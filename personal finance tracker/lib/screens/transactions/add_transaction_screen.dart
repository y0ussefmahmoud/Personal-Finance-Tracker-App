// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../providers/transaction_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/budget_provider.dart';
import '../../models/transaction.dart';

class AddTransactionScreen extends StatefulWidget {
  final Transaction? transaction;

  const AddTransactionScreen({super.key, this.transaction});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  String _type = 'expense';
  String? _selectedCategory;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  DateTime _date = DateTime.now();
  bool _isRecurring = false;
  bool _includeInZakat = false;
  String _selectedPaymentMethod = 'نقدي';
  String? _selectedRecurringType;

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      final t = widget.transaction!;
      _type = t.type;
      _selectedCategory = t.category;
      _amountController.text = t.amount.toString();
      _notesController.text = t.description;
      _date = t.date;
      _isRecurring = t.isRecurring;
      _selectedPaymentMethod = t.paymentMethod;
      _selectedRecurringType = t.recurringType;
    }
  }

  Map<String, IconData> iconMap = {
    'restaurant': Icons.restaurant,
    'shopping_bag': Icons.shopping_bag,
    'health_and_safety': Icons.health_and_safety,
    'receipt_long': Icons.receipt_long,
    'directions_car': Icons.directions_car,
    'theater_comedy': Icons.theater_comedy,
    'volunteer_activism': Icons.volunteer_activism,
    'payments': Icons.payments,
  };

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<CategoryProvider>().categories;
    final filteredCategories = categories.where((cat) => cat.type == _type || cat.type == 'both').toList();
    final currencySymbol = context.watch<SettingsProvider>().currencySymbol;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(widget.transaction != null ? 'تعديل معاملة' : 'إضافة معاملة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _save,
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Type toggle
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(
                      value: 'expense',
                      label: const Text('مصروف'),
                      icon: const Icon(Icons.remove, color: Colors.red),
                    ),
                    ButtonSegment(
                      value: 'income',
                      label: const Text('دخل'),
                      icon: const Icon(Icons.add, color: Colors.green),
                    ),
                  ],
                  selected: {_type},
                  onSelectionChanged: (Set<String> selected) {
                    setState(() {
                      _type = selected.first;
                      _selectedCategory = null; // reset category on type change
                    });
                  },
                ),
                const SizedBox(height: 20),
                // Amount
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: '0.00',
                    suffixText: currencySymbol,
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(height: 20),
                // Payment method
                DropdownButtonFormField<String>(
                  initialValue: _selectedPaymentMethod,
                  decoration: const InputDecoration(
                    labelText: 'طريقة الدفع',
                    border: OutlineInputBorder(),
                  ),
                  items: ['نقدي', 'بطاقة', 'تحويل'].map((method) => DropdownMenuItem(
                    value: method,
                    child: Text(method),
                  )).toList(),
                  onChanged: (value) => setState(() => _selectedPaymentMethod = value!),
                ),
                const SizedBox(height: 20),
                // Category grid
                const Text('اختر الفئة'),
                const SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 4,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: filteredCategories.map((cat) {
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat.name),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        margin: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: _selectedCategory == cat.name
                              ? Theme.of(context).primaryColor.withValues(alpha: 0.2)
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              iconMap[cat.icon] ?? Icons.category,
                              color: Color(cat.color),
                              size: 24,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              cat.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                // Date picker
                Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _date,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) setState(() => _date = picked);
                        },
                        child: Text(DateFormat('yyyy-MM-dd').format(_date)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Recurring
                SwitchListTile(
                  title: const Text('متكرر'),
                  value: _isRecurring,
                  onChanged: (v) => setState(() => _isRecurring = v),
                ),
                const SizedBox(height: 20),
                // Recurring type
                if (_isRecurring)
                  DropdownButtonFormField<String>(
                    initialValue: _selectedRecurringType,
                    decoration: const InputDecoration(
                      labelText: 'نوع التكرار',
                      border: OutlineInputBorder(),
                    ),
                    items: ['يومي', 'أسبوعي', 'شهري', 'سنوي'].map((type) => DropdownMenuItem(
                      value: type,
                      child: Text(type),
                    )).toList(),
                    onChanged: (value) => setState(() => _selectedRecurringType = value),
                  ),
                const SizedBox(height: 20),
                // Notes
                TextField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'ملاحظات',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 20),
                // Zakat inclusion
                if (_type == 'expense')
                  CheckboxListTile(
                    title: const Text('شمل في الزكاة'),
                    secondary: const Icon(Icons.volunteer_activism),
                    value: _includeInZakat,
                    onChanged: (v) => setState(() => _includeInZakat = v ?? false),
                  ),
                const SizedBox(height: 80), // space for button
              ],
            ),
          ),
          // Sticky save button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: Theme.of(context).scaffoldBackgroundColor,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('حفظ المعاملة'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _save() async {
    if (_amountController.text.isEmpty ||
        double.tryParse(_amountController.text) == null ||
        _selectedCategory == null ||
        _type.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء جميع الحقول بشكل صحيح')),
      );
      return;
    }

    if (_isRecurring && _selectedRecurringType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى اختيار نوع التكرار')),
      );
      return;
    }

    final transaction = Transaction(
      id: widget.transaction?.id,
      type: _type,
      amount: double.parse(_amountController.text),
      category: _selectedCategory!,
      description: _notesController.text,
      date: _date,
      paymentMethod: _selectedPaymentMethod,
      isRecurring: _isRecurring,
      recurringType: _selectedRecurringType,
      createdAt: widget.transaction?.createdAt ?? DateTime.now(),
    );

    try {
      final transactionProvider = context.read<TransactionProvider>();
      transactionProvider.budgetProvider = context.read<BudgetProvider>();
      
      if (widget.transaction != null) {
        await transactionProvider.updateTransaction(transaction);
      } else {
        await transactionProvider.addTransaction(transaction);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('تم حفظ المعاملة بنجاح')),
        );
      }
      Navigator.pop(context);
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('حدث خطأ أثناء الحفظ')),
        );
      }
    }
  }
}
