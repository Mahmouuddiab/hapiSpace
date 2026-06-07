import 'package:habiSpace/core/constant/api_constant.dart';
import 'package:habiSpace/features/payment/data/datasource/payment_remote_datasource.dart';
import 'package:habiSpace/features/payment/data/models/payment_model.dart';

import '../../../../core/constant/dio_helper.dart';

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  @override
  Future<PaymentModel> createPayment(int propertyId) async {
    final response = await DioHelper.post(
      path: ApiConstant.createPayment,
      data: {'property_id': propertyId},
      withAuth: true,
    );

    final statusCode = response.statusCode ?? 0;
    final data = response.data as Map<String, dynamic>?;

    if (statusCode == 409) {
      final message = data?['message'] as String? ??
          'You already have a pending order for this property.';
      throw Exception(message);
    }

    if (statusCode < 200 || statusCode >= 300) {
      final message = data?['message'] as String? ?? 'Something went wrong. Please try again.';
      throw Exception(message);
    }

    if (data == null) {
      throw Exception('Invalid response from server.');
    }

    return PaymentModel.fromJson(data);
  }
}
