import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

/// A vertical number picker that allows users to select values by scrolling.
class VerticalNumericSelector extends StatefulWidget {
  /// The minimum selectable value.
  final int minValue;

  /// The maximum selectable value.
  final int maxValue;

  /// The step interval between selectable values.
  final int step;

  /// The initially selected value.
  final int initialValue;

  /// Whether to display the selected value.
  final bool showSelectedValue;

  /// Whether to display the label.
  final bool showLabel;

  /// The label text to display.
  final String? label;

  /// Callback function when the value changes.
  final ValueChanged<int> onValueChanged;

  /// The viewport fraction for the PageView.
  final double viewPort;

  /// The text style for the selected item.
  final TextStyle? selectedTextStyle;

  /// The text style for unselected items.
  final TextStyle? unselectedTextStyle;

  /// The background color of the picker.
  final Color? backgroundColor;

  /// The border radius of the picker.
  final BorderRadius borderRadius;

  /// Whether vibration feedback is enabled.
  final bool enableVibration;

  /// Whether to show arrows next to the selected value.
  final bool showArrows;

  /// The icon for the arrow indicator.
  final IconData? arrowIcon;

  /// The width of the picker.
  final double? width;

  /// The height of the picker.
  final double? height;

  /// Creates a vertical numeric selector widget.
  const VerticalNumericSelector({
    super.key,
    required this.minValue,
    required this.maxValue,
    required this.step,
    required this.initialValue,
    this.showLabel = true,
    this.showSelectedValue = true,
    this.label,
    required this.onValueChanged,
    required this.viewPort,
    this.selectedTextStyle,
    this.unselectedTextStyle,
    this.backgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(10)),
    this.enableVibration = true,
    this.showArrows = true,
    this.arrowIcon,
    this.width = 80,
    this.height = 200,
  });

  @override
  State<VerticalNumericSelector> createState() =>
      _VerticalNumericSelectorState();
}

class _VerticalNumericSelectorState extends State<VerticalNumericSelector> {
  late PageController _pageController;
  late int selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
    _initializePageController();
  }

  void _initializePageController() {
    _pageController = PageController(
      initialPage: (selectedValue - widget.minValue) ~/ widget.step,
      viewportFraction: widget.viewPort,
    );
  }

  @override
  void didUpdateWidget(covariant VerticalNumericSelector oldWidget) {
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
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: widget.backgroundColor ??
                    Theme.of(context).colorScheme.primaryContainer,
                borderRadius: widget.borderRadius,
              ),
              child: SizedBox(
                width: widget.width,
                height: widget.height,
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.vertical,
                  itemCount:
                      (widget.maxValue - widget.minValue) ~/ widget.step + 1,
                  onPageChanged: (index) async {
                    final newValue = widget.minValue + index * widget.step;
                    if (widget.enableVibration &&
                        (await Vibration.hasVibrator())) {
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
                      child: SizedBox(
                        width: widget.width,
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            value.toString(),
                            style: selectedValue == value
                                ? (widget.selectedTextStyle ??
                                    Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(fontSize: 32))
                                : (widget.unselectedTextStyle ??
                                    Theme.of(context).textTheme.titleLarge),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        if (widget.showSelectedValue) ...[
          const SizedBox(width: 16),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (widget.showArrows) ...[
                      Icon(
                        widget.arrowIcon ?? Icons.arrow_left,
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
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                if (widget.showLabel) ...[
                  Text(
                    widget.label ?? '',
                    style: widget.unselectedTextStyle ??
                        Theme.of(context).textTheme.titleLarge,
                  ),
                ]
              ],
            ),
          ),
        ]
      ],
    );
  }
}
