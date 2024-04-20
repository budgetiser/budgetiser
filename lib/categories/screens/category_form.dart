import 'dart:math';

import 'package:budgetiser/core/database/models/category.dart';
import 'package:budgetiser/core/database/provider/category_provider.dart';
import 'package:budgetiser/shared/utils/color_utils.dart';
import 'package:budgetiser/shared/utils/data_types_utils.dart';
import 'package:budgetiser/shared/widgets/actionButtons/cancel_action_button.dart';
import 'package:budgetiser/shared/widgets/forms/screen_forms.dart';
import 'package:budgetiser/shared/widgets/picker/color_picker.dart';
import 'package:budgetiser/shared/widgets/picker/icon_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryForm extends StatefulWidget {
  const CategoryForm({
    super.key,
    this.categoryData,
  });
  final TransactionCategory? categoryData;

  @override
  State<CategoryForm> createState() => _CategoryFormState();
}

class _CategoryFormState extends State<CategoryForm> {
  var nameController = TextEditingController();
  var descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Color _color = randomColor();
  IconData? _icon;

  double maxHeaderHeight = 200;
  late ScrollController _scrollController;
  final ValueNotifier<double> opacity = ValueNotifier(0);

  @override
  void initState() {
    if (widget.categoryData != null) {
      nameController.text = widget.categoryData!.name;
      descriptionController.text = widget.categoryData!.description ?? '';
      _color = widget.categoryData!.color;
      _icon = widget.categoryData!.icon;
    }
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(scrollListener);
  }

  scrollListener() {
    if (maxHeaderHeight > _scrollController.offset &&
        _scrollController.offset > 1) {
      opacity.value = 1 - _scrollController.offset / maxHeaderHeight;
    } else if (_scrollController.offset > maxHeaderHeight &&
        opacity.value != 1) {
      opacity.value = 0;
    } else if (_scrollController.offset < 0 && opacity.value != 0) {
      opacity.value = 1;
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBody: true, // make body visible throughout other widgets
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: DemoHeader(
                minHeight: 100,
                maxHeight: 200,
                child: Container(
                  color: Colors.red,
                )),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: PersistentHeader(),
          ),
          SliverFillRemaining(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // CategoryHeader(),
                  TextFormField(
                    autofocus: true,
                    scrollPadding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    controller: nameController,
                    validator: (data) {
                      if (data == null || data.trim() == '') {
                        nameController.text = '';
                        return '';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  TextFormField(
                    scrollPadding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom,
                    ),
                    controller: descriptionController,
                    keyboardType: TextInputType.multiline,
                    minLines: 120,
                    maxLines: 120,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Description',
                      alignLabelWithHint: true,
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          CancelActionButton(
            isDeletion: widget.categoryData != null,
            onSubmitCallback: () {
              Provider.of<CategoryModel>(context, listen: false)
                  .deleteCategory(widget.categoryData!.id);
            },
          ),
          const SizedBox(
            width: 5,
          ),
          FloatingActionButton.extended(
            heroTag: 'save',
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                TransactionCategory a = TransactionCategory(
                    name: nameController.text.trim(),
                    icon: _icon ?? Icons.blur_on,
                    color: _color,
                    description:
                        parseNullableString(descriptionController.text),
                    archived: false,
                    id: 0);
                if (widget.categoryData != null) {
                  a.id = widget.categoryData!.id;
                  Provider.of<CategoryModel>(context, listen: false)
                      .updateCategory(a);
                } else {
                  Provider.of<CategoryModel>(context, listen: false)
                      .createCategory(a);
                }
                Navigator.of(context).pop();
              }
            },
            label: const Text('Save'),
            icon: const Icon(Icons.check),
          ),
        ],
      ),
    );
  }
}

