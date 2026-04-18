import '../models/installment.dart';
import '../database/database_helper.dart';

/// Repository for managing installment data
class InstallmentRepository {
  final DatabaseHelper _databaseHelper;

  InstallmentRepository(this._databaseHelper);

  Future<List<Installment>> getAllInstallments() async {
    return await _databaseHelper.getInstallments();
  }

  Future<List<Installment>> getInstallmentsByType(String type) async {
    final installments = await _databaseHelper.getInstallments();
    return installments.where((i) => i.type == type).toList();
  }

  Future<int> addInstallment(Installment installment) async {
    return await _databaseHelper.insertInstallment(installment);
  }

  Future<void> updateInstallment(Installment installment) async {
    await _databaseHelper.updateInstallment(installment);
  }

  Future<void> deleteInstallment(int id) async {
    await _databaseHelper.deleteInstallment(id);
  }
}
