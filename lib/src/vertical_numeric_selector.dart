// lib/src/vertical_number_picker.dart

import 'package:flutter/material.dart';
import 'package:vibration/vibration.dart';

class VerticalNumericSelector extends StatefulWidget {
  final int minValue;
  final int maxValue;
  final int step;
  final int initialValue;
  final bool showSelectedValue;
  final bool showLabel;
  final String? label;
  final ValueChanged<int> onValueChanged;
  final double viewPort;
  final TextStyle? selectedTextStyle;
  final TextStyle? unselectedTextStyle;
  final Color? backgroundColor;
  final BorderRadius borderRadius;
  final bool enableVibration;
  final bool showArrows;
  final IconData? arrowIcon;
  final double? width;
  final double? height;

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
  State<VerticalNumericSelector> createState() => _VerticalNumericSelectorState();
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
                        await Vibration.hasVibrator()) {
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