class PersistentHeader extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      width: double.infinity,
      height: 21,
      child: Container(
          // color: Colors.red,
          ),
    );
  }

  @override
  double get maxExtent => 21.0;

  @override
  double get minExtent => 21.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class CategoryHeader extends SliverPersistentHeaderDelegate {
  @override
  double get maxExtent => 250;

  @override
  double get minExtent => 80;
  double? _topPadding;

  final double minWidth = 200;
  final double minHeight = 100;
  final double rightMaxWidth = 100;
  final double rightMaxHeight = 100;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => false;

  Widget _buildTitle(BuildContext context, double shrinkOffset) => Align(
        alignment: Alignment.topCenter,
        child: AppBar(
          // surfaceTintColor: Colors.red,
          title: const Text("Create a category"),
        ),
      );
  double getScaledWidth(double width, double percent) =>
      width - ((width - minWidth) * percent);

  double getScaledHeight(double height, double percent) =>
      height - ((height - minHeight) * percent);

  /// 20 is the padding between the image and the title
  double get shrinkedHorizontalPos => (100 - (300 / 2)) - minWidth - 20;

  Widget _buildPicker(double percent) {
    final double topMargin = minExtent;
    final double rangeLeft = (100 - (100 / 2)) - shrinkedHorizontalPos;
    final double rangeTop = topMargin - 50;

    final double top = topMargin - (rangeTop * percent);
    final double left = (100 - (rightMaxWidth / 2)) - (rangeLeft * percent);
    return Positioned(
      // left: left,
      top: topMargin + 20,
      child: Container(
        width: 90000,
        color: Colors.amber,
        height: 100 * (1 - percent) > 10 ? 100 * (1 - percent) : 10,
      ),
    );
  }

  Widget _buildIcon(double percent) {
    final double topMargin = maxExtent;
    final double rangeTop = maxExtent - 50;

    double top = rangeTop * (1 - percent);
    top = (top < 75) ? 75 : top;
    return Positioned(
      top: top,
      right: 20,
      child: IconPicker(
        color: Colors.grey,
        initialIcon: Icons.category,
        onIconChangedCallback: (iconData) {},
      ),
    );
  }

  Widget _buildPadding(double percent) {
    final double topMargin = minExtent;
    final double rangeLeft = (100 - (100 / 2)) - shrinkedHorizontalPos;
    final double rangeTop = topMargin - 50;
    return Positioned(
      // left: left,
      top: topMargin,
      child: Container(
        width: 90000,
        color: Colors.green,
        height: 100 * (1 - percent) > 10 ? 100 * (1 - percent) : 10,
      ),
    );
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    double shrinkPercentage = min(1, shrinkOffset / (maxExtent - minExtent));
    shrinkPercentage = shrinkPercentage > 1 ? 1 : shrinkPercentage;
    print(shrinkPercentage);
    if (_topPadding == null) {
      _topPadding = MediaQuery.of(context).padding.top;
    }

    return Container(
      // color: Colors.red,
      child: Stack(
        children: <Widget>[
          _buildTitle(context, shrinkPercentage),
          _buildPicker(shrinkPercentage),
          _buildPadding(shrinkPercentage),
          _buildIcon(shrinkPercentage),
        ],
      ),
    );
  }
}

class DemoHeader extends SliverPersistentHeaderDelegate {
  DemoHeader(
      {required this.minHeight, required this.maxHeight, required this.child});

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => max(maxHeight, minHeight);

  // Widget _buildAppBar(BuildContext context, double shrinkOffset) => Align(
  //       alignment: Alignment.topCenter,
  //       child: AppBar(
  //         surfaceTintColor: Colors.red,
  //         title: const Text("Create a category"),
  //       ),
  //     );

  Widget _buildAppBar(BuildContext context, double shrinkOffset) => AppBar(
        // surfaceTintColor: Colors.red,
        title: const Text("Create a category"),
      );

  // Widget _buildColorPicker(BuildContext context, double shrinkOffset) {
  //   return Padding(
  //     padding: EdgeInsets.only(
  //       top: 0,
  //     ),
  //     child: Container(color: Colors.amber),
  //   );
  // }

  Widget _buildColorPicker(BuildContext context, double shrinkOffset) {
    return Container(
      color: Colors.amber,
    );
  }

  Widget _buildIconBackground(BuildContext context, double shrinkOffset) {
    double iconSize = 42;
    return Padding(
      padding: EdgeInsets.only(
        top: max((minExtent - (iconSize - 12)),
            ((1 - shrinkOffset) * maxExtent - iconSize / 2)),
        right: 42,
      ),
      child: CircleAvatar(
        minRadius: 42,
        maxRadius: 42,
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
    );
  }

  Widget _buildIcon(BuildContext context, double shrinkOffset) {
    double iconSize = 42;
    return Padding(
      padding: EdgeInsets.only(
        top: max((minExtent - (iconSize - 12)),
            ((1 - shrinkOffset) * maxExtent - iconSize / 2)),
        right: 42,
      ),
      child: Icon(
        Icons.category,
        size: 42,
      ),
      // child: Container(
      //   width: iconSize,
      //   height: iconSize,
      //   decoration: BoxDecoration(
      //       // shape: BoxShape.circle,
      //       // color: Theme.of(context).colorScheme.background,
      //       ),
      //   child: Icon(
      //     Icons.category,
      //     size: 42,
      //   ),
      // ),
    );
  }

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final progress = shrinkOffset / maxExtent;
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: _buildAppBar(context, shrinkOffset),
                flex: 0,
              ),
              Expanded(
                child: _buildColorPicker(context, shrinkOffset),
                flex:
                    (((1 - progress) > 0 ? (1 - progress) : 0.1) * 100).round(),
              ),
            ],
          ),
          _buildIconBackground(context, progress),
          _buildIcon(context, progress),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(DemoHeader oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }

  // Widget overlapped() {
  //   final overlap = 80;
  //   final items = [
  //     CircleAvatar(
  //       child: Text('1'),
  //       backgroundColor: Colors.red,
  //       radius: 40,
  //     ),
  //     CircleAvatar(
  //       child: Text('2'),
  //       backgroundColor: Colors.green,
  //       radius: 40,
  //     ),
  //     CircleAvatar(
  //       child: Text('3'),
  //       backgroundColor: Colors.blue,
  //       radius: 40,
  //     ),
  //   ];

  //   List<Widget> stackLayers = List<Widget>.generate(items.length, (index) {
  //     return Padding(
  //       padding: EdgeInsets.fromLTRB(index.toDouble() * overlap, 0, 0, 0),
  //       child: items[index],
  //     );
  //   });

  //   return Stack(children: stackLayers);
  // }
}
