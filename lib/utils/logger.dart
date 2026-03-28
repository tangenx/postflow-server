// ANSI color codes for console
class AnsiColor {
  static const String reset = '\x1B[0m';
  static const String red = '\x1B[31m';
  static const String green = '\x1B[32m';
  static const String yellow = '\x1B[33m';
  static const String blue = '\x1B[34m';
  static const String magenta = '\x1B[35m';
  static const String cyan = '\x1B[36m';
  static const String white = '\x1B[37m';
  static const String gray = '\x1B[90m';
}

// Logging levels
enum LogLevel {
  debug(0, 'DEBUG', AnsiColor.gray),
  info(1, 'INFO', AnsiColor.blue),
  warning(2, 'WARN', AnsiColor.yellow),
  error(3, 'ERROR', AnsiColor.red),
  fatal(4, 'FATAL', AnsiColor.magenta);

  const LogLevel(this.priority, this.name, this.color);

  final int priority;
  final String name;
  final String color;
}

// Named logger instance
class Logger {
  final String? name;

  const Logger([this.name]);

  // Shared static settings
  static LogLevel _minLevel = LogLevel.debug;
  static bool _useColor = true;

  static void setLevel(LogLevel level) {
    _minLevel = level;
  }

  static void setColorEnabled(bool enabled) {
    _useColor = enabled;
  }

  void _log(
    LogLevel level,
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    if (level.priority < _minLevel.priority) {
      return;
    }

    final time = DateTime.now();

    final timestamp =
        '${time.day}.${time.month.toString().padLeft(2, '0')}.${time.year.toString().padLeft(2, '0')} '
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}.${time.millisecond.toString().padLeft(3, '0')}';
    final levelText = level.name.padRight(5);
    final nameText = name != null
        ? ' ${AnsiColor.cyan}$name${AnsiColor.reset}'
        : '';

    String logMessage;
    if (_useColor) {
      logMessage =
          '${AnsiColor.gray}$timestamp${AnsiColor.reset} '
          '${level.color}[$levelText]${AnsiColor.reset}$nameText '
          '$message';
    } else {
      final plainName = name != null ? ' $name' : '';
      logMessage = '$timestamp [$levelText]$plainName $message';
    }

    print(logMessage);

    if (error != null) {
      final errorMessage = _useColor
          ? '${AnsiColor.red}Error: $error${AnsiColor.reset}'
          : 'Error: $error';
      print(errorMessage);
    }

    if (stackTrace != null) {
      final stackMessage = _useColor
          ? '${AnsiColor.gray}$stackTrace${AnsiColor.reset}'
          : '$stackTrace';
      print(stackMessage);
    }
  }

  void debug(String message) => _log(LogLevel.debug, message);

  void info(String message) => _log(LogLevel.info, message);

  void warning(String message) => _log(LogLevel.warning, message);

  void error(String message, [Object? error, StackTrace? stackTrace]) =>
      _log(LogLevel.error, message, error, stackTrace);

  void fatal(String message, [Object? error, StackTrace? stackTrace]) =>
      _log(LogLevel.fatal, message, error, stackTrace);

  // // Method for logging into Televerse module
  // void libLog(Object? object) => _log(LogLevel.info, object.toString());
}
