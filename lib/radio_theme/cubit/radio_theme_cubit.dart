import 'package:appainter/color_theme/color_theme.dart';
import 'package:bloc/bloc.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:appainter/services/services.dart';
import 'package:appainter/utils/utils.dart';

part 'radio_theme_cubit.g.dart';
part 'radio_theme_state.dart';

class RadioThemeCubit extends Cubit<RadioThemeState> {
  final ColorThemeCubit colorThemeCubit;

  RadioThemeCubit({required this.colorThemeCubit})
      : super(const RadioThemeState());

  final _utils = const SelectionUtils();

  void themeChanged(RadioThemeData theme) => emit(state.copyWith(theme: theme));

  void fillDefaultColorChanged(Color color) {
    _emitWithNewFillColor(defaultColor: color);
  }

  void fillSelectedColorChanged(Color color) {
    _emitWithNewFillColor(selectedColor: color);
  }

  void fillDisabledColorChanged(Color color) {
    _emitWithNewFillColor(disabledColor: color);
  }

  void overlayPressedColorChanged(Color color) {
    _emitWithNewOverlayColor(pressedColor: color);
  }

  void overlayHoveredColorChanged(Color color) {
    _emitWithNewOverlayColor(hoveredColor: color);
  }

  void overlayFocusedColorChanged(Color color) {
    _emitWithNewOverlayColor(focusedColor: color);
  }

  void materialTapTargetSize(String value) {
    final size = UtilService.stringToEnum(MaterialTapTargetSize.values, value);
    if (size != null) {
      final theme = state.theme.copyWith(materialTapTargetSize: size);
      emit(state.copyWith(theme: theme));
    }
  }

  void splashRadiusChanged(String value) {
    final radius = double.tryParse(value);
    if (radius != null) {
      final theme = state.theme.copyWith(splashRadius: radius);
      emit(state.copyWith(theme: theme));
    }
  }

  void _emitWithNewFillColor({
    Color? defaultColor,
    Color? selectedColor,
    Color? disabledColor,
  }) {
    final color = _utils.getBasicColor(
      state.theme.fillColor ?? _defaultFillColor,
      defaultColor: defaultColor,
      selectedColor: selectedColor,
      disabledColor: disabledColor,
    );
    final theme = state.theme.copyWith(fillColor: color);
    emit(state.copyWith(theme: theme));
  }

  void _emitWithNewOverlayColor({
    Color? pressedColor,
    Color? hoveredColor,
    Color? focusedColor,
  }) {
    final color = _utils.getOverlayColor(
      state.theme.overlayColor ?? _defaultOverlayColor,
      pressedColor: pressedColor,
      hoveredColor: hoveredColor,
      focusedColor: focusedColor,
    );
    final theme = state.theme.copyWith(overlayColor: color);
    emit(state.copyWith(theme: theme));
  }

  MaterialStateProperty<Color> get _defaultFillColor {
    final colorThemeState = colorThemeCubit.state;
    return MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.disabled)) {
        return colorThemeState.disabledColor;
      }
      if (states.contains(MaterialState.selected)) {
        return colorThemeState.toggleableActiveColor;
      }
      return colorThemeState.unselectedWidgetColor;
    });
  }

  MaterialStateProperty<Color?> get _defaultOverlayColor {
    final colorThemeState = colorThemeCubit.state;
    return MaterialStateProperty.resolveWith((states) {
      if (states.contains(MaterialState.pressed)) {
        return colorThemeState.toggleableActiveColor.withAlpha(
          kRadialReactionAlpha,
        );
      }
      if (states.contains(MaterialState.hovered)) {
        return colorThemeState.hoverColor;
      }
      if (states.contains(MaterialState.focused)) {
        return colorThemeState.focusColor;
      }
      return null;
    });
  }
}
