import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/installment.dart';
import '../../../providers/installment_provider.dart';

class AddInstallmentSheet extends StatefulWidget {
  const AddInstallmentSheet({super.key});

  @override
  State<AddInstallmentSheet> createState() => _AddInstallmentSheetState();
}

class _AddInstallmentSheetState extends State<AddInstallmentSheet> {
  int _typeTab = 0;
  final _nameController = TextEditingController();
  final _totalAmountController = TextEditingController();
  final _nextPaymentController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime? _dueDate;

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
                final messenger = ScaffoldMessenger.of(context);
                final navigator = Navigator.of(context);
                
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
                  id: null,
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
                  messenger.showSnackBar(SnackBar(content: Text('تمت الإضافة بنجاح')));
                  navigator.pop();
                } catch (e) {
                  messenger.showSnackBar(SnackBar(content: Text('حدث خطأ: ${e.toString()}')));
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
