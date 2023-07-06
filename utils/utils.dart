// ignore_for_file: file_names, non_constant_identifier_names, sized_box_for_whitespace, unused_local_variable

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import "package:collection/collection.dart";

abstract class UtilsBehavior {
  static void showCircularIndicator(context) {
    showDialog(
      barrierDismissible: false,
      barrierColor: Colors.blueGrey.withAlpha(100),
      builder: (ctx) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: const Center(child: CircularProgressIndicator()),
        );
      },
      context: context,
    );
  }

  static void hideCircularIndocator(context) {
    Navigator.of(context).pop();
  }

  static formatCurrency(montant) {
    var formatter = NumberFormat('#,###');
    String amount = '0.0';
    if (montant != '') {
      amount = montant;
    }

    return (formatter
            .format(double.parse(amount.toString()))
            .replaceAll(',', ' '))
        .toString();
  }

  static formatDateFr(dateStr) {
    if (dateStr.toString() == '') {
      return '';
    }
    initializeDateFormatting();
    DateTime date = DateTime.parse(dateStr);
    var formatter = DateFormat('dd-MM-yyyy');
    String formattedDate = formatter.format(date);
    return formattedDate;
  }

  static showImageStr(StringImage) {
    if (StringImage != null && StringImage != '') {
      return Container(
        height: 100,
        width: 100,
        child: Image.memory(
          base64Decode(StringImage),
        ),
      );
    }
    return Container(
      height: 100,
      width: 100,
      child: const Text(
        '',
      ),
    );
  }

  static showImageStrList(StringImage) {
    if (StringImage != null && StringImage != '') {
      return Container(
        height: 60,
        // width: 100,
        child: Image.memory(
          base64Decode(StringImage),
        ),
      );
    }
    return Container(
      height: 60,
      // width: 100,
      child: const Text(
        '',
      ),
    );
  }

  static int generateRandomInt(int max) {
    Random random = Random();
    return random.nextInt(max);
  }

  static Map<String, String> createJsonObject(String subv, String cible) {
    return {
      'sub_id': subv,
      'cible_id': cible,
    };
  }

  static List<Map<String, dynamic>> groupJsonList(
      List<Map<String, dynamic>> jsonList, String field) {
    final groupByField = groupBy(jsonList, (obj) => obj[field]);

    final groupedJsonList = <Map<String, dynamic>>[];

    groupByField.forEach((key, value) {
      final group = {
        field: key,
        'data': value,
      };

      groupedJsonList.add(group);
    });

    return groupedJsonList;
  }
}
