import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/installment.dart';

class InstallmentProvider extends ChangeNotifier {
  List<Installment> installments = [];
  bool isLoading = false;

  double get totalDebt {
    return installments
        .where((i) => i.type == 'debt')
        .fold(0, (sum, i) => sum + i.remainingAmount);
  }

  double get totalInstallments {
    return installments
        .where((i) => i.type == 'installment')
        .fold(0, (sum, i) => sum + i.remainingAmount);
  }

  double get nextMonthPayments {
    final now = DateTime.now();
    final nextMonth = DateTime(now.year, now.month + 1, 1);
    return installments
        .where((i) => i.dueDate.isBefore(nextMonth) && i.status == 'active')
        .fold(0, (sum, i) => sum + i.nextPayment);
  }

  Future<void> fetchInstallments() async {
    isLoading = true;
    notifyListeners();
    final db = DatabaseHelper();
    installments = await db.getInstallments();
    isLoading = false;
    notifyListeners();
  }

  Future<void> addInstallment(Installment installment) async {
    debugPrint('addInstallment called: ${installment.name}');
    final db = DatabaseHelper();
    debugPrint('Calling db.insertInstallment');
    await db.insertInstallment(installment);
    debugPrint('insertInstallment completed, calling fetchInstallments');
    await fetchInstallments();
    debugPrint('addInstallment completed');
  }

  Future<void> updateInstallment(Installment installment) async {
    final db = DatabaseHelper();
    await db.updateInstallment(installment);
    await fetchInstallments();
  }

  Future<void> deleteInstallment(int id) async {
    final db = DatabaseHelper();
    await db.deleteInstallment(id);
    await fetchInstallments();
  }
}
