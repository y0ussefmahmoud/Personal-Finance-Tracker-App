/// Add Installment Use Case
library;

import '../entities/installment_entity.dart';
import '../repositories/installment_repository_interface.dart';

class AddInstallmentUseCase {
  final InstallmentRepositoryInterface _installmentRepository;

  AddInstallmentUseCase(this._installmentRepository);

  Future<int> call(InstallmentEntity installment) async {
    if (installment.name.isEmpty) {
      throw ArgumentError('Installment name cannot be empty');
    }

    if (installment.totalAmount <= 0) {
      throw ArgumentError('Installment total amount must be greater than 0');
    }

    if (installment.remainingAmount < 0) {
      throw ArgumentError('Installment remaining amount cannot be negative');
    }

    return await _installmentRepository.addInstallment(installment);
  }
}
