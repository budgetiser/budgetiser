import 'dart:math';

import 'package:flutter/material.dart';

class IconPicker extends StatefulWidget {
  const IconPicker({
    Key? key,
    this.initialIcon,
    required this.color,
    required this.onIconChangedCallback,
  }) : super(key: key);

  final IconData? initialIcon;
  final Color color;
  final Function(IconData) onIconChangedCallback;

  @override
  State<IconPicker> createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  IconData _currentIcon = Icons.blur_on;
  String? _searchString;
  List<IconData>? _filteredIcons;

  @override
  Widget build(BuildContext context) {
    _currentIcon = widget.initialIcon ??
        _fullIconList.elementAt(Random().nextInt(_fullIconList.length))["icon"];

    Future(_executeAfterBuild);
    return SizedBox(
      child: InkWell(
        onTap: () {
          _searchString = null;
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(builder: (context, setState) {
                  return SimpleDialog(
                    elevation: 0,
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          hintText: "Search",
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (String value) {
                          setState(() {
                            _searchString = value;
                          });
                        },
                      ),
                      getIcons(),
                    ],
                  );
                });
              });
        },
        child: Icon(
          _currentIcon,
          color: widget.color,
        ),
      ),
    );
  }

  Widget getIcons() {
    List<IconData> filteredIcons = [];
    for (var element in _fullIconList) {
      if (element["name"].toLowerCase().contains(_searchString ?? "")) {
        filteredIcons.add(element["icon"]);
      }
    }
    return SizedBox(
      height: 500,
      width: double.maxFinite,
      child: GridView.count(
        physics: const ScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 5,
        children: List.generate(filteredIcons.length, (index) {
          return InkWell(
            onTap: () {
              setState(() {
                _currentIcon = filteredIcons[index];
                widget.onIconChangedCallback(filteredIcons[index]);
                Navigator.pop(context);
              });
            },
            child: Icon(
              filteredIcons[index],
              color: widget.color,
            ),
          );
        }),
      ),
    );
  }

  /// executes after build is done by being called in a Future() from the build() method
  Future<void> _executeAfterBuild() async {
    widget.onIconChangedCallback(_currentIcon);
  }

  final List<Map<String, dynamic>> _fullIconList = [
    {
      'name': 'Home',
      'icon': Icons.home,
    },
    {
      'name': 'Shopping cart',
      'icon': Icons.shopping_cart,
    },
    {
      'name': 'date calendar',
      'icon': Icons.date_range,
    },
    {
      'name': 'music note',
      'icon': Icons.music_note,
    },
    {
      'name': 'bakery ',
      'icon': Icons.bakery_dining,
    },
    {
      'name': 'church',
      'icon': Icons.church,
    },
    {
      'name': 'phone',
      'icon': Icons.phone,
    },
    {
      'name': 'phone android',
      'icon': Icons.phone_android,
    },
    {
      'name': 'kitchen fridge',
      'icon': Icons.kitchen,
    },
    {
      'name': 'vaping',
      'icon': Icons.vaping_rooms,
    },
    {
      'name': 'chair',
      'icon': Icons.chair,
    },
    {
      'name': 'garage car',
      'icon': Icons.garage,
    },
    {
      'name': 'Sports',
      'icon': Icons.sports,
    },
    {
      'name': 'Sports Baseball',
      'icon': Icons.sports_baseball,
    },
    {
      'name': 'Sports Basketball',
      'icon': Icons.sports_basketball,
    },
    {
      'name': 'Sports Cricket',
      'icon': Icons.sports_cricket,
    },
    {
      'name': 'Sports Esports',
      'icon': Icons.sports_esports,
    },
    {
      'name': 'Sports Football',
      'icon': Icons.sports_football,
    },
    {
      'name': 'Sports Golf',
      'icon': Icons.sports_golf,
    },
    {
      'name': 'Sports Handball',
      'icon': Icons.sports_handball,
    },
    {
      'name': 'Sports Hockey',
      'icon': Icons.sports_hockey,
    },
    {
      'name': 'access_alarm',
      'icon': Icons.access_alarm,
    },
    {
      'name': 'ac_unit',
      'icon': Icons.ac_unit,
    },
    {
      'name': 'access_time',
      'icon': Icons.access_time,
    },
    {
      'name': 'accessibility',
      'icon': Icons.accessibility,
    },
    {
      'name': 'accessible',
      'icon': Icons.accessible,
    },
    {
      'name': 'account_balance',
      'icon': Icons.account_balance,
    },
    {
      'name': 'account_balance_wallet',
      'icon': Icons.account_balance_wallet,
    },
    {
      'name': 'account_box',
      'icon': Icons.account_box,
    },
    {
      'name': 'adb',
      'icon': Icons.adb,
    },
    {
      'name': 'airline_seat_individual_suite',
      'icon': Icons.airline_seat_individual_suite,
    },
    {
      'name': 'airport_shuttle',
      'icon': Icons.airport_shuttle,
    },
    {
      'name': 'airplanemode_active',
      'icon': Icons.airplanemode_active,
    },
    {
      'name': 'arrow_downward',
      'icon': Icons.arrow_downward,
    },
    {
      'name': 'arrow_forward',
      'icon': Icons.arrow_forward,
    },
    {
      'name': 'arrow_upward',
      'icon': Icons.arrow_upward,
    },
    {
      'name': 'arrow_back',
      'icon': Icons.arrow_back,
    },
    {
      'name': 'attach_money',
      'icon': Icons.attach_money,
    },
    {
      'name': 'audiotrack',
      'icon': Icons.audiotrack,
    },
    {
      'name': 'cake',
      'icon': Icons.cake,
    },
    {
      'name': 'business_center',
      'icon': Icons.business_center,
    },
    {
      'name': 'camera_alt',
      'icon': Icons.camera_alt,
    },
    {
      'name': 'card_giftcard',
      'icon': Icons.card_giftcard,
    },
    {
      'name': 'casino',
      'icon': Icons.casino,
    },
    {
      'name': 'child_friendly',
      'icon': Icons.child_friendly,
    },
    {
      'name': 'color_lens',
      'icon': Icons.color_lens,
    },
    {
      'name': 'directions_bus',
      'icon': Icons.directions_bus,
    },
    {
      'name': 'directions_bike',
      'icon': Icons.directions_bike,
    },
    {
      'name': 'directions_boat',
      'icon': Icons.directions_boat,
    },
    {
      'name': 'directions_transit',
      'icon': Icons.directions_transit,
    },
    {
      'name': 'ev_station',
      'icon': Icons.ev_station,
    },
    {
      'name': 'favorite',
      'icon': Icons.favorite,
    },
    {
      'name': 'fitness_center',
      'icon': Icons.fitness_center,
    },
    {
      'name': 'flight_takeoff',
      'icon': Icons.flight_takeoff,
    },
    {
      'name': 'free_breakfast',
      'icon': Icons.free_breakfast,
    },
    {
      'name': 'gavel',
      'icon': Icons.gavel,
    },
    {
      'name': 'golf_course',
      'icon': Icons.golf_course,
    },
    {
      'name': 'group',
      'icon': Icons.group,
    },
    {
      'name': 'headset_mic',
      'icon': Icons.headset_mic,
    },
    {
      'name': 'healing',
      'icon': Icons.healing,
    },
    {
      'name': 'hot_tub',
      'icon': Icons.hot_tub,
    },
    {
      'name': 'import_export',
      'icon': Icons.import_export,
    },
    {
      'name': 'local_gas_station',
      'icon': Icons.local_gas_station,
    },
    {
      'name': 'local_florist',
      'icon': Icons.local_florist,
    },
    {
      'name': 'local_bar',
      'icon': Icons.local_bar,
    },
    {
      'name': 'local_convenience_store',
      'icon': Icons.local_convenience_store,
    },
    {
      'name': 'local_dining',
      'icon': Icons.local_dining,
    },
    {
      'name': 'local_grocery_store',
      'icon': Icons.local_grocery_store,
    },
    {
      'name': 'motorcycle',
      'icon': Icons.motorcycle,
    },
    {
      'name': 'markunread_mailbox',
      'icon': Icons.markunread_mailbox,
    },
    {
      'name': 'movie',
      'icon': Icons.movie,
    },
    {
      'name': 'pets',
      'icon': Icons.pets,
    },
    {
      'name': 'pool',
      'icon': Icons.pool,
    },
    {
      'name': 'redeem',
      'icon': Icons.redeem,
    },
    {
      'name': 'public',
      'icon': Icons.public,
    },
    {
      'name': 'restaurant',
      'icon': Icons.restaurant,
    },
    {
      'name': 'router',
      'icon': Icons.router,
    },
    {
      'name': 'speaker',
      'icon': Icons.speaker,
    },
    {
      'name': 'star',
      'icon': Icons.star,
    },
    {
      'name': 'store',
      'icon': Icons.store,
    },
    {
      'name': 'subtitles',
      'icon': Icons.subtitles,
    },
    {
      'name': 'surround_sound',
      'icon': Icons.surround_sound,
    },
    {
      'name': 'swap_calls',
      'icon': Icons.swap_calls,
    },
    {
      'name': 'thumb_down',
      'icon': Icons.thumb_down,
    },
    {
      'name': 'thumb_up',
      'icon': Icons.thumb_up,
    },
    {
      'name': 'thumbs_up_down',
      'icon': Icons.thumbs_up_down,
    },
    {
      'name': 'train',
      'icon': Icons.train,
    },
    {
      'name': 'tram',
      'icon': Icons.tram,
    },
    {
      'name': 'toys',
      'icon': Icons.toys,
    },
    {
      'name': 'videogame_asset',
      'icon': Icons.videogame_asset,
    },
    {
      'name': 'videocam',
      'icon': Icons.videocam,
    },
    {
      'name': 'watch',
      'icon': Icons.watch,
    },
    {
      'name': 'wifi',
      'icon': Icons.wifi,
    },
    {
      'name': 'work',
      'icon': Icons.work,
    },
    {
      'name': 'wysiwyg',
      'icon': Icons.wysiwyg,
    },
    {
      'name': 'add',
      'icon': Icons.add,
    },
    {
      'name': 'add_a_photo',
      'icon': Icons.add_a_photo,
    },
    {
      'name': 'location_city',
      'icon': Icons.location_city,
    },
    {
      'name': 'add_to_home_screen',
      'icon': Icons.add_to_home_screen,
    },
    {
      'name': 'add_to_photos',
      'icon': Icons.add_to_photos,
    },
    {
      'name': 'add_to_queue',
      'icon': Icons.add_to_queue,
    },
    {
      'name': 'adjust',
      'icon': Icons.adjust,
    },
    {
      'name': 'airplay',
      'icon': Icons.airplay,
    },
    {
      'name': 'airport_shuttle',
      'icon': Icons.airport_shuttle,
    },
    {
      'name': 'album',
      'icon': Icons.album,
    },
    {
      'name': 'all_inclusive',
      'icon': Icons.all_inclusive,
    },
    {
      'name': 'all_out',
      'icon': Icons.all_out,
    },
    {
      'name': 'android',
      'icon': Icons.android,
    },
    {
      'name': 'announcement',
      'icon': Icons.announcement,
    },
    {
      'name': 'apps',
      'icon': Icons.apps,
    },
    {
      'name': 'archive',
      'icon': Icons.archive,
    },
    {
      'name': 'art_track',
      'icon': Icons.art_track,
    },
    {
      'name': 'home',
      'icon': Icons.home,
    },
    {
      'name': 'paid',
      'icon': Icons.paid,
    },
    {
      'name': 'school',
      'icon': Icons.school,
    },
    {
      'name': 'savings',
      'icon': Icons.savings,
    },
    {
      'name': 'hiking',
      'icon': Icons.hiking,
    },
    {
      'name': 'cloud',
      'icon': Icons.cloud,
    },
  ];
}
