import 'package:flutter/material.dart';

class ReviewCheckResponse {

  final bool reviewCheck;

  ReviewCheckResponse({required this.reviewCheck});

  factory ReviewCheckResponse.from(Map<String, dynamic> json) {
    return ReviewCheckResponse(
      reviewCheck: json['reviewCheck'] as bool,
    );
  }
}