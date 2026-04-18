import '../models/installment.dart';
import '../database/database_helper.dart';
import '../domain/repositories/installment_repository_interface.dart';
import '../domain/entities/installment_entity.dart';

/// Repository for managing installment data
/// It implements the InstallmentRepositoryInterface from the domain layer.
class InstallmentRepository implements InstallmentRepositoryInterface {
  final DatabaseHelper _databaseHelper;

  InstallmentRepository(this._databaseHelper);

  @override
  Future<List<InstallmentEntity>> getInstallments() async {
    final installments = await _databaseHelper.getInstallments();
    return installments.map((i) => _toEntity(i)).toList();
  }

  @override
  Future<int> addInstallment(InstallmentEntity entity) async {
    final installment = _toModel(entity);
    return await _databaseHelper.insertInstallment(installment);
  }

  @override
  Future<void> updateInstallment(InstallmentEntity entity) async {
    final installment = _toModel(entity);
    await _databaseHelper.updateInstallment(installment);
  }

  @override
  Future<void> deleteInstallment(int id) async {
    await _databaseHelper.deleteInstallment(id);
  }

  InstallmentEntity _toEntity(Installment model) {
    return InstallmentEntity(
      id: model.id,
      name: model.name,
      totalAmount: model.totalAmount,
      paidAmount: model.paidAmount,
      remainingAmount: model.remainingAmount,
      dueDate: model.dueDate,
      nextPayment: model.nextPayment,
      type: model.type,
      status: model.status,
    );
  }

  Installment _toModel(InstallmentEntity entity) {
    return Installment(
      id: entity.id,
      name: entity.name,
      totalAmount: entity.totalAmount,
      paidAmount: entity.paidAmount,
      remainingAmount: entity.remainingAmount,
      dueDate: entity.dueDate,
      nextPayment: entity.nextPayment,
      type: entity.type,
      status: entity.status,
    );
  }

  Future<List<Installment>> getAllInstallments() async {
    return await _databaseHelper.getInstallments();
  }

  Future<List<Installment>> getInstallmentsByType(String type) async {
    final installments = await _databaseHelper.getInstallments();
    return installments.where((i) => i.type == type).toList();
  }

  /// Legacy method for backward compatibility - accepts Installment model
  Future<int> addInstallmentLegacy(Installment installment) async {
    return await _databaseHelper.insertInstallment(installment);
  }

  /// Legacy method for backward compatibility - accepts Installment model
  Future<void> updateInstallmentLegacy(Installment installment) async {
    await _databaseHelper.updateInstallment(installment);
  }
}
