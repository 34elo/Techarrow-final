import 'dart:convert';

import 'package:chopper/chopper.dart' as chopper;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum AppSnackBarType { success, error, info }

class AppSnackBar {
  const AppSnackBar._();

  static void success(BuildContext context, String message) {
    _show(context, message, AppSnackBarType.success);
  }

  static void error(BuildContext context, String message) {
    _show(context, message, AppSnackBarType.error);
  }

  static void info(BuildContext context, String message) {
    _show(context, message, AppSnackBarType.info);
  }

  static void serverError(
    BuildContext context, {
    required String fallback,
    Object? response,
    Object? error,
  }) {
    _show(
      context,
      _serverMessage(fallback: fallback, response: response, error: error),
      AppSnackBarType.error,
    );
  }

  static void _show(
    BuildContext context,
    String message,
    AppSnackBarType type,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final (backgroundColor, foregroundColor, icon) = switch (type) {
      AppSnackBarType.success => (
        colorScheme.primaryContainer,
        colorScheme.onPrimaryContainer,
        Icons.check_circle_outline_rounded,
      ),
      AppSnackBarType.error => (
        colorScheme.errorContainer,
        colorScheme.onErrorContainer,
        Icons.error_outline_rounded,
      ),
      AppSnackBarType.info => (
        colorScheme.secondaryContainer,
        colorScheme.onSecondaryContainer,
        Icons.info_outline_rounded,
      ),
    };

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          elevation: 0,
          margin: const EdgeInsets.all(16),
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          content: Row(
            children: [
              Icon(icon, color: foregroundColor),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: foregroundColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
  }

  static String _serverMessage({
    required String fallback,
    Object? response,
    Object? error,
  }) {
    final details = _detailsFromResponse(response) ?? _detailsFromError(error);
    if (details == null || details.isEmpty) return fallback;
    return '$fallback: $details';
  }

  static String? _detailsFromResponse(Object? response) {
    if (response is chopper.Response) {
      return _detailsFromError(response.error) ??
          _detailsFromText(response.bodyString) ??
          _statusText(response.statusCode);
    }

    if (response is http.Response) {
      return _detailsFromText(response.body) ??
          _statusText(response.statusCode);
    }

    return null;
  }

  static String? _detailsFromError(Object? error) {
    if (error == null) return null;
    if (error is String) return _detailsFromText(error) ?? error;
    return _detailsFromText(error.toString()) ?? error.toString();
  }

  static String? _detailsFromText(String? text) {
    if (text == null) return null;
    final trimmed = text.trim();
    if (trimmed.isEmpty) return null;

    try {
      final decoded = jsonDecode(trimmed);
      return _detailsFromJson(decoded);
    } catch (_) {
      return trimmed.length > 180 ? '${trimmed.substring(0, 180)}...' : trimmed;
    }
  }

  static String? _detailsFromJson(Object? value) {
    if (value is Map) {
      final detail = value['detail'];
      if (detail != null) return _detailsFromJson(detail);
      final message = value['message'] ?? value['msg'] ?? value['error'];
      if (message != null) return _detailsFromJson(message);
      return value.toString();
    }

    if (value is List) {
      final messages = value
          .map(_detailsFromJson)
          .whereType<String>()
          .where((message) => message.isNotEmpty)
          .toList();
      if (messages.isEmpty) return null;
      return messages.take(3).join('; ');
    }

    if (value == null) return null;
    return value.toString();
  }

  static String? _statusText(int statusCode) {
    if (statusCode <= 0) return null;
    return 'HTTP $statusCode';
  }
}
