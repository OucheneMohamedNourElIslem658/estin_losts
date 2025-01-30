import 'dart:math';

import 'package:flutter/material.dart';

enum SnackBarType {success, error , ideal}

class Utils {
  static String getRandomImageURL(){
    final randomIndex = Random().nextInt(100);
    final imagesWebsite = "https://picsum.photos/200/300?random=$randomIndex";
    return imagesWebsite;
  }

  static String formatDate1(DateTime date) {
    return "${date.day}${_getOrdinalSuffix(date.day)} ${_getMonthName(date.month)} - ${_getWeekDayName(date.weekday)} - ${_getTime(date)}";
  }

  static String _getOrdinalSuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  static String _getMonthName(int month) {
    switch (month) {
      case 1:
        return 'Jan';
      case 2:
        return 'Feb';
      case 3:
        return 'Mar';
      case 4:
        return 'Apr';
      case 5:
        return 'May';
      case 6:
        return 'Jun';
      case 7:
        return 'Jul';
      case 8:
        return 'Aug';
      case 9:
        return 'Sep';
      case 10:
        return 'Oct';
      case 11:
        return 'Nov';
      case 12:
        return 'Dec';
      default:
        return '';
    }
  }

  static String _getWeekDayName(int weekday) {
    switch (weekday) {
      case 1:
        return 'Sun';
      case 2:
        return 'Mon';
      case 3:
        return 'Tue';
      case 4:
        return 'Wed';
      case 5:
        return 'Thu';
      case 6:
        return 'Fri';
      case 7:
        return 'Sat';
      default:
        return '';
    }
  }

  static String _getTime(DateTime date) {
    final hour = date.hour;
    final minute = date.minute;
    final period = hour < 12 ? 'AM' : 'PM';
    final hour12 = hour % 12 == 0 ? 12 : hour % 12;
    return '$hour12:$minute $period';
  }

  static void showSnackBar(BuildContext context, String message, {
    SnackBarType type = SnackBarType.ideal 
  }) {
    switch (type) {
      case SnackBarType.success:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.green,
          ),
        );
        break;
      
      case SnackBarType.error:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: Colors.red,
          ),
        );
        break;
      default:
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
    }
  }

  static void pushScreen(BuildContext context, Widget screen) =>  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => screen
    )
  );
}