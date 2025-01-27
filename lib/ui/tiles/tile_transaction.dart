import 'package:flutter/material.dart';
import 'package:nososova/ui/theme/style/icons_style.dart';
import 'package:nososova/ui/theme/style/text_style.dart';

import '../../generated/assets.dart';
import '../../models/rest_api/transaction_history.dart';
import '../../utils/other_utils.dart';
import '../theme/style/colors.dart';

class TransactionTile extends StatefulWidget {
  final VoidCallback onTap;
  final TransactionHistory transactionHistory;
  final bool receiver;

  const TransactionTile({
    Key? key,
    required this.transactionHistory,
    required this.onTap,
    required this.receiver,
  }) : super(key: key);

  @override
  TransactionTileState createState() => TransactionTileState();
}

class TransactionTileState extends State<TransactionTile> {
  bool isCustom = false;

  @override
  void initState() {
    super.initState();
    isCustom = widget.transactionHistory.type == "CUSTOM";
  }

  Widget _iconAddress() {
    if (isCustom) {
      return AppIconsStyle.icon3x2(Assets.iconsRename);
    }
    if (widget.receiver) {
      return AppIconsStyle.icon3x2(Assets.iconsInput);
    }
    return AppIconsStyle.icon3x2(Assets.iconsOutput);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _iconAddress(),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
                OtherUtils.hashObfuscation(widget.receiver
                    ? widget.transactionHistory.sender
                    : widget.transactionHistory.receiver),
                style: AppTextStyles.walletHash),
          ),
          Text(
            widget.receiver
                ? "+${double.parse(widget.transactionHistory.amount).toStringAsFixed(3)}"
                : "-${(double.parse(widget.transactionHistory.amount) + double.parse(widget.transactionHistory.fee)).toStringAsFixed(3)}",
            style: AppTextStyles.walletBalance.copyWith(
              color: widget.receiver
                  ? CustomColors.positiveBalance
                  : CustomColors.negativeBalance,
            ),
          ),
        ],
      ),
      onTap: widget.onTap,
    );
  }
}
