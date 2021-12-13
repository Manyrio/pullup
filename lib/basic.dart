import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

String BACKEND_HOST = 'http://localhost:3000';

String getDifference(DateTime time) {
  if (time == null) return "";

  String date;
  Duration dif = DateTime.now().difference(time);
  if (dif.inMinutes < 0) {
    dif = dif.abs();
    if (dif.inMinutes >= 0 && dif.inMinutes < 1) {
      date = "à l'instant";
    } else if (dif.inMinutes < 60) {
      date = "dans ${dif.inMinutes} min";
    } else if (dif.inHours < 24) {
      date = "dans ${dif.inHours} heures";
    } else {
      date = "dans ${dif.inDays} jours";
    }
  } else if (dif.inMinutes >= 0 && dif.inMinutes < 1) {
    date = "à l'instant";
  } else if (dif.inMinutes < 60) {
    date = "il y a ${dif.inMinutes} min";
  } else if (dif.inHours < 24) {
    date = "il y a ${dif.inHours} heures";
  } else {
    date = "il y a ${dif.inDays} jours";
  }
  return date;
}

String getDifferenceNoText(DateTime time) {
  if (time == null) return "";

  String date;
  Duration dif = DateTime.now().difference(time);
  if (dif.inMinutes < 0) {
    dif = dif.abs();
    if (dif.inMinutes >= 0 && dif.inMinutes < 1) {
      date = "à l'instant";
    } else if (dif.inMinutes < 60) {
      date = "${dif.inMinutes} min";
    } else if (dif.inHours < 24) {
      date = "${dif.inHours} heures";
    } else {
      date = "${dif.inDays} jours";
    }
  } else if (dif.inMinutes >= 0 && dif.inMinutes < 1) {
    date = "à l'instant";
  } else if (dif.inMinutes < 60) {
    date = "${dif.inMinutes} min";
  } else if (dif.inHours < 24) {
    date = "${dif.inHours} heures";
  } else {
    date = "${dif.inDays} jours";
  }
  return date;
}