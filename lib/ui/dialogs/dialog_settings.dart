import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import '../../generated/assets.dart';
import '../../l10n/app_localizations.dart';
import '../theme/style/colors.dart';
import '../theme/style/text_style.dart';

class DialogSettings {


  static void showDialogSettings(BuildContext context) {
    const double pagePadding = 16.0;
    const double pageBreakpoint = 768.0;
    final pageIndexNotifier = ValueNotifier(0);

    SliverWoltModalSheetPage pageHomeInformation(
        BuildContext modalSheetContext, TextTheme textTheme) {
      return WoltModalSheetPage(
        hasSabGradient: false,
        enableDrag: false,
        stickyActionBar: Padding(
          padding: const EdgeInsets.all(pagePadding),
          child: Column(
            children: [
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: CustomColors.primaryColor,
                ),
                onPressed: () =>
                    pageIndexNotifier.value = pageIndexNotifier.value + 1,
                child: SizedBox(
                  height: 56.0,
                  width: double.infinity,
                  child: Center(
                      child: Text(AppLocalizations.of(context)!.openSettings,
                          style: AppTextStyles.dialogTitle
                              .copyWith(fontSize: 20, color: Colors.white))),
                ),
              ),
            ],
          ),
        ),
        topBarTitle: Text(AppLocalizations.of(context)!.settings,
            style: AppTextStyles.dialogTitle),
        isTopBarLayerAlwaysVisible: true,
        trailingNavBarWidget: IconButton(
          padding: const EdgeInsets.all(pagePadding),
          icon: const Icon(Icons.close),
          onPressed: Navigator.of(modalSheetContext).pop,
        ),
        child: Padding(
            padding: const EdgeInsets.fromLTRB(
              pagePadding,
              pagePadding,
              pagePadding,
              100,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.information,
                  style: AppTextStyles.dialogTitle.copyWith(fontSize: 22),
                ),
                Text(
                  "${AppLocalizations.of(context)!.appVersions}: v.0.2.4-beta",
                  style: AppTextStyles.itemStyle.copyWith(fontSize: 18),
                ),
                Text(
                  "${AppLocalizations.of(context)!.developer}: @pasichDev (Noso-Project)",
                  style: AppTextStyles.itemStyle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.socialLinks,
                  style: AppTextStyles.dialogTitle.copyWith(fontSize: 22),
                ),
                Row(
                  children: [
                    IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          Assets.iconsSocDiscord,
                          width: 32,
                          height: 32,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          Assets.iconsSocTelegram,
                          width: 32,
                          height: 32,
                        )),
                    IconButton(
                        onPressed: () {},
                        icon: SvgPicture.asset(
                          Assets.iconsSocGithub,
                          width: 32,
                          height: 32,
                        )),
                  ],
                )
              ],
            )),
      );
    }

    SliverWoltModalSheetPage pageSettings(
        BuildContext modalSheetContext, TextTheme textTheme) {
      return SliverWoltModalSheetPage(
        enableDrag: false,
        leadingNavBarWidget: IconButton(
          padding: const EdgeInsets.all(pagePadding),
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () =>
              pageIndexNotifier.value = pageIndexNotifier.value - 1,
        ),
        trailingNavBarWidget: IconButton(
          padding: const EdgeInsets.all(pagePadding),
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.of(modalSheetContext).pop();
            pageIndexNotifier.value = 0;
          },
        ),
        mainContentSlivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: 1,
              (_, index) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.mainSet,
                        style: AppTextStyles.dialogTitle.copyWith(fontSize: 24),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                            AppLocalizations.of(context)!.darkTheme,
                          style: AppTextStyles.itemStyle.copyWith(fontSize: 20),
                        ),
                        trailing:
                            Switch(value: false, onChanged: (value) => {}),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          AppLocalizations.of(context)!.selLanguage,
                          style: AppTextStyles.itemStyle.copyWith(fontSize: 20),
                        ),
                      ),
                      Text(
                        AppLocalizations.of(context)!.expertSet,
                        style: AppTextStyles.dialogTitle.copyWith(fontSize: 24),
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          AppLocalizations.of(context)!.updateListSet,
                          style: AppTextStyles.walletAddress
                              .copyWith(fontSize: 20),
                        ),
                        subtitle: Text(
                          AppLocalizations.of(context)!.updateListSetSubtitle,
                          style: AppTextStyles.itemStyle.copyWith(fontSize: 16),
                        ),
                      ),

                    ],
                  )),
            ),
          )
        ],
      );
    }

    WoltModalSheet.show<void>(
      pageIndexNotifier: pageIndexNotifier,
      context: context,
      pageListBuilder: (modalSheetContext) {
        final textTheme = Theme.of(context).textTheme;
        return [
          pageHomeInformation(modalSheetContext, textTheme),
          pageSettings(modalSheetContext, textTheme),
        ];
      },
      modalTypeBuilder: (context) {
        final size = MediaQuery.of(context).size.width;
        if (size < pageBreakpoint) {
          return WoltModalType.bottomSheet;
        } else {
          return WoltModalType.dialog;
        }
      },
      onModalDismissedWithBarrierTap: () {
        debugPrint('Closed modal sheet with barrier tap');
        Navigator.of(context).pop();
        pageIndexNotifier.value = 0;
      },
      maxDialogWidth: 700,
      minDialogWidth: 500,
    );
  }
}
