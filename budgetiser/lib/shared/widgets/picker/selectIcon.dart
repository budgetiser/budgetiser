import 'package:flutter/material.dart';

class IconPicker extends StatefulWidget {
  IconPicker({Key? key, this.initialIcon, this.color}) : super(key: key);

  IconData? initialIcon;
  Color? color;

  @override
  State<IconPicker> createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  IconData selectedIcon = Icons.blur_on;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Choose an Icon"),
                  content: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: getIcons(),
                  ),
                );
              });
        },
        child: Icon(
          selectedIcon,
          color: (widget.color != null) ? widget.color : Colors.blue,
        ),
      ),
    );
    //if (widget.initialIcon != null) {
    //  return Icon(
    //  widget.initialIcon,
    // size: 30,
    // color: widget.color ?? Colors.black,
    // );
    //}
    //return const Icon(
    // Icons.account_tree,
    //size: 30,
    //);
  }

  Widget getIcons() {
    List<IconData> _icons = [
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
      Icons.speaker
    ];
    Material;
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 5,
      children: List.generate(_icons.length, (index) {
        return InkWell(
          onTap: () {
            setState(() {
              selectedIcon = _icons[index];
              Navigator.pop(context);
            });
          },
          child: Icon(_icons[index]),
        );
      }),
    );
  }
}
