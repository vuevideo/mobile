import 'package:mobile/features/features.dart';
import 'package:flutter/widgets.dart';

List<Page<dynamic>> onGeneratedAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {
    case AppStatus.Unauthenticated:
      return [RegisterPage.page()];
    case AppStatus.Authenticated:
      return [HomePage.page()];
  }
}
