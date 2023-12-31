import 'package:logger/logger.dart';

/// Print descriptive and easy to read logs
final Logger log = new Logger(
  printer: new PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 10,
    colors: true,
    printEmojis: true,
    printTime: true,
  ),
);
