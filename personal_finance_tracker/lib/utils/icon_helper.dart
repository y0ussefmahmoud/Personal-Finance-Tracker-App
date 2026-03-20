import 'package:flutter/material.dart';

IconData iconFromString(String name) {
  switch (name.toLowerCase()) {
    case 'restaurant':
      return Icons.restaurant;
    case 'shopping_bag':
      return Icons.shopping_bag;
    case 'health_and_safety':
      return Icons.health_and_safety;
    case 'receipt_long':
      return Icons.receipt_long;
    case 'directions_car':
      return Icons.directions_car;
    case 'theater_comedy':
      return Icons.theater_comedy;
    case 'volunteer_activism':
      return Icons.volunteer_activism;
    case 'payments':
      return Icons.payments;
    // add all seeds e.g. local_parking, local_hospital etc.
    default:
      return Icons.category;
  }
}
