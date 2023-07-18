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
  IconData? _currentIcon;
  String? _searchString;

  @override
  Widget build(BuildContext context) {
    _currentIcon = widget.initialIcon ?? Icons.blur_on;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: InkWell(
        onTap: () {
          _searchString = null;
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return StatefulBuilder(builder: (context, setState) {
                  return SimpleDialog(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                            hintText: 'Search',
                            prefixIcon: Icon(
                              Icons.search,
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                            hintStyle: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary)),
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
          size: 48,
          _currentIcon,
          color: widget.color,
        ),
      ),
    );
  }

  Widget getIcons() {
    List<IconData> filteredIcons = [];
    for (Map<String, dynamic> element in _fullIconList) {
      // ignore: avoid_dynamic_calls
      if (element['name'].contains(
          _searchString != null ? _searchString!.toLowerCase() : '')) {
        filteredIcons.add(element['icon']);
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

  final List<Map<String, dynamic>> _fullIconList = [
    {
      'name': 'home',
      'icon': Icons.home,
    },
    {
      'name': 'shopping cart',
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
      'name': 'bakery food',
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
      'name': 'sports',
      'icon': Icons.sports,
    },
    {
      'name': 'sports Baseball',
      'icon': Icons.sports_baseball,
    },
    {
      'name': 'sports Basketball',
      'icon': Icons.sports_basketball,
    },
    {
      'name': 'sports Cricket',
      'icon': Icons.sports_cricket,
    },
    {
      'name': 'sports esports controller game',
      'icon': Icons.sports_esports,
    },
    {
      'name': 'sports football',
      'icon': Icons.sports_football,
    },
    {
      'name': 'sports golf',
      'icon': Icons.sports_golf,
    },
    {
      'name': 'sports handball',
      'icon': Icons.sports_handball,
    },
    {
      'name': 'sports hockey',
      'icon': Icons.sports_hockey,
    },
    {
      'name': 'alarm clock',
      'icon': Icons.access_alarm,
    },
    {
      'name': 'ac_unit snow',
      'icon': Icons.ac_unit,
    },
    {
      'name': 'time clock',
      'icon': Icons.access_time,
    },
    {
      'name': 'accessibility human',
      'icon': Icons.accessibility,
    },
    {
      'name': 'accessible',
      'icon': Icons.accessible,
    },
    {
      'name': 'account_balance bank',
      'icon': Icons.account_balance,
    },
    {
      'name': 'account_balance_wallet',
      'icon': Icons.account_balance_wallet,
    },
    {
      'name': 'account_box user',
      'icon': Icons.account_box,
    },
    {
      'name': 'adb',
      'icon': Icons.adb,
    },
    {
      'name': 'airline_seat_individual_suite bed sleep',
      'icon': Icons.airline_seat_individual_suite,
    },
    {
      'name': 'airport_shuttle bus',
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
      'name': 'audiotrack music',
      'icon': Icons.audiotrack,
    },
    {
      'name': 'cake food',
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
      'name': 'directions_transit train',
      'icon': Icons.directions_transit,
    },
    {
      'name': 'ev_station car',
      'icon': Icons.ev_station,
    },
    {
      'name': 'favorite heart',
      'icon': Icons.favorite,
    },
    {
      'name': 'fitness_center sport',
      'icon': Icons.fitness_center,
    },
    {
      'name': 'flight_takeoff airplane',
      'icon': Icons.flight_takeoff,
    },
    {
      'name': 'free_breakfast coffee tea',
      'icon': Icons.free_breakfast,
    },
    {
      'name': 'gavel hammer',
      'icon': Icons.gavel,
    },
    {
      'name': 'golf_course',
      'icon': Icons.golf_course,
    },
    {
      'name': 'group people',
      'icon': Icons.group,
    },
    {
      'name': 'headset_mic microphone music',
      'icon': Icons.headset_mic,
    },
    {
      'name': 'healing medical doctor',
      'icon': Icons.healing,
    },
    {
      'name': 'hot_tub',
      'icon': Icons.hot_tub,
    },
    {
      'name': 'import_export arrow',
      'icon': Icons.import_export,
    },
    {
      'name': 'local_gas_station car',
      'icon': Icons.local_gas_station,
    },
    {
      'name': 'local_florist',
      'icon': Icons.local_florist,
    },
    {
      'name': 'local_bar drink alcohol',
      'icon': Icons.local_bar,
    },
    {
      'name': 'local_convenience_store',
      'icon': Icons.local_convenience_store,
    },
    {
      'name': 'local_dining food',
      'icon': Icons.local_dining,
    },
    {
      'name': 'local_grocery_store food',
      'icon': Icons.local_grocery_store,
    },
    {
      'name': 'motorcycle bike',
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
      'name': 'pets dog cat animal',
      'icon': Icons.pets,
    },
    {
      'name': 'pool swim',
      'icon': Icons.pool,
    },
    {
      'name': 'redeem',
      'icon': Icons.redeem,
    },
    {
      'name': 'public world globe',
      'icon': Icons.public,
    },
    {
      'name': 'restaurant food',
      'icon': Icons.restaurant,
    },
    {
      'name': 'router',
      'icon': Icons.router,
    },
    {
      'name': 'speaker music audio',
      'icon': Icons.speaker,
    },
    {
      'name': 'star favorite',
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
      'name': 'swap_calls arrow',
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
      'name': 'videogame_asset game controller',
      'icon': Icons.videogame_asset,
    },
    {
      'name': 'videocam camera',
      'icon': Icons.videocam,
    },
    {
      'name': 'watch clock time smartwatch',
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
      'name': 'add_a_photo camera',
      'icon': Icons.add_a_photo,
    },
    {
      'name': 'location_city building house',
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
      'name': 'album',
      'icon': Icons.album,
    },
    {
      'name': 'all_inclusive infinite',
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
      'name': 'home house building',
      'icon': Icons.home,
    },
    {
      'name': 'paid account money',
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
      'name': 'hiking sport',
      'icon': Icons.hiking,
    },
    {
      'name': 'cloud',
      'icon': Icons.cloud,
    },
    {
      'name': 'code arrow',
      'icon': Icons.code,
    },
    {
      'name': 'collections image photo',
      'icon': Icons.collections,
    },
    {
      'name': 'collections_bookmark',
      'icon': Icons.collections_bookmark,
    },
    {
      'name': 'computer work laptop',
      'icon': Icons.computer,
    },
    {
      'name': 'delete bin trash',
      'icon': Icons.delete,
    },
    {
      'name': 'description',
      'icon': Icons.description,
    },
    {
      'name': 'desktop_mac pc',
      'icon': Icons.desktop_mac,
    },
  ];
}
