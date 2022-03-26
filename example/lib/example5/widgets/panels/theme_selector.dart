import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../../../shared/const/app_data.dart';
import '../../../shared/controllers/theme_controller.dart';
import '../../../shared/widgets/universal/header_card.dart';
import '../../../shared/widgets/universal/switch_list_tile_adaptive.dart';
import 'input_colors/input_colors_selector.dart';

// ThemeSelectorHeaderDelegate for our custom SliverPersistentHeader.
//
// Used to keep a part of our nested scroll view pinned to the top
// (in tablet desktop view), and floating on phone and snapping
// back when scrolling back just a bit.
class ThemeSelectorHeaderDelegate extends SliverPersistentHeaderDelegate {
  ThemeSelectorHeaderDelegate({
    required this.vsync,
    required this.extent,
    required this.controller,
    required this.previousTheme,
  });
  @override
  final TickerProvider vsync;
  final double extent;
  final ThemeController controller;
  final int previousTheme;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return ThemeSelector(
      controller: controller,
    );
  }

  @override
  double get maxExtent => extent;

  @override
  double get minExtent => extent;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return oldDelegate.maxExtent != maxExtent ||
        oldDelegate.minExtent != minExtent ||
        previousTheme != controller.schemeIndex;
  }

  @override
  FloatingHeaderSnapConfiguration? get snapConfiguration =>
      FloatingHeaderSnapConfiguration();
}

// A header card wrapped, without heading. Used to select them colors using
// the Theme Selector and can also turn ON/OFF FlexColorScheme and component
// themes.
//
// Used at the top of the Masonry grid view and between page and panel page
// selector on the page view.
class ThemeSelector extends StatelessWidget {
  const ThemeSelector({Key? key, required this.controller}) : super(key: key);

  final ThemeController controller;

  @override
  Widget build(BuildContext context) {
    final MediaQueryData media = MediaQuery.of(context);
    final bool isPhone = media.size.width < AppData.phoneBreakpoint;
    final double margins = AppData.responsiveInsets(media.size.width);

    return HeaderCard(
      margin: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, margins, 0, 0),
            child: InputColorsSelector(controller: controller),
          ),
          Row(children: <Widget>[
            Expanded(
              child: SwitchListTileAdaptive(
                contentPadding: isPhone
                    ? const EdgeInsetsDirectional.only(start: 16, end: 0)
                    : null,
                title: const Text('Flex\u200BColor\u200BScheme'),
                dense: isPhone,
                value: controller.useFlexColorScheme,
                onChanged: controller.setUseFlexColorScheme,
              ),
            ),
            Expanded(
              child: SwitchListTileAdaptive(
                contentPadding:
                    isPhone ? const EdgeInsets.symmetric(horizontal: 8) : null,
                dense: isPhone,
                title: const Text('Compo\u200Bnent themes'),
                value: controller.useSubThemes && controller.useFlexColorScheme,
                onChanged: controller.useFlexColorScheme
                    ? controller.setUseSubThemes
                    : null,
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
