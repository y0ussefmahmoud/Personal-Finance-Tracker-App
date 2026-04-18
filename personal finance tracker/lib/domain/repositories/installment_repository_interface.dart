/// Installment Repository Interface
library;

import '../entities/installment_entity.dart';

abstract class InstallmentRepositoryInterface {
  Future<List<InstallmentEntity>> getInstallments();
  Future<int> addInstallment(InstallmentEntity installment);
  Future<void> updateInstallment(InstallmentEntity installment);
  Future<void> deleteInstallment(int id);
}
