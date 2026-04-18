/// Get Installments Use Case
library;

import '../entities/installment_entity.dart';
import '../repositories/installment_repository_interface.dart';

class GetInstallmentsUseCase {
  final InstallmentRepositoryInterface _installmentRepository;

  GetInstallmentsUseCase(this._installmentRepository);

  Future<List<InstallmentEntity>> call() async {
    return await _installmentRepository.getInstallments();
  }
}
