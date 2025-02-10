// lib/src/horizontal_number_picker.dart

import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

/// A horizontal numeric selector widget that allows users to select a number
/// within a given range by swiping left or right.
///
/// It provides options to customize the appearance, step value, and behavior,
/// including vibration feedback on selection.
class HorizontalNumericSelector extends StatefulWidget {
  /// The minimum value that can be selected.
  final int minValue;

  /// The maximum value that can be selected.
  final int maxValue;

  /// The step interval between selectable values.
  final int step;

  /// The initial value that is selected when the widget is first rendered.
  final int initialValue;

  /// Whether to show a label under the selected value.
  final bool showLabel;

  /// The label text displayed under the selected value (if enabled).
  final String? label;

  /// Whether to display the currently selected value below the selector.
  final bool showSelectedValue;

  /// Callback function triggered when the selected value changes.
  final ValueChanged<int> onValueChanged;

  /// The viewport fraction for the `PageView`, affecting how much of the next
  /// and previous values are visible.
  final double viewPort;

  /// The text style for the selected value.
  final TextStyle? selectedTextStyle;

  /// The text style for unselected values.
  final TextStyle? unselectedTextStyle;

  /// The text style for the optional label.
  final TextStyle? labelTextStyle;

  /// The background color of the numeric selector.
  final Color? backgroundColor;

  /// The border radius for rounding the edges of the selector.
  final BorderRadius? borderRadius;

  /// Whether to show navigation arrows above the selected value.
  final bool showArrows;

  /// The icon used for the navigation arrow.
  final IconData? arrowIcon;

  /// Whether to enable vibration feedback when changing values.
  final bool enableVibration;

  /// Creates a horizontal numeric selector.
  const HorizontalNumericSelector({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.step,
    required this.initialValue,
    this.showLabel = true,
    this.label,
    this.showSelectedValue = true,
    required this.onValueChanged,
    required this.viewPort,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.labelTextStyle,
    this.backgroundColor,
    this.borderRadius,
    this.showArrows = true,
    this.arrowIcon,
    this.enableVibration = true,
  });

  @override
  State<HorizontalNumericSelector> createState() =>
      _HorizontalNumericSelectorState();
}

class _HorizontalNumericSelectorState extends State<HorizontalNumericSelector> {
  /// The controller for the `PageView` that allows horizontal scrolling.
  late PageController _pageController;

  /// The currently selected numeric value.
  late int selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
    _initializePageController();
  }

  /// Initializes the `PageController` with the correct starting page.
  void _initializePageController() {
    _pageController = PageController(
      initialPage: (selectedValue - widget.minValue) ~/ widget.step,
      viewportFraction: widget.viewPort,
    );
  }

  @override
  void didUpdateWidget(covariant HorizontalNumericSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewPort != widget.viewPort) {
      _pageController.dispose();
      _initializePageController();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor ??
                Theme.of(context).colorScheme.primaryContainer,
            borderRadius: widget.borderRadius ?? BorderRadius.circular(10),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 100,
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.horizontal,
              itemCount: (widget.maxValue - widget.minValue) ~/ widget.step + 1,
              onPageChanged: (index) async {
                final newValue = widget.minValue + index * widget.step;
                if (widget.enableVibration && (await Vibration.hasVibrator())) {
                  Vibration.vibrate(duration: 30);
                }

                setState(() {
                  selectedValue = newValue;
                  widget.onValueChanged(selectedValue);
                });
              },
              itemBuilder: (context, index) {
                final value = widget.minValue + index * widget.step;
                return Center(
                  child: Text(
                    value.toString(),
                    style: selectedValue == value
                        ? widget.selectedTextStyle ??
                            Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(fontSize: 32)
                        : widget.unselectedTextStyle ??
                            Theme.of(context).textTheme.titleLarge,
                  ),
                );
              },
            ),
          ),
        ),
        if (widget.showSelectedValue) ...[
          const SizedBox(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (widget.showArrows) ...[
                Icon(
                  widget.arrowIcon ?? Icons.arrow_drop_up,
                  size: 32,
                ),
              ],
              Text(
                selectedValue.toString(),
                style: widget.selectedTextStyle ??
                    Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 32),
              ),
              const SizedBox(width: 5),
              if (widget.showLabel) ...[
                Text(
                  widget.label ?? '',
                  style: widget.unselectedTextStyle ??
                      Theme.of(context).textTheme.titleLarge,
                ),
              ]
            ],
          ),
        ]
      ],
    );
  }
}
