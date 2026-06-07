import 'package:habiSpace/features/payment/domain/Entities/payment_entity.dart';

abstract class PaymentRepo {
  Future<PaymentEntity> createPayment(int propertyId);
}
