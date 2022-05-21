import 'dart:math';

import 'package:flutter/material.dart';

class IconPicker extends StatefulWidget {
  IconPicker({
    Key? key,
    this.initialIcon,
    required this.color,
    required this.onIconChangedCallback,
  }) : super(key: key);

  IconData? initialIcon;
  final Color color;
  Function(IconData) onIconChangedCallback;

  @override
  State<IconPicker> createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  IconData _currentIcon = Icons.blur_on;

  @override
  Widget build(BuildContext context) {
    _currentIcon =
        widget.initialIcon ?? _icons.elementAt(Random().nextInt(_icons.length));

    Future(_executeAfterBuild);
    return SizedBox(
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  // title: const Text("Choose an Icon"),
                  child: getIcons(),
                );
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
    return GridView.count(
      physics: const ScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 5,
      children: List.generate(_icons.length, (index) {
        return InkWell(
          onTap: () {
            setState(() {
              _currentIcon = _icons[index];
              widget.onIconChangedCallback(_icons[index]);
              Navigator.pop(context);
            });
          },
          child: Icon(
            _icons[index],
            color: widget.color,
          ),
        );
      }),
    );
  }

  /// executes after build is done by being called in a Future() from the build() method
  Future<void> _executeAfterBuild() async {
    widget.onIconChangedCallback(_currentIcon);
  }

  final List<IconData> _icons = [
    Icons.access_alarm,
    Icons.ac_unit,
    Icons.access_time,
    Icons.accessibility,
    Icons.accessible,
    Icons.account_balance,
    Icons.account_balance_wallet,
    Icons.account_box,
    Icons.adb,
    Icons.airline_seat_individual_suite,
    Icons.airport_shuttle,
    Icons.airplanemode_active,
    Icons.arrow_downward,
    Icons.arrow_forward,
    Icons.arrow_upward,
    Icons.arrow_back,
    Icons.attach_money,
    Icons.audiotrack,
    Icons.cake,
    Icons.business_center,
    Icons.camera_alt,
    Icons.card_giftcard,
    Icons.casino,
    Icons.child_friendly,
    Icons.color_lens,
    Icons.directions_bus,
    Icons.directions_bike,
    Icons.directions_boat,
    Icons.directions_transit,
    Icons.ev_station,
    Icons.favorite,
    Icons.fitness_center,
    Icons.flight_takeoff,
    Icons.free_breakfast,
    Icons.gavel,
    Icons.golf_course,
    Icons.group,
    Icons.headset_mic,
    Icons.healing,
    Icons.hot_tub,
    Icons.import_export,
    Icons.local_gas_station,
    Icons.local_florist,
    Icons.local_bar,
    Icons.local_convenience_store,
    Icons.local_dining,
    Icons.local_grocery_store,
    Icons.motorcycle,
    Icons.markunread_mailbox,
    Icons.movie,
    Icons.pets,
    Icons.pool,
    Icons.redeem,
    Icons.public,
    Icons.restaurant,
    Icons.router,
    Icons.speaker,
    Icons.star,
    Icons.store,
    Icons.subtitles,
    Icons.surround_sound,
    Icons.swap_calls,
    Icons.thumb_down,
    Icons.thumb_up,
    Icons.thumbs_up_down,
    Icons.train,
    Icons.tram,
    Icons.toys,
    Icons.videogame_asset,
    Icons.videocam,
    Icons.watch,
    Icons.wifi,
    Icons.work,
    Icons.wysiwyg,
    Icons.add,
    Icons.add_a_photo,
    Icons.add_alarm,
    Icons.add_circle,
    Icons.add_circle_outline,
    Icons.location_city,
    Icons.add_to_home_screen,
    Icons.add_to_photos,
    Icons.add_to_queue,
    Icons.adjust,
    Icons.airplay,
    Icons.airport_shuttle,
    Icons.alarm,
    Icons.album,
    Icons.all_inclusive,
    Icons.all_out,
    Icons.android,
    Icons.announcement,
    Icons.apps,
    Icons.archive,
    Icons.art_track,
    Icons.home,
    Icons.group,
    Icons.paid,
    Icons.school,
    Icons.savings,
    Icons.hiking,
    Icons.cloud,
  ];
}
