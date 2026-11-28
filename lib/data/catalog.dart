import 'package:flutter/material.dart';

/// A small visual trait that makes each buddy feel like its own character.
enum BuddyFeature { none, sprout, freckles, curl, sparkle }

class BuddySpec {
  const BuddySpec({
    required this.id,
    required this.name,
    required this.tagline,
    required this.color,
    required this.deep,
    required this.price,
    this.feature = BuddyFeature.none,
  });

  final String id;
  final String name;
  final String tagline;
  final Color color;
  final Color deep;

  /// Cost in drops. 0 means it is free from the start.
  final int price;
  final BuddyFeature feature;

  bool get isFree => price == 0;
}

const kBuddies = <BuddySpec>[
  BuddySpec(
    id: 'dewy',
    name: 'Dewy',
    tagline: 'Cool, calm, hydrated',
    color: Color(0xFF52AEFF),
    deep: Color(0xFF2478E6),
    price: 0,
  ),
  BuddySpec(
    id: 'minty',
    name: 'Minty',
    tagline: 'Fresh from the spring',
    color: Color(0xFF4FD6B4),
    deep: Color(0xFF1FA889),
    price: 0,
    feature: BuddyFeature.sprout,
  ),
  BuddySpec(
    id: 'peachy',
    name: 'Peachy',
    tagline: 'Sweet as juice',
    color: Color(0xFFFFAE85),
    deep: Color(0xFFEE7F55),
    price: 120,
    feature: BuddyFeature.freckles,
  ),
  BuddySpec(
    id: 'berry',
    name: 'Berry',
    tagline: 'A little bit fancy',
    color: Color(0xFFB79BFF),
    deep: Color(0xFF8565F0),
    price: 200,
    feature: BuddyFeature.curl,
  ),
  BuddySpec(
    id: 'goldie',
    name: 'Goldie',
    tagline: 'Legend of hydration',
    color: Color(0xFFFFD45C),
    deep: Color(0xFFF0A81C),
    price: 400,
    feature: BuddyFeature.sparkle,
  ),
];

BuddySpec buddyById(String id) =>
    kBuddies.firstWhere((b) => b.id == id, orElse: () => kBuddies.first);

enum ItemKind { accessory, decor }

class ShopItem {
  const ShopItem({
    required this.id,
    required this.name,
    required this.kind,
    required this.price,
    required this.blurb,
  });

  final String id;
  final String name;
  final ItemKind kind;
  final int price;
  final String blurb;
}

const kShopItems = <ShopItem>[
  ShopItem(
    id: 'flower',
    name: 'Daisy',
    kind: ItemKind.accessory,
    price: 40,
    blurb: 'Tucked behind an ear',
  ),
  ShopItem(
    id: 'bow',
    name: 'Bow',
    kind: ItemKind.accessory,
    price: 50,
    blurb: 'Simply adorable',
  ),
  ShopItem(
    id: 'party',
    name: 'Party hat',
    kind: ItemKind.accessory,
    price: 60,
    blurb: 'Every goal is a party',
  ),
  ShopItem(
    id: 'shades',
    name: 'Shades',
    kind: ItemKind.accessory,
    price: 80,
    blurb: 'Too cool for thirst',
  ),
  ShopItem(
    id: 'crown',
    name: 'Crown',
    kind: ItemKind.accessory,
    price: 150,
    blurb: 'Royal hydration',
  ),
  ShopItem(
    id: 'lily',
    name: 'Lily pads',
    kind: ItemKind.decor,
    price: 30,
    blurb: 'A place to rest',
  ),
  ShopItem(
    id: 'lotus',
    name: 'Lotus',
    kind: ItemKind.decor,
    price: 60,
    blurb: 'Blooms on the water',
  ),
  ShopItem(
    id: 'duck',
    name: 'Rubber duck',
    kind: ItemKind.decor,
    price: 70,
    blurb: 'Squeak squeak',
  ),
  ShopItem(
    id: 'frog',
    name: 'Frog',
    kind: ItemKind.decor,
    price: 90,
    blurb: 'Ribbit-approved',
  ),
];

ShopItem itemById(String id) => kShopItems.firstWhere((i) => i.id == id);
