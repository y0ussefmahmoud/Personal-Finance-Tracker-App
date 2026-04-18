/// Delete Installment Use Case
library;

import '../repositories/installment_repository_interface.dart';

class DeleteInstallmentUseCase {
  final InstallmentRepositoryInterface _installmentRepository;

  DeleteInstallmentUseCase(this._installmentRepository);

  Future<void> call(int id) async {
    if (id <= 0) {
      throw ArgumentError('Installment ID must be a positive integer');
    }

    await _installmentRepository.deleteInstallment(id);
  }
}
