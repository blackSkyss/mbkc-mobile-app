import 'package:flutter/material.dart';
import '../../domain/models/order_detail.dart';
import '../../../../utils/commons/widgets/widgets_common_export.dart';
import '../../../../utils/constants/asset_constant.dart';

class OrderDetailItem extends StatelessWidget {
  const OrderDetailItem({
    super.key,
    required this.orderDetail,
  });
  final OrderDetail orderDetail;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LabelText(
          content: '${orderDetail.quantity}X  ${orderDetail.product!.name}',
          size: AssetsConstants.defaultFontSize - 12.0,
          fontWeight: FontWeight.w600,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AssetsConstants.defaultPadding + 3.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...orderDetail.extraOrderDetails!.map((e) => LabelText(
                    content: e.note!,
                    size: AssetsConstants.defaultFontSize - 14.0,
                    color: Colors.grey[700]!,
                    fontWeight: FontWeight.w600,
                  )),
            ],
          ),
        ),
      ],
    );
  }
}
