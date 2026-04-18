/// Update Installment Use Case
library;

import '../entities/installment_entity.dart';
import '../repositories/installment_repository_interface.dart';

class UpdateInstallmentUseCase {
  final InstallmentRepositoryInterface _installmentRepository;

  UpdateInstallmentUseCase(this._installmentRepository);

  Future<void> call(InstallmentEntity installment) async {
    if (installment.id == null) {
      throw ArgumentError('Installment ID is required for update');
    }

    if (installment.name.isEmpty) {
      throw ArgumentError('Installment name cannot be empty');
    }

    if (installment.totalAmount <= 0) {
      throw ArgumentError('Installment total amount must be greater than 0');
    }

    await _installmentRepository.updateInstallment(installment);
  }
}
