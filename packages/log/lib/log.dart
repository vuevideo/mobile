import 'package:logger/logger.dart';

/// Print descriptive and easy to read logs
final Logger log = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 10,
    colors: true,
    printEmojis: true,
    printTime: true,
  ),
);
