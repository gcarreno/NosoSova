import 'package:flutter/material.dart';
import 'package:noso_dart/utils/noso_utility.dart';
import 'package:nososova/ui/config/responsive.dart';
import 'package:nososova/ui/theme/anim/blinkin_widget.dart';
import 'package:nososova/ui/theme/style/text_style.dart';

import '../../generated/assets.dart';
import '../../l10n/app_localizations.dart';
import '../../models/address_wallet.dart';
import '../theme/style/icons_style.dart';

class AddressListTile extends StatefulWidget {
  final VoidCallback onLong;
  final VoidCallback onTap;
  final Address address;

  const AddressListTile({
    Key? key,
    required this.address,
    required this.onLong,
    required this.onTap,
  }) : super(key: key);

  @override
  State createState() => _AddressListTileState();
}

class _AddressListTileState extends State<AddressListTile> {
  @override
  Widget build(BuildContext context) {
    return Tooltip(
        message: messageTooltip(),
        child: GestureDetector(
            onSecondaryTap: widget.onLong,
            child: ListTile(
                contentPadding: const EdgeInsets.only(left: 10, right: 15),
                leading: _iconAddress(),
                title: Text(
                  Responsive.isMobile(context)
                      ? widget.address.hashPublic
                      : widget.address.hash,
                  style: AppTextStyles.walletHash,
                ),
                subtitle: Text(
                  widget.address.custom ?? "",
                  style: AppTextStyles.textHiddenSmall(context),
                ),
                trailing: Text(
                  widget.address.balance == 0
                      ? "0.00"
                      : widget.address.balance.toStringAsFixed(5),
                  style: AppTextStyles.walletBalance,
                ),
                onLongPress: widget.onLong,
                dense: true,
                onTap: widget.onTap)));
  }

  Widget _iconAddress() {
    if (widget.address.nodeStatusOn) {
      return BlinkingWidget(
          widget: AppIconsStyle.icon3x2(Assets.iconsNodeI),
          startBlinking: true,
          duration: 500);
    }

    if (!widget.address.nodeStatusOn && widget.address.nodeStatusOn) {
      return AppIconsStyle.icon3x2(Assets.iconsNodeStop);
    }

    if (widget.address.incoming > 0) {
      return BlinkingWidget(
          widget: AppIconsStyle.icon3x2(Assets.iconsInput),
          startBlinking: true,
          duration: 500);
    }
    if (widget.address.outgoing > 0) {
      return BlinkingWidget(
          widget: AppIconsStyle.icon3x2(Assets.iconsOutput),
          startBlinking: true,
          duration: 500);
    }

    return AppIconsStyle.icon3x2(Assets.iconsCard);
  }

  messageTooltip() {
    if (widget.address.nodeStatusOn) {
      return AppLocalizations.of(context)!.hintStatusNodeRun;
    }

    if (!widget.address.nodeStatusOn &&
        widget.address.balance >= NosoUtility.getCountMonetToRunNode()) {
      return AppLocalizations.of(context)!.hintStatusNodeNonRun;
    }

    return "";
  }
}
