import 'package:budgetiser/core/database/models/category.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const Duration _kExpand = Duration(milliseconds: 200);

class ExpansionTileController {
  ExpansionTileController();

  _CategoryTreeTileState? _state;

  bool get isExpanded {
    assert(_state != null);
    return _state!._isExpanded;
  }

  void expand() {
    assert(_state != null);
    if (!isExpanded) {
      _state!._toggleExpansion();
    }
  }

  void collapse() {
    assert(_state != null);
    if (isExpanded) {
      _state!._toggleExpansion();
    }
  }

  static ExpansionTileController of(BuildContext context) {
    final _CategoryTreeTileState? result =
        context.findAncestorStateOfType<_CategoryTreeTileState>();
    if (result != null) {
      return result._tileController;
    }
    throw FlutterError.fromParts(<DiagnosticsNode>[
      ErrorSummary(
        'ExpansionTileController.of() called with a context that does not contain a ExpansionTile.',
      ),
      context.describeElement('The context used was'),
    ]);
  }

  static ExpansionTileController? maybeOf(BuildContext context) {
    return context
        .findAncestorStateOfType<_CategoryTreeTileState>()
        ?._tileController;
  }
}

class CategoryTreeTile extends StatefulWidget {
  const CategoryTreeTile({
    super.key,
    required this.categoryData,
    this.onTap,
    this.children = const <Widget>[],
    this.contentPadding = const EdgeInsets.fromLTRB(8, 0, 8, 0),
    this.initiallyExpanded = false,
  });

  final TransactionCategory categoryData;
  final ValueChanged<TransactionCategory>? onTap;
  final List<Widget> children;
  final EdgeInsets contentPadding;
  final bool initiallyExpanded;

  @override
  State<CategoryTreeTile> createState() => _CategoryTreeTileState();
}

class _CategoryTreeTileState extends State<CategoryTreeTile>
    with SingleTickerProviderStateMixin {
  static final Animatable<double> _easeOutTween =
      CurveTween(curve: Curves.easeOut);
  static final Animatable<double> _easeInTween =
      CurveTween(curve: Curves.easeIn);
  static final Animatable<double> _halfTween =
      Tween<double>(begin: 0.0, end: 0.5);

  final ShapeBorderTween _borderTween = ShapeBorderTween();
  final CurveTween _heightFactorTween = CurveTween(curve: Curves.easeIn);

  late AnimationController _animationController;
  late Animation<double> _iconTurns;
  late Animation<double> _heightFactor;
  late Animation<ShapeBorder?> _border;

  bool _isExpanded = false;
  late ExpansionTileController _tileController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(duration: _kExpand, vsync: this);
    _heightFactor = _animationController.drive(_heightFactorTween);
    _iconTurns = _animationController.drive(_halfTween.chain(_easeInTween));
    _border = _animationController.drive(_borderTween.chain(_easeOutTween));

    _isExpanded = PageStorage.maybeOf(context)?.readState(context) as bool? ??
        widget.initiallyExpanded;
    if (_isExpanded) {
      _animationController.value = 1.0;
    }
    _tileController = ExpansionTileController();
    _tileController._state = this;
  }

  @override
  void dispose() {
    _tileController._state = null;
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    final TextDirection textDirection =
        WidgetsLocalizations.of(context).textDirection;
    final MaterialLocalizations localizations =
        MaterialLocalizations.of(context);
    final String stateHint =
        _isExpanded ? localizations.expandedHint : localizations.collapsedHint;
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse().then<void>((void value) {
          if (!mounted) {
            return;
          }
          setState(() {});
        });
      }
      PageStorage.maybeOf(context)?.writeState(context, _isExpanded);
    });
    SemanticsService.announce(stateHint, textDirection);
  }

  Widget? _buildIcon(BuildContext context) {
    return RotationTransition(
      turns: _iconTurns,
      child: const Icon(Icons.expand_more),
    );
  }

  Widget? _buildTrailingIcon(BuildContext context) {
    return _buildIcon(context);
  }

  Widget _buildChildren(BuildContext context, Widget? child) {
    final ShapeBorder expansionTileBorder = _border.value ?? const Border();

    return Container(
      clipBehavior: ExpansionTileTheme.of(context).clipBehavior ?? Clip.none,
      decoration: ShapeDecoration(
        color: ExpansionTileTheme.of(context).backgroundColor,
        shape: expansionTileBorder,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Semantics(
            label: widget.categoryData.name,
            child: ListTile(
              onTap: () => widget.onTap?.call(widget.categoryData),
              contentPadding: widget.contentPadding,
              leading: Icon(widget.categoryData.icon),
              title: Text(widget.categoryData.name),
              iconColor: widget.categoryData.color,
              textColor: widget.categoryData.color,
              subtitle:
                  (widget.categoryData.description?.trim().isNotEmpty ?? false)
                      ? Text(widget.categoryData.description!)
                      : null,
              trailing: SizedBox(
                height: 50,
                width: 50,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () => _toggleExpansion(),
                  child: _buildTrailingIcon(context),
                ),
              ),
            ),
          ),
          ClipRect(
            child: Align(
              alignment: Alignment.center,
              heightFactor: _heightFactor.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ExpansionTileThemeData expansionTileTheme =
        ExpansionTileTheme.of(context);
    final bool closed = !_isExpanded && _animationController.isDismissed;
    final bool shouldRemoveChildren = closed && !false;

    final Widget result = Offstage(
      offstage: closed,
      child: TickerMode(
        enabled: !closed,
        child: Padding(
          padding: expansionTileTheme.childrenPadding ?? EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: widget.children,
          ),
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _animationController.view,
      builder: _buildChildren,
      child: shouldRemoveChildren ? null : result,
    );
  }
}
