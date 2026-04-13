import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/installment_provider.dart';
import '../../models/installment.dart';
import '../../widgets/bottom_nav_bar.dart';
import 'widgets/installment_card.dart';
import 'widgets/debt_card.dart';
import 'widgets/add_installment_sheet.dart';

class InstallmentsScreen extends StatefulWidget {
  const InstallmentsScreen({super.key});

  @override
  State<InstallmentsScreen> createState() => _InstallmentsScreenState();
}

class _InstallmentsScreenState extends State<InstallmentsScreen> {
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<InstallmentProvider>().fetchInstallments();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الأقساط والديون'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showAddSheet,
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
                        ? items.map((installment) => InstallmentCard(installment: installment, onPay: () => _showPayInstallmentDialog(context, installment))).toList()
                        : items.map((debt) => DebtCard(debt: debt)).toList(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(currentIndex: 3),
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddInstallmentSheet(),
    );
  }
}
