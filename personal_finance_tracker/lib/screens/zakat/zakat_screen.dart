import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:personal_finance_tracker/database/database_helper.dart';
import 'package:personal_finance_tracker/models/zakat.dart';
import 'package:personal_finance_tracker/providers/zakat_provider.dart';
import 'package:personal_finance_tracker/widgets/bottom_nav_bar.dart';
import '../../utils/currency_formatter.dart';

class ZakatScreen extends StatefulWidget {
  const ZakatScreen({super.key});

  @override
  State<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends State<ZakatScreen> {
  int _selectedTab = 0;
  final TextEditingController _goldController = TextEditingController();
  final TextEditingController _cashController = TextEditingController();
  final TextEditingController _investmentsController = TextEditingController();
  double _nisabValue = 250000.0;
  double _computedTotal = 0.0;
  double _computedZakat = 0.0;

  @override
  void initState() {
    super.initState();
    context.read<ZakatProvider>().fetchZakatRecords();
    _loadNisab();
    _goldController.addListener(_recalculate);
    _cashController.addListener(_recalculate);
    _investmentsController.addListener(_recalculate);
  }

  @override
  void dispose() {
    _goldController.dispose();
    _cashController.dispose();
    _investmentsController.dispose();
    super.dispose();
  }

  void _loadNisab() async {
    final settings = DatabaseHelper();
    final nisabString = await settings.getSetting('nisab_value');
    if (nisabString != null) {
      updateNisabValue(double.tryParse(nisabString) ?? 250000.0);
    }
  }

  void updateNisabValue(double newValue) {
    setState(() {
      _nisabValue = newValue;
    });
    _recalculate();
  }

  void _recalculate() {
    final gold = double.tryParse(_goldController.text) ?? 0.0;
    final cash = double.tryParse(_cashController.text) ?? 0.0;
    final investments = double.tryParse(_investmentsController.text) ?? 0.0;
    _computedTotal = gold + cash + investments;
    _computedZakat = _computedTotal >= _nisabValue ? _computedTotal * 0.025 : 0.0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الزكاة والصدقات'),
      ),
      body: Column(
        children: [
          _SegmentedToggle(
            selectedIndex: _selectedTab,
            onTabChanged: (index) => setState(() => _selectedTab = index),
          ),
          Expanded(
            child: Consumer<ZakatProvider>(
              builder: (context, zakatProvider, child) {
                return RefreshIndicator(
                  onRefresh: () => zakatProvider.fetchZakatRecords(),
                  child: zakatProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : SingleChildScrollView(
                          padding: const EdgeInsets.all(16.0),
                          child: _selectedTab == 0 ? _ZakatView(this) : _SadaqaView(),
                        ),
                );
              },
            ),
          ),
        ],
      ),
      bottomSheet: _selectedTab == 0 ? _StickyFooter(this) : null,
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
    );
  }
}

class _SegmentedToggle extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChanged;

  const _SegmentedToggle({required this.selectedIndex, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ChoiceChip(
            label: const Text('الزكاة'),
            selected: selectedIndex == 0,
            onSelected: (_) => onTabChanged(0),
          ),
        ),
        Expanded(
          child: ChoiceChip(
            label: const Text('الصدقة'),
            selected: selectedIndex == 1,
            onSelected: (_) => onTabChanged(1),
          ),
        ),
      ],
    );
  }
}

class _ZakatView extends StatelessWidget {
  final _ZakatScreenState parent;

  const _ZakatView(this.parent);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _NisabBannerCard(parent),
        _InputCard(label: 'قيمة الذهب والفضة', controller: parent._goldController),
        _InputCard(label: 'النقد المتوفر', controller: parent._cashController),
        _InputCard(label: 'الاستثمارات والأسهم', controller: parent._investmentsController),
        _StatusIndicator(parent),
      ],
    );
  }
}

class _NisabBannerCard extends StatelessWidget {
  final _ZakatScreenState parent;

  const _NisabBannerCard(this.parent);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color(0xFF2f7f33), const Color(0xFF4CAF50)],
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'النصاب الحالي: ${formatCurrency(parent._nisabValue)}',
            style: const TextStyle(color: Colors.white, fontSize: 16.0),
          ),
          TextButton(
            onPressed: () => _showUpdateNisabDialog(context, parent),
            child: const Text('تحديث الأسعار', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showUpdateNisabDialog(BuildContext context, _ZakatScreenState parent) {
    final controller = TextEditingController(text: parent._nisabValue.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تحديث النصاب'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(labelText: 'قيمة النصاب الجديدة'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              final newValue = double.tryParse(controller.text) ?? parent._nisabValue;
              final settings = DatabaseHelper();
              await settings.setSetting('nisab_value', newValue.toString());
              parent.updateNisabValue(newValue);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _InputCard({required this.label, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: label,
            suffixText: 'ج.م',
          ),
        ),
      ),
    );
  }
}

