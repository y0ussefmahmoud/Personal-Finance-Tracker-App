import 'package:flutter/material.dart';
import 'dart:math';
import 'package:provider/provider.dart';
import '../../providers/installment_provider.dart';
import '../../models/installment.dart';
import '../../utils/currency_formatter.dart';
import '../../widgets/bottom_nav_bar.dart';

class InstallmentsScreen extends StatefulWidget {
  const InstallmentsScreen({super.key});

  @override
  _InstallmentsScreenState createState() => _InstallmentsScreenState();
}

class _InstallmentsScreenState extends State<InstallmentsScreen> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    context.read<InstallmentProvider>().fetchInstallments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الأقساط والديون'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () => _showAddSheet(),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: Text('الأقساط'),
                  selected: _selectedTab == 0,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedTab = 0);
                  },
                ),
                SizedBox(width: 16),
                ChoiceChip(
                  label: Text('الديون'),
                  selected: _selectedTab == 1,
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedTab = 1);
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<InstallmentProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                final items = _selectedTab == 0
                    ? provider.installments.where((i) => i.type == 'installment').toList()
                    : provider.installments.where((i) => i.type == 'debt').toList();
                if (items.isEmpty) {
                  return Center(child: Text('لا توجد بيانات'));
                }
                return RefreshIndicator(
                  onRefresh: () => provider.fetchInstallments(),
                  child: ListView(
                    children: _selectedTab == 0
                        ? items.map((installment) => _InstallmentCard(installment: installment, onPay: () => _showPayInstallmentDialog(context, installment))).toList()
                        : items.map((debt) => _DebtCard(debt: debt)).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddSheet,
        icon: Icon(Icons.add),
        label: Text('إضافة جديد'),
      ),
      );
  }

  Future<void> _showPayInstallmentDialog(BuildContext context, Installment installment) async {
    final messenger = ScaffoldMessenger.of(context);
    TextEditingController controller = TextEditingController(text: installment.nextPayment.toString());
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('دفع القسط'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(labelText: 'المبلغ'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              double enteredAmount = double.tryParse(controller.text) ?? 0;
              if (enteredAmount <= 0 || enteredAmount > installment.remainingAmount) {
                if (context.mounted) {
                  messenger.showSnackBar(
                    SnackBar(content: Text('المبلغ غير صحيح. يجب أن يكون موجبًا ولا يتجاوز المبلغ المتبقي')),
                  );
                }
                return;
              }
              double newPaidAmount = installment.paidAmount + enteredAmount;
              double newRemainingAmount = installment.totalAmount - newPaidAmount;
              if (newRemainingAmount < 0) newRemainingAmount = 0;
              String newStatus = newRemainingAmount <= 0 ? 'closed' : 'active';
              Installment updatedInstallment = Installment(
                id: installment.id,
                name: installment.name,
                totalAmount: installment.totalAmount,
                paidAmount: newPaidAmount,
                remainingAmount: newRemainingAmount,
                dueDate: installment.dueDate,
                nextPayment: installment.nextPayment,
                type: installment.type,
                status: newStatus,
              );
              try {
                await context.read<InstallmentProvider>().updateInstallment(updatedInstallment);
                if (context.mounted) {
                  Navigator.pop(context);
                }
                if (context.mounted) {
                  messenger.showSnackBar(
                    SnackBar(content: Text('تم تسجيل الدفعة بنجاح')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  messenger.showSnackBar(
                    SnackBar(content: Text('حدث خطأ أثناء تحديث القسط')),
                  );
                }
              }
            },
            child: Text('تأكيد'),
          ),
        ],
      ),
    );
    controller.dispose();
  }

  void _showAddSheet() {
    final messenger = ScaffoldMessenger.of(context);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _AddInstallmentSheet(messenger: messenger),
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final Color foregroundColor;
  final Color backgroundColor;

  _CircularProgressPainter({
    required this.progress,
    required this.foregroundColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 8.0) / 2;
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0;
    final fgPaint = Paint()
      ..color = foregroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress.clamp(0.0, 1.0),
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _InstallmentCard extends StatelessWidget {
  final Installment installment;
  final VoidCallback onPay;

  const _InstallmentCard({required this.installment, required this.onPay});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final progress = installment.totalAmount > 0 ? installment.paidAmount / installment.totalAmount : 0.0;
    final fgColor = installment.status == 'closed'
        ? (isDark ? Color(0xFF00E676) : Color(0xFF4CAF50))
        : (isDark ? Color(0xFF3B82F6) : Color(0xFF1565C0));
    final bgColor = Theme.of(context).colorScheme.surface.withValues(alpha: 0.3);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            SizedBox(
              width: 64,
              height: 64,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    painter: _CircularProgressPainter(
                      progress: progress,
                      foregroundColor: fgColor,
                      backgroundColor: bgColor,
                    ),
                    size: Size(64, 64),
                  ),
                  Text('${(progress * 100).round()}%'),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(installment.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(formatCurrency(installment.remainingAmount)),
                    Text('${installment.dueDate.day}/${installment.dueDate.month}/${installment.dueDate.year}'),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: installment.status == 'closed' ? Colors.green : Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    installment.status == 'closed' ? 'مكتمل' : 'نشط',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                if (installment.status == 'active')
                  TextButton(
                    onPressed: onPay,
                    child: Text('دفع القسط'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DebtCard extends StatefulWidget {
  final Installment debt;

  const _DebtCard({required this.debt});

  @override
  _DebtCardState createState() => _DebtCardState();
}

class _DebtCardState extends State<_DebtCard> {
  bool _reminderOn = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final amountColor = isDark ? Color(0xFFFF5252) : Color(0xFFEF4444);
    final initial = widget.debt.name.isNotEmpty ? widget.debt.name[0].toUpperCase() : '?';
    final avatarColor = Theme.of(context).primaryColor.withValues(alpha: 0.1);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: avatarColor,
              child: Text(initial),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.debt.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(
                      formatCurrency(widget.debt.remainingAmount),
                      style: TextStyle(color: amountColor),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.debt.status == 'closed' ? Colors.green : Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.debt.status == 'closed' ? 'مكتمل' : 'نشط',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Row(
                  children: [
                    Text('تذكير'),
                    Switch(
                      value: _reminderOn,
                      onChanged: (value) => setState(() => _reminderOn = value),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AddInstallmentSheet extends StatefulWidget {
  final ScaffoldMessengerState messenger;

  const _AddInstallmentSheet({required this.messenger});

  @override
  _AddInstallmentSheetState createState() => _AddInstallmentSheetState();
}

class _AddInstallmentSheetState extends State<_AddInstallmentSheet> {
  int _typeTab = 0;
  final _nameController = TextEditingController();
  final _totalAmountController = TextEditingController();
  final _nextPaymentController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime? _dueDate;
  late final ScaffoldMessengerState messenger;

  @override
  void initState() {
    super.initState();
    messenger = widget.messenger;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: Text('قسط'),
                  selected: _typeTab == 0,
                  onSelected: (selected) {
                    if (selected) setState(() => _typeTab = 0);
                  },
                ),
                SizedBox(width: 16),
                ChoiceChip(
                  label: Text('دين'),
                  selected: _typeTab == 1,
                  onSelected: (selected) {
                    if (selected) setState(() => _typeTab = 1);
                  },
                ),
              ],
            ),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'الاسم'),
            ),
            TextFormField(
              controller: _totalAmountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'المبلغ الإجمالي', suffixText: 'ج.م'),
            ),
            TextFormField(
              controller: _nextPaymentController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'المبلغ التالي', suffixText: 'ج.م'),
            ),
            TextFormField(
              readOnly: true,
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'تاريخ الاستحقاق',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () async {
                DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2101),
                );
                if (picked != null) {
                  setState(() {
                    _dueDate = picked;
                    _dateController.text = '${picked.day}/${picked.month}/${picked.year}';
                  });
                }
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                if (_nameController.text.isEmpty ||
                    double.tryParse(_totalAmountController.text) == null ||
                    double.tryParse(_totalAmountController.text)! <= 0 ||
                    double.tryParse(_nextPaymentController.text) == null ||
                    double.tryParse(_nextPaymentController.text)! <= 0 ||
                    _dueDate == null) {
                  messenger.showSnackBar(SnackBar(content: Text('يرجى إدخال بيانات صحيحة')));
                  return;
                }
                double totalAmount = double.parse(_totalAmountController.text);
                double nextPayment = double.parse(_nextPaymentController.text);
                Installment installment = Installment(
                  id: null, // Assume auto-generated
                  name: _nameController.text,
                  totalAmount: totalAmount,
                  paidAmount: 0,
                  remainingAmount: totalAmount,
                  dueDate: _dueDate!,
                  nextPayment: nextPayment,
                  type: _typeTab == 0 ? 'installment' : 'debt',
                  status: 'active',
                );
                try {
                  await context.read<InstallmentProvider>().addInstallment(installment);
                  if (context.mounted) {
                    messenger.showSnackBar(SnackBar(content: Text('تمت الإضافة بنجاح')));
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (context.mounted) {
                    messenger.showSnackBar(SnackBar(content: Text('حدث خطأ: ${e.toString()}')));
                  }
                }
              },
              child: Text('إضافة'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _totalAmountController.dispose();
    _nextPaymentController.dispose();
    _dateController.dispose();
    super.dispose();
  }
}
