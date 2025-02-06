# Number Picker

A customizable **Number Picker** package for Flutter, providing both **Horizontal** and **Vertical** number pickers with smooth scrolling and optional vibration feedback.

## Features
✅ Horizontal and Vertical pickers  
✅ Customizable styles and colors  
✅ Vibration feedback support  
✅ Supports minimum, maximum, and step values  
✅ Optional labels and arrow indicators  

## Installation
Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  number_picker: latest_version
```
Then, run:
```sh
flutter pub get
```

## Demo

| Horizontal Number Picker | Vertical Number Picker |
|-------------------------|-------------------------|
| <img src="https://raw.githubusercontent.com/AmirmahdiNourkazemi/number_picker/main/1.gif" alt="Horizontal Number Picker" width="400"> | <img src="https://raw.githubusercontent.com/AmirmahdiNourkazemi/number_picker/main/2.gif" alt="Vertical Number Picker" width="400"> |


## Usage
### Horizontal Number Picker
```dart
HorizontalNumberPicker(
  minValue: 0,
  maxValue: 100,
  step: 1,
  initialValue: 50,
  onValueChanged: (value) {
    print("Selected Value: $value");
  },
  viewPort: 0.3,
  selectedTextStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
  unselectedTextStyle: TextStyle(fontSize: 24, color: Colors.grey),
  backgroundColor: Colors.white,
  showLabel: true,
  label: "Quantity",
  showArrows: true,
  enableVibration: true,
)
```

### Vertical Number Picker
```dart
VerticalNumberPicker(
  minValue: 1,
  maxValue: 10,
  step: 1,
  initialValue: 5,
  onValueChanged: (value) {
    print("Selected Value: $value");
  },
  viewPort: 0.3,
  selectedTextStyle: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
  unselectedTextStyle: TextStyle(fontSize: 24, color: Colors.grey),
  backgroundColor: Colors.white,
  borderRadius: BorderRadius.circular(10),
  showLabel: true,
  label: "Speed",
  showArrows: true,
  enableVibration: true,
)
```

## Parameters
| Parameter | Type | Description |
|-----------|------|-------------|
| `minValue` | `int` | Minimum selectable value |
| `maxValue` | `int` | Maximum selectable value |
| `step` | `int` | Step between values |
| `initialValue` | `int` | Default selected value |
| `onValueChanged` | `ValueChanged<int>` | Callback when value changes |
| `viewPort` | `double` | Fraction of viewport occupied by picker |
| `selectedTextStyle` | `TextStyle?` | Style for selected value |
| `unselectedTextStyle` | `TextStyle?` | Style for unselected values |
| `backgroundColor` | `Color?` | Background color |
| `borderRadius` | `BorderRadius?` | Corner radius for picker background |
| `showLabel` | `bool` | Show label text below selected value |
| `label` | `String?` | Custom label text |
| `showArrows` | `bool` | Show navigation arrows |
| `arrowIcon` | `IconData?` | Custom arrow icon |
| `enableVibration` | `bool` | Enable vibration feedback |

## Contributing
Contributions are welcome! Feel free to submit a PR or open an issue.

## Contact
👤 **Amirmahdi Nourkazemi**  
[![LinkedIn](https://img.shields.io/badge/LinkedIn-Profile-blue)](https://www.linkedin.com/in/amirmahdi-nourkazemi-04613023a/)  

## License
This project is licensed under the MIT License.