class _StatusIndicator extends StatelessWidget {
  final _ZakatScreenState parent;

  const _StatusIndicator(this.parent);

  @override
  Widget build(BuildContext context) {
    final isEligible = parent._computedTotal >= parent._nisabValue;
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(
            isEligible ? Icons.check_circle : Icons.info_outline,
            color: isEligible ? const Color(0xFF2f7f33) : Colors.grey,
          ),
          const SizedBox(width: 8.0),
          Text(
            isEligible ? 'تجب عليك الزكاة' : 'لم يتجاوز النصاب',
            style: TextStyle(
              color: isEligible ? const Color(0xFF2f7f33) : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class _SadaqaView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final zakatProvider = context.watch<ZakatProvider>();
    final paidRecords = zakatProvider.zakatRecords.where((record) => record.paid).toList();

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: paidRecords.length,
          itemBuilder: (context, index) {
            final record = paidRecords[index];
            return ListTile(
              title: Text('مبلغ: ${formatCurrency(record.totalZakat)}'),
              subtitle: Text('التاريخ: ${record.date.toString().split(' ')[0]}'),
            );
          },
        ),
        ElevatedButton(
          onPressed: () => _showAddSadaqaDialog(context),
          child: const Text('إضافة صدقة'),
        ),
      ],
    );
  }

  void _showAddSadaqaDialog(BuildContext context) {
    final amountController = TextEditingController();
    final dateController = TextEditingController(text: DateTime.now().toString().split(' ')[0]);

    showModalBottomSheet(
      context: context,
      builder: (context) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(labelText: 'مبلغ الصدقة'),
            ),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'التاريخ'),
            ),
            ElevatedButton(
              onPressed: () async {
                final amount = double.tryParse(amountController.text) ?? 0.0;
                final date = DateTime.parse(dateController.text);
                final zakat = Zakat(
                  id: 0, // Will be set by DB
                  goldValue: 0.0,
                  silverValue: 0.0, // Assuming silver is part of gold or separate, but plan says gold and silver together
                  cash: amount,
                  investments: 0.0,
                  totalZakat: amount,
                  paid: true,
                  date: date,
                );
                await context.read<ZakatProvider>().addZakatRecord(zakat);
                if (context.mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: const Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }
}

class _StickyFooter extends StatelessWidget {
  final _ZakatScreenState parent;

  const _StickyFooter(this.parent);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('مبلغ الزكاة المستحق'),
              Text(
                formatCurrency(parent._computedZakat),
                style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _showHistory(context),
                  child: const Text('السجل التاريخي'),
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: ElevatedButton(
                  onPressed: parent._computedZakat > 0 ? () => _payZakat(context) : null,
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2f7f33)),
                  child: const Text('دفع الزكاة الآن'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showHistory(BuildContext context) {
    final zakatProvider = context.read<ZakatProvider>();
    showModalBottomSheet(
      context: context,
      builder: (context) => ListView.builder(
        itemCount: zakatProvider.zakatRecords.length,
        itemBuilder: (context, index) {
          final record = zakatProvider.zakatRecords[index];
          return ListTile(
            title: Text('التاريخ: ${record.date.toString().split(' ')[0]}'),
            subtitle: Text('المبلغ: ${formatCurrency(record.totalZakat)}, مدفوع: ${record.paid ? 'نعم' : 'لا'}'),
          );
        },
      ),
    );
  }

  void _payZakat(BuildContext context) async {
    final gold = double.tryParse(parent._goldController.text) ?? 0.0;
    final cash = double.tryParse(parent._cashController.text) ?? 0.0;
    final investments = double.tryParse(parent._investmentsController.text) ?? 0.0;

    final zakat = Zakat(
      id: 0,
      goldValue: gold,
      silverValue: 0.0, // Assuming silver is part of gold or separate, but plan says gold and silver together
      cash: cash,
      investments: investments,
      totalZakat: parent._computedZakat,
      paid: true,
      date: DateTime.now(),
    );

    await context.read<ZakatProvider>().addZakatRecord(zakat);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم تسجيل دفع الزكاة بنجاح')),
      );
    }
    parent._goldController.clear();
    parent._cashController.clear();
    parent._investmentsController.clear();
    parent._recalculate();
  }
}

