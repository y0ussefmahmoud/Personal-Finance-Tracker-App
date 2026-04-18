import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' hide Category;
import '../database/database_helper.dart';
import '../models/installment.dart';
import '../repositories/installment_repository.dart';

class InstallmentProvider extends ChangeNotifier {
  List<Installment> installments = [];
  bool isLoading = false;
  final InstallmentRepository _installmentRepository;

  InstallmentProvider() : _installmentRepository = InstallmentRepository(DatabaseHelper());

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
    installments = await _installmentRepository.getAllInstallments();
    isLoading = false;
    notifyListeners();
  }

  Future<void> addInstallment(Installment installment) async {
    await _installmentRepository.addInstallmentLegacy(installment);
    await fetchInstallments();
  }

  Future<void> updateInstallment(Installment installment) async {
    await _installmentRepository.updateInstallmentLegacy(installment);
    await fetchInstallments();
  }

  Future<void> deleteInstallment(int id) async {
    await _installmentRepository.deleteInstallment(id);
    await fetchInstallments();
  }
}
