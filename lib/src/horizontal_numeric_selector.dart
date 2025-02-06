// lib/src/horizontal_number_picker.dart

import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class HorizontalNumericSelector extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int step;
  final int initialValue;
  final bool showLabel;
  final String? label;
  final bool showSelectedValue;
  final ValueChanged<int> onValueChanged;
  final double viewPort;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final TextStyle? labelTextStyle;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final bool showArrows;
  final IconData? arrowIcon;
  final bool enableVibration;

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
  State<HorizontalNumericSelector> createState() => _HorizontalNumericSelectorState();
}

class _HorizontalNumericSelectorState extends State<HorizontalNumericSelector> {
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
                if (widget.enableVibration && await Vibration.hasVibrator()) {
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
              const SizedBox(
                width: 5,
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
        ]
      ],
    );
  }
}
