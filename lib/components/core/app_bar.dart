import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hikee/components/button.dart';

class HikeeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HikeeAppBar(
      {Key? key,
      this.title,
      this.titlePadding = true,
      this.pinned = false,
      this.leading,
      this.canPop,
      this.actions,
      this.elevation = 2,
      this.height = 60,
      this.closeIcon})
      : super(key: key);

  final Widget? title;
  final bool titlePadding;
  final bool pinned;
  final Widget? leading;
  final bool? canPop;
  final List<Widget>? actions;
  final double? elevation;
  final double height;
  final IconData? closeIcon;

  @override
  Widget build(BuildContext context) {
    var backButton = canPop != null ? canPop! : ModalRoute.of(context)!.canPop;
    return AppBar(
      iconTheme: IconThemeData(color: Colors.green, size: 24),
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.vertical(
      //     bottom: Radius.circular(12),
      //   ),
      // ),
      elevation: elevation,
      titleTextStyle: TextStyle(fontSize: 12),
      title: title == null
          ? null
          : DefaultTextStyle(
              style: TextStyle(
                  color: Get.theme.textTheme.bodyText1?.color ?? Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18),
              child: Padding(
                padding: EdgeInsets.only(
                    left:
                        leading != null || backButton || !titlePadding ? 0 : 8,
                    right: 8.0),
                child: title,
              ),
            ),
      leadingWidth: 44 + 8 * 2,
      leading: leading != null
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: leading,
            )
          : (backButton
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Button(
                    backgroundColor: Colors.transparent,
                    icon: Icon(closeIcon ?? Icons.chevron_left,
                        color: Get.theme.textTheme.bodyText1?.color ??
                            Colors.black),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                )
              : null),
      automaticallyImplyLeading: false,
      actions: actions != null
          ? [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions!
                      .map((e) => SizedBox(
                            height: 44,
                            width: 44,
                            child: e,
                          ))
                      .toList(),
                ),
              )
            ]
          : null,
      backgroundColor: Colors.white,
      shadowColor: Colors.black26,
      toolbarHeight: height,
      titleSpacing: 0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
// class HikeeAppBar extends StatelessWidget implements PreferredSizeWidget {
//   const HikeeAppBar({Key? key, required this.title, this.leading, this.actions, this.height = 56})
//       : super(key: key);
//   final Widget title;
//   final Widget? leading;
//   final List<Widget>? actions;
//   final double height;

//   @override
//   Size get preferredSize => Size.fromHeight(90);

//   @override
//   Widget build(BuildContext context) {
//     return AppBar(
//       title: title,
//       leading: leading,
//       actions: actions,
//       backgroundColor: Colors.white,
//       shadowColor: Colors.black26,
//       titleSpacing: 6,
//       elevation: 8,
//     );
//   }
// }

// class HikeeAppBar extends HikeeIntrinsicAppBar implements PreferredSizeWidget {
//   const HikeeAppBar({Key? key, required Widget title, Widget? leading, List<Widget>? actions})
//       : super(key: key, title: title, leading: leading, actions: actions);
//   @override
//   Size get preferredSize => Size.fromHeight(56);
// }

// class HikeeAppBar extends StatefulWidget implements PreferredSizeWidget{
//   /// Creates a material design app bar.
//   ///
//   /// The arguments [primary], [toolbarOpacity], [bottomOpacity],
//   /// [backwardsCompatibility], and [automaticallyImplyLeading] must
//   /// not be null. Additionally, if [elevation] is specified, it must
//   /// be non-negative.
//   ///
//   /// Typically used in the [Scaffold.appBar] property.
//   HikeeAppBar({
//     Key? key,
//     this.leading,
//     this.automaticallyImplyLeading = true,
//     this.title,
//     this.actions,
//     this.flexibleSpace,
//     this.bottom,
//     this.elevation,
//     this.shadowColor,
//     this.shape,
//     this.backgroundColor,
//     this.foregroundColor,
//     this.brightness,
//     this.iconTheme,
//     this.actionsIconTheme,
//     this.textTheme,
//     this.primary = true,
//     this.centerTitle,
//     this.excludeHeaderSemantics = false,
//     this.titleSpacing,
//     this.toolbarOpacity = 1.0,
//     this.bottomOpacity = 1.0,
//     this.toolbarHeight,
//     this.leadingWidth,
//     this.backwardsCompatibility,
//     this.toolbarTextStyle,
//     this.titleTextStyle,
//     this.systemOverlayStyle,
//   }) : assert(automaticallyImplyLeading != null),
//        assert(elevation == null || elevation >= 0.0),
//        assert(primary != null),
//        assert(toolbarOpacity != null),
//        assert(bottomOpacity != null),
//        preferredSize = Size.fromHeight(toolbarHeight ?? kToolbarHeight + (bottom?.preferredSize.height ?? 0.0)),
//        super(key: key);

//   /// {@template flutter.material.appbar.leading}
//   /// A widget to display before the toolbar's [title].
//   ///
//   /// Typically the [leading] widget is an [Icon] or an [IconButton].
//   ///
//   /// Becomes the leading component of the [NavigationToolbar] built
//   /// by this widget. The [leading] widget's width and height are constrained to
//   /// be no bigger than [leadingWidth] and [toolbarHeight] respectively.
//   ///
//   /// If this is null and [automaticallyImplyLeading] is set to true, the
//   /// [AppBar] will imply an appropriate widget. For example, if the [AppBar] is
//   /// in a [Scaffold] that also has a [Drawer], the [Scaffold] will fill this
//   /// widget with an [IconButton] that opens the drawer (using [Icons.menu]). If
//   /// there's no [Drawer] and the parent [Navigator] can go back, the [AppBar]
//   /// will use a [BackButton] that calls [Navigator.maybePop].
//   /// {@endtemplate}
//   ///
//   /// {@tool snippet}
//   ///
//   /// The following code shows how the drawer button could be manually specified
//   /// instead of relying on [automaticallyImplyLeading]:
//   ///
//   /// ```dart
//   /// AppBar(
//   ///   leading: Builder(
//   ///     builder: (BuildContext context) {
//   ///       return IconButton(
//   ///         icon: const Icon(Icons.menu),
//   ///         onPressed: () { Scaffold.of(context).openDrawer(); },
//   ///         tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
//   ///       );
//   ///     },
//   ///   ),
//   /// )
//   /// ```
//   /// {@end-tool}
//   ///
//   /// The [Builder] is used in this example to ensure that the `context` refers
//   /// to that part of the subtree. That way this code snippet can be used even
//   /// inside the very code that is creating the [Scaffold] (in which case,
//   /// without the [Builder], the `context` wouldn't be able to see the
//   /// [Scaffold], since it would refer to an ancestor of that widget).
//   ///
//   /// See also:
//   ///
//   ///  * [Scaffold.appBar], in which an [AppBar] is usually placed.
//   ///  * [Scaffold.drawer], in which the [Drawer] is usually placed.
//   final Widget? leading;

//   /// {@template flutter.material.appbar.automaticallyImplyLeading}
//   /// Controls whether we should try to imply the leading widget if null.
//   ///
//   /// If true and [leading] is null, automatically try to deduce what the leading
//   /// widget should be. If false and [leading] is null, leading space is given to [title].
//   /// If leading widget is not null, this parameter has no effect.
//   /// {@endtemplate}
//   final bool automaticallyImplyLeading;

//   /// {@template flutter.material.appbar.title}
//   /// The primary widget displayed in the app bar.
//   ///
//   /// Becomes the middle component of the [NavigationToolbar] built by this widget.
//   //.
//   /// Typically a [Text] widget that contains a description of the current
//   /// contents of the app.
//   /// {@endtemplate}
//   ///
//   /// The [title]'s width is constrained to fit within the remaining space
//   /// between the toolbar's [leading] and [actions] widgets. Its height is
//   /// _not_ constrained. The [title] is vertically centered and clipped to fit
//   /// within the toolbar, whose height is [toolbarHeight]. Typically this
//   /// isn't noticeable because a simple [Text] [title] will fit within the
//   /// toolbar by default. On the other hand, it is noticeable when a
//   /// widget with an intrinsic height that is greater than [toolbarHeight]
//   /// is used as the [title]. For example, when the height of an Image used
//   /// as the [title] exceeds [toolbarHeight], it will be centered and
//   /// clipped (top and bottom), which may be undesirable. In cases like this
//   /// the height of the [title] widget can be constrained. For example:
//   ///
//   /// ```dart
//   /// MaterialApp(
//   ///   home: Scaffold(
//   ///     appBar: AppBar(
//   ///        title: SizedBox(
//   ///        height: toolbarHeight,
//   ///        child: child: Image.asset(logoAsset),
//   ///      ),
//   ///      toolbarHeight: toolbarHeight,
//   ///   ),
//   /// )
//   /// ```
//   final Widget? title;

//   /// {@template flutter.material.appbar.actions}
//   /// A list of Widgets to display in a row after the [title] widget.
//   ///
//   /// Typically these widgets are [IconButton]s representing common operations.
//   /// For less common operations, consider using a [PopupMenuButton] as the
//   /// last action.
//   ///
//   /// The [actions] become the trailing component of the [NavigationToolbar] built
//   /// by this widget. The height of each action is constrained to be no bigger
//   /// than the [toolbarHeight].
//   /// {@endtemplate}
//   ///
//   /// {@tool snippet}
//   ///
//   /// ```dart
//   /// Scaffold(
//   ///   body: CustomScrollView(
//   ///     primary: true,
//   ///     slivers: <Widget>[
//   ///       SliverAppBar(
//   ///         title: const Text('Hello World'),
//   ///         actions: <Widget>[
//   ///           IconButton(
//   ///             icon: const Icon(Icons.shopping_cart),
//   ///             tooltip: 'Open shopping cart',
//   ///             onPressed: () {
//   ///               // handle the press
//   ///             },
//   ///           ),
//   ///         ],
//   ///       ),
//   ///       // ...rest of body...
//   ///     ],
//   ///   ),
//   /// )
//   /// ```
//   /// {@end-tool}
//   final List<Widget>? actions;

//   /// {@template flutter.material.appbar.flexibleSpace}
//   /// This widget is stacked behind the toolbar and the tab bar. Its height will
//   /// be the same as the app bar's overall height.
//   ///
//   /// A flexible space isn't actually flexible unless the [AppBar]'s container
//   /// changes the [AppBar]'s size. A [SliverAppBar] in a [CustomScrollView]
//   /// changes the [AppBar]'s height when scrolled.
//   ///
//   /// Typically a [FlexibleSpaceBar]. See [FlexibleSpaceBar] for details.
//   /// {@endtemplate}
//   final Widget? flexibleSpace;

//   /// {@template flutter.material.appbar.bottom}
//   /// This widget appears across the bottom of the app bar.
//   ///
//   /// Typically a [TabBar]. Only widgets that implement [PreferredSizeWidget] can
//   /// be used at the bottom of an app bar.
//   /// {@endtemplate}
//   ///
//   /// See also:
//   ///
//   ///  * [PreferredSize], which can be used to give an arbitrary widget a preferred size.
//   final PreferredSizeWidget? bottom;

//   /// {@template flutter.material.appbar.elevation}
//   /// The z-coordinate at which to place this app bar relative to its parent.
//   ///
//   /// This property controls the size of the shadow below the app bar.
//   ///
//   /// The value must be non-negative.
//   ///
//   /// If this property is null, then [AppBarTheme.elevation] of
//   /// [ThemeData.appBarTheme] is used. If that is also null, the
//   /// default value is 4.
//   /// {@endtemplate}
//   ///
//   /// See also:
//   ///
//   ///  * [shadowColor], which is the color of the shadow below the app bar.
//   ///  * [shape], which defines the shape of the app bar's [Material] and its
//   ///    shadow.
//   final double? elevation;

//   /// {@template flutter.material.appbar.shadowColor}
//   /// The of the shadow below the app bar.
//   ///
//   /// If this property is null, then [AppBarTheme.shadowColor] of
//   /// [ThemeData.appBarTheme] is used. If that is also null, the default value
//   /// is fully opaque black.
//   /// {@endtemplate}
//   ///
//   /// See also:
//   ///
//   ///  * [elevation], which defines the size of the shadow below the app bar.
//   ///  * [shape], which defines the shape of the app bar and its shadow.
//   final Color? shadowColor;

//   /// {@template flutter.material.appbar.shape}
//   /// The shape of the app bar's material's shape as well as its shadow.
//   ///
//   /// A shadow is only displayed if the [elevation] is greater than
//   /// zero.
//   /// {@endtemplate}
//   ///
//   /// See also:
//   ///
//   ///  * [elevation], which defines the size of the shadow below the app bar.
//   ///  * [shadowColor], which is the color of the shadow below the app bar.
//   final ShapeBorder? shape;

//   /// {@template flutter.material.appbar.backgroundColor}
//   /// The fill color to use for an app bar's [Material].
//   ///
//   /// If null, then the [AppBarTheme.backgroundColor] is used. If that value is also
//   /// null, then [AppBar] uses the overall theme's [ColorScheme.primary] if the
//   /// overall theme's brightness is [Brightness.light], and [ColorScheme.surface]
//   /// if the overall theme's [brightness] is [Brightness.dark].
//   /// {@endtemplate}
//   ///
//   /// See also:
//   ///
//   ///  * [foregroundColor], which specifies the color for icons and text within
//   ///    the app bar.
//   ///  * [Theme.of], which returns the current overall Material theme as
//   ///    a [ThemeData].
//   ///  * [ThemeData.colorScheme], the thirteen colors that most Material widget
//   ///    default colors are based on.
//   ///  * [ColorScheme.brightness], which indicates if the overall [Theme]
//   ///    is light or dark.
//   final Color? backgroundColor;

//   /// {@template flutter.material.appbar.foregroundColor}
//   /// The default color for [Text] and [Icon]s within the app bar.
//   ///
//   /// If null, then [AppBarTheme.foregroundColor] is used. If that
//   /// value is also null, then [AppBar] uses the overall theme's
//   /// [ColorScheme.onPrimary] if the overall theme's brightness is
//   /// [Brightness.light], and [ColorScheme.onSurface] if the overall
//   /// theme's [brightness] is [Brightness.dark].
//   ///
//   /// This color is used to configure [DefaultTextStyle] that contains
//   /// the toolbar's children, and the default [IconTheme] widgets that
//   /// are created if [iconTheme] and [actionsIconTheme] are null.
//   /// {@endtemplate}
//   ///
//   /// See also:
//   ///
//   ///  * [backgroundColor], which specifies the app bar's background color.
//   ///  * [Theme.of], which returns the current overall Material theme as
//   ///    a [ThemeData].
//   ///  * [ThemeData.colorScheme], the thirteen colors that most Material widget
//   ///    default colors are based on.
//   ///  * [ColorScheme.brightness], which indicates if the overall [Theme]
//   ///    is light or dark.
//   final Color? foregroundColor;

//   /// {@template flutter.material.appbar.brightness}
//   /// This property is obsolete, please use [systemOverlayStyle] instead.
//   ///
//   /// Determines the brightness of the [SystemUiOverlayStyle]: for
//   /// [Brightness.dark], [SystemUiOverlayStyle.light] is used and fo
//   /// [Brightness.light], [SystemUiOverlayStyle.dark] is used.
//   ///
//   /// If this value is null then [AppBarTheme.brightness] is used
//   /// and if that's null then overall theme's brightness is used.
//   ///
//   /// The AppBar is built within a `AnnotatedRegion<SystemUiOverlayStyle>`
//   /// which causes [SystemChrome.setSystemUIOverlayStyle] to be called
//   /// automatically.  Apps should not enclose the AppBar with
//   /// their own [AnnotatedRegion].
//   /// {@endtemplate}
//   ///
//   /// See also:
//   ///
//   ///  * [Theme.of], which returns the current overall Material theme as
//   ///    a [ThemeData].
//   ///  * [ThemeData.colorScheme], the thirteen colors that most Material widget
//   ///    default colors are based on.
//   ///  * [ColorScheme.brightness], which indicates if the overall [Theme]
//   ///    is light or dark.
//   ///  * [backwardsCompatibility], which forces AppBar to use this
//   ///    obsolete property.
//   final Brightness? brightness;

//   /// {@template flutter.material.appbar.iconTheme}
//   /// The color, opacity, and size to use for toolbar icons.
//   ///
//   /// If this property is null, then a copy of [ThemeData.iconTheme]
//   /// is used, with the [IconThemeData.color] set to the
//   /// app bar's [foregroundColor].
//   /// {@endtemplate}
//   ///
//   /// See also:
//   ///
//   ///  * [actionsIconTheme], which defines the appearance of icons in
//   ///    in the [actions] list.
//   final IconThemeData? iconTheme;

//   /// {@template flutter.material.appbar.actionsIconTheme}
//   /// The color, opacity, and size to use for the icons that appear in the app
//   /// bar's [actions].
//   ///
//   /// This property should only be used when the [actions] should be
//   /// themed differently than the icon that appears in the app bar's [leading]
//   /// widget.
//   ///
//   /// If this property is null, then [AppBarTheme.actionsIconTheme] of
//   /// [ThemeData.appBarTheme] is used. If that is also null, then the value of
//   /// [iconTheme] is used.
//   /// {@endtemplate}
//   ///
//   /// See also:
//   ///
//   ///  * [iconTheme], which defines the appearance of all of the toolbar icons.
//   final IconThemeData? actionsIconTheme;

//   /// {@template flutter.material.appbar.textTheme}
//   /// The typographic styles to use for text in the app bar. Typically this is
//   /// set along with [brightness] [backgroundColor], [iconTheme].
//   ///
//   /// If this property is null, then [AppBarTheme.textTheme] of
//   /// [ThemeData.appBarTheme] is used. If that is also null, then
//   /// [ThemeData.primaryTextTheme] is used.
//   /// {@endtemplate}
//   final TextTheme? textTheme;

//   /// {@template flutter.material.appbar.primary}
//   /// Whether this app bar is being displayed at the top of the screen.
//   ///
//   /// If true, the app bar's toolbar elements and [bottom] widget will be
//   /// padded on top by the height of the system status bar. The layout
//   /// of the [flexibleSpace] is not affected by the [primary] property.
//   /// {@endtemplate}
//   final bool primary;

//   /// {@template flutter.material.appbar.centerTitle}
//   /// Whether the title should be centered.
//   ///
//   /// If this property is null, then [AppBarTheme.centerTitle] of
//   /// [ThemeData.appBarTheme] is used. If that is also null, then value is
//   /// adapted to the current [TargetPlatform].
//   /// {@endtemplate}
//   final bool? centerTitle;

//   /// {@template flutter.material.appbar.excludeHeaderSemantics}
//   /// Whether the title should be wrapped with header [Semantics].
//   ///
//   /// Defaults to false.
//   /// {@endtemplate}
//   final bool excludeHeaderSemantics;

//   /// {@template flutter.material.appbar.titleSpacing}
//   /// The spacing around [title] content on the horizontal axis. This spacing is
//   /// applied even if there is no [leading] content or [actions]. If you want
//   /// [title] to take all the space available, set this value to 0.0.
//   ///
//   /// If this property is null, then [AppBarTheme.titleSpacing] of
//   /// [ThemeData.appBarTheme] is used. If that is also null, then the
//   /// default value is [NavigationToolbar.kMiddleSpacing].
//   /// {@endtemplate}
//   final double? titleSpacing;

//   /// {@template flutter.material.appbar.toolbarOpacity}
//   /// How opaque the toolbar part of the app bar is.
//   ///
//   /// A value of 1.0 is fully opaque, and a value of 0.0 is fully transparent.
//   ///
//   /// Typically, this value is not changed from its default value (1.0). It is
//   /// used by [SliverAppBar] to animate the opacity of the toolbar when the app
//   /// bar is scrolled.
//   /// {@endtemplate}
//   final double toolbarOpacity;

//   /// {@template flutter.material.appbar.bottomOpacity}
//   /// How opaque the bottom part of the app bar is.
//   ///
//   /// A value of 1.0 is fully opaque, and a value of 0.0 is fully transparent.
//   ///
//   /// Typically, this value is not changed from its default value (1.0). It is
//   /// used by [SliverAppBar] to animate the opacity of the toolbar when the app
//   /// bar is scrolled.
//   /// {@endtemplate}
//   final double bottomOpacity;

//   /// {@template flutter.material.appbar.preferredSize}
//   /// A size whose height is the sum of [toolbarHeight] and the [bottom] widget's
//   /// preferred height.
//   ///
//   /// [Scaffold] uses this size to set its app bar's height.
//   /// {@endtemplate}
//   @override
//   final Size preferredSize;

//   /// {@template flutter.material.appbar.toolbarHeight}
//   /// Defines the height of the toolbar component of an [AppBar].
//   ///
//   /// By default, the value of `toolbarHeight` is [kToolbarHeight].
//   /// {@endtemplate}
//   final double? toolbarHeight;

//   /// {@template flutter.material.appbar.leadingWidth}
//   /// Defines the width of [leading] widget.
//   ///
//   /// By default, the value of `leadingWidth` is 56.0.
//   /// {@endtemplate}
//   final double? leadingWidth;

//   /// {@template flutter.material.appbar.backwardsCompatibility}
//   /// If true, preserves the original defaults for the [backgroundColor],
//   /// [iconTheme], [actionsIconTheme] properties, and the original use of
//   /// the [textTheme] and [brightness] properties.
//   ///
//   /// If this property is null, then [AppBarTheme.backwardsCompatibility] of
//   /// [ThemeData.appBarTheme] is used. If that is also null, the default
//   /// value is true.
//   ///
//   /// This is a temporary property. When setting it to false is no
//   /// longer considered a breaking change, it will be depreacted and
//   /// its default value will be changed to false. App developers are
//   /// encouraged to opt into the new features by setting it to false
//   /// and using the [foregroundColor] and [systemOverlayStyle]
//   /// properties as needed.
//   /// {@endtemplate}
//   final bool? backwardsCompatibility;

//   /// {@template flutter.material.appbar.toolbarTextStyle}
//   /// The default text style for the AppBar's [leading], and
//   /// [actions] widgets, but not its [title].
//   ///
//   /// If this property is null, then [AppBarTheme.toolbarTextStyle] of
//   /// [ThemeData.appBarTheme] is used. If that is also null, the default
//   /// value is a copy of the overall theme's [TextTheme.bodyText2]
//   /// [TextStyle], with color set to the app bar's [foregroundColor].
//   /// {@endtemplate}
//   ///
//   /// See also:
//   ///
//   ///  * [titleTextStyle], which overrides the default text style for the [title].
//   ///  * [DefaultTextStyle], which overrides the default text style for all of the
//   ///    the widgets in a subtree.
//   final TextStyle? toolbarTextStyle;

//   /// {@template flutter.material.appbar.titleTextStyle}
//   /// The default text style for the AppBar's [title] widget.
//   ///
//   /// If this property is null, then [AppBarTheme.titleTextStyle] of
//   /// [ThemeData.appBarTheme] is used. If that is also null, the default
//   /// value is a copy of the overall theme's [TextTheme.headline6]
//   /// [TextStyle], with color set to the app bar's [foregroundColor].
//   /// {@endtemplate}
//   ///
//   /// See also:
//   ///
//   ///  * [toolbarTextStyle], which is the default text style for the AppBar's
//   ///    [title], [leading], and [actions] widgets, also known as the
//   ///    AppBar's "toolbar".
//   ///  * [DefaultTextStyle], which overrides the default text style for all of the
//   ///    the widgets in a subtree.
//   final TextStyle? titleTextStyle;

//   /// {@template flutter.material.appbar.systemOverlayStyle}
//   /// Specifies the style to use for the system overlays that overlap the AppBar.
//   ///
//   /// If this property is null, then [SystemUiOverlayStyle.light] is used if the
//   /// overall theme is dark, [SystemUiOverlayStyle.dark] otherwise. Theme brightness
//   /// is defined by [ColorScheme.brightness] for [ThemeData.colorScheme].
//   ///
//   /// The AppBar's descendants are built within a
//   /// `AnnotatedRegion<SystemUiOverlayStyle>` widget, which causes
//   /// [SystemChrome.setSystemUIOverlayStyle] to be called
//   /// automatically.  Apps should not enclose an AppBar with their
//   /// own [AnnotatedRegion].
//   /// {@endtemplate}
//   //
//   /// See also:
//   ///  * [SystemChrome.setSystemUIOverlayStyle]
//   final SystemUiOverlayStyle? systemOverlayStyle;


//   bool _getEffectiveCenterTitle(ThemeData theme) {
//     if (centerTitle != null)
//       return centerTitle!;
//     if (theme.appBarTheme.centerTitle != null)
//       return theme.appBarTheme.centerTitle!;
//     assert(theme.platform != null);
//     switch (theme.platform) {
//       case TargetPlatform.android:
//       case TargetPlatform.fuchsia:
//       case TargetPlatform.linux:
//       case TargetPlatform.windows:
//         return false;
//       case TargetPlatform.iOS:
//       case TargetPlatform.macOS:
//         return actions == null || actions!.length < 2;
//     }
//   }

//   @override
//   _HikeeAppBarState createState() => _HikeeAppBarState();
// }

// class _HikeeAppBarState extends State<HikeeAppBar> {
//   static const double _defaultElevation = 4.0;
//   static const Color _defaultShadowColor = Color(0xFF000000);

//   void _handleDrawerButton() {
//     Scaffold.of(context).openDrawer();
//   }

//   void _handleDrawerButtonEnd() {
//     Scaffold.of(context).openEndDrawer();
//   }

//   @override
//   Widget build(BuildContext context) {
//     assert(!widget.primary || debugCheckHasMediaQuery(context));
//     assert(debugCheckHasMaterialLocalizations(context));
//     final ThemeData theme = Theme.of(context);
//     final ColorScheme colorScheme = theme.colorScheme;
//     final AppBarTheme appBarTheme = AppBarTheme.of(context);
//     final ScaffoldState? scaffold = Scaffold.maybeOf(context);
//     final ModalTrail<dynamic>? parentTrail = ModalTrail.of(context);

//     final bool hasDrawer = scaffold?.hasDrawer ?? false;
//     final bool hasEndDrawer = scaffold?.hasEndDrawer ?? false;
//     final bool canPop = parentTrail?.canPop ?? false;
//     final bool useCloseButton = parentTrail is PageTrail<dynamic> && parentTrail.fullscreenDialog;

//     final double toolbarHeight = widget.toolbarHeight ?? kToolbarHeight;
//     final bool backwardsCompatibility = widget.backwardsCompatibility ?? appBarTheme.backwardsCompatibility ?? true;

//     final Color backgroundColor = backwardsCompatibility
//       ? widget.backgroundColor
//         ?? appBarTheme.backgroundColor
//         ?? theme.primaryColor
//       : widget.backgroundColor
//         ?? appBarTheme.backgroundColor
//         ?? (colorScheme.brightness == Brightness.dark ? colorScheme.surface : colorScheme.primary);

//     final Color foregroundColor = widget.foregroundColor
//       ?? appBarTheme.foregroundColor
//       ?? (colorScheme.brightness == Brightness.dark ? colorScheme.onSurface : colorScheme.onPrimary);

//     IconThemeData overallIconTheme = backwardsCompatibility
//       ? widget.iconTheme
//         ?? appBarTheme.iconTheme
//         ?? theme.primaryIconTheme
//       : widget.iconTheme
//         ?? appBarTheme.iconTheme
//         ?? theme.iconTheme.copyWith(color: foregroundColor);

//     IconThemeData actionsIconTheme = widget.actionsIconTheme
//       ?? appBarTheme.actionsIconTheme
//       ?? overallIconTheme;

//     TextStyle? toolbarTextStyle = backwardsCompatibility
//       ? widget.textTheme?.bodyText2
//         ?? appBarTheme.textTheme?.bodyText2
//         ?? theme.primaryTextTheme.bodyText2
//       : widget.toolbarTextStyle
//         ?? appBarTheme.toolbarTextStyle
//         ?? theme.textTheme.bodyText2?.copyWith(color: foregroundColor);

//     TextStyle? titleTextStyle = backwardsCompatibility
//       ? widget.textTheme?.headline6
//         ?? appBarTheme.textTheme?.headline6
//         ?? theme.primaryTextTheme.headline6
//       : widget.titleTextStyle
//         ?? appBarTheme.titleTextStyle
//         ?? theme.textTheme.headline6?.copyWith(color: foregroundColor);

//     if (widget.toolbarOpacity != 1.0) {
//       final double opacity = const Interval(0.25, 1.0, curve: Curves.fastOutSlowIn).transform(widget.toolbarOpacity);
//       if (titleTextStyle?.color != null)
//         titleTextStyle = titleTextStyle!.copyWith(color: titleTextStyle.color!.withOpacity(opacity));
//       if (toolbarTextStyle?.color != null)
//         toolbarTextStyle = toolbarTextStyle!.copyWith(color: toolbarTextStyle.color!.withOpacity(opacity));
//       overallIconTheme = overallIconTheme.copyWith(
//         opacity: opacity * (overallIconTheme.opacity ?? 1.0),
//       );
//       actionsIconTheme = actionsIconTheme.copyWith(
//         opacity: opacity * (actionsIconTheme.opacity ?? 1.0),
//       );
//     }

//     Widget? leading = widget.leading;
//     if (leading == null && widget.automaticallyImplyLeading) {
//       if (hasDrawer) {
//         leading = IconButton(
//           icon: const Icon(Icons.menu),
//           onPressed: _handleDrawerButton,
//           tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
//         );
//       } else {
//         if (!hasEndDrawer && canPop)
//           leading = useCloseButton ? const CloseButton() : const BackButton();
//       }
//     }
//     if (leading != null) {
//       leading = ConstrainedBox(
//         constraints: BoxConstraints.tightFor(width: widget.leadingWidth ?? kToolbarHeight),
//         child: leading,
//       );
//     }

//     Widget? title = widget.title;
//     if (title != null) {
//       bool? namesTrail;
//       switch (theme.platform) {
//         case TargetPlatform.android:
//         case TargetPlatform.fuchsia:
//         case TargetPlatform.linux:
//         case TargetPlatform.windows:
//           namesTrail = true;
//           break;
//         case TargetPlatform.iOS:
//         case TargetPlatform.macOS:
//           break;
//       }

//       title = _AppBarTitleBox(child: title);
//       if (!widget.excludeHeaderSemantics) {
//         title = Semantics(
//           namesTrail: namesTrail,
//           child: title,
//           header: true,
//         );
//       }

//       title = DefaultTextStyle(
//         style: titleTextStyle!,
//         softWrap: false,
//         overflow: TextOverflow.ellipsis,
//         child: title,
//       );

//       // Set maximum text scale factor to [_kMaxTitleTextScaleFactor] for the
//       // title to keep the visual hierarchy the same even with larger font
//       // sizes. To opt out, wrap the [title] widget in a [MediaQuery] widget
//       // with [MediaQueryData.textScaleFactor] set to
//       // `MediaQuery.textScaleFactorOf(context)`.
//       final MediaQueryData mediaQueryData = MediaQuery.of(context);
//       title = MediaQuery(
//         data: mediaQueryData.copyWith(
//           textScaleFactor: math.min(
//             mediaQueryData.textScaleFactor,
//             1.34,
//           ),
//         ),
//         child: title,
//       );
//     }

//     Widget? actions;
//     if (widget.actions != null && widget.actions!.isNotEmpty) {
//       actions = Row(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: widget.actions!,
//       );
//     } else if (hasEndDrawer) {
//       actions = IconButton(
//         icon: const Icon(Icons.menu),
//         onPressed: _handleDrawerButtonEnd,
//         tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
//       );
//     }

//     // Allow the trailing actions to have their own theme if necessary.
//     if (actions != null) {
//       actions = IconTheme.merge(
//         data: actionsIconTheme,
//         child: actions,
//       );
//     }

//     final Widget toolbar = NavigationToolbar(
//       leading: leading,
//       middle: title,
//       trailing: actions,
//       centerMiddle: widget._getEffectiveCenterTitle(theme),
//       middleSpacing: widget.titleSpacing ?? appBarTheme.titleSpacing ?? NavigationToolbar.kMiddleSpacing,
//     );

//     // If the toolbar is allocated less than toolbarHeight make it
//     // appear to scroll upwards within its shrinking container.
//     Widget appBar = ClipRect(
//       child: CustomSingleChildLayout(
//         delegate: _ToolbarContainerLayout(toolbarHeight),
//         child: IconTheme.merge(
//           data: overallIconTheme,
//           child: DefaultTextStyle(
//             style: toolbarTextStyle!,
//             child: toolbar,
//           ),
//         ),
//       ),
//     );
//     if (widget.bottom != null) {
//       appBar = Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Flexible(
//             child: ConstrainedBox(
//               constraints: BoxConstraints(maxHeight: toolbarHeight),
//               child: appBar,
//             ),
//           ),
//           if (widget.bottomOpacity == 1.0)
//             widget.bottom!
//           else
//             Opacity(
//               opacity: const Interval(0.25, 1.0, curve: Curves.fastOutSlowIn).transform(widget.bottomOpacity),
//               child: widget.bottom,
//             ),
//         ],
//       );
//     }

//     // The padding applies to the toolbar and tabbar, not the flexible space.
//     if (widget.primary) {
//       appBar = SafeArea(
//         bottom: false,
//         top: true,
//         child: appBar,
//       );
//     }

//     appBar = Align(
//       alignment: Alignment.topCenter,
//       child: appBar,
//     );

//     if (widget.flexibleSpace != null) {
//       appBar = Stack(
//         fit: StackFit.passthrough,
//         children: <Widget>[
//           Semantics(
//             sortKey: const OrdinalSortKey(1.0),
//             explicitChildNodes: true,
//             child: widget.flexibleSpace,
//           ),
//           Semantics(
//             sortKey: const OrdinalSortKey(0.0),
//             explicitChildNodes: true,
//             // Creates a material widget to prevent the flexibleSpace from
//             // obscuring the ink splashes produced by appBar children.
//             child: Material(
//               type: MaterialType.transparency,
//               child: appBar,
//             ),
//           ),
//         ],
//       );
//     }

//     final Brightness overlayStyleBrightness = widget.brightness ?? appBarTheme.brightness ?? colorScheme.brightness;
//     final SystemUiOverlayStyle overlayStyle = backwardsCompatibility
//       ? (overlayStyleBrightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark)
//       : widget.systemOverlayStyle
//         ?? appBarTheme.systemOverlayStyle
//         ?? (colorScheme.brightness == Brightness.dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark);

//     return Semantics(
//       container: true,
//       child: AnnotatedRegion<SystemUiOverlayStyle>(
//         value: overlayStyle,
//         child: Material(
//           color: backgroundColor,
//           elevation: widget.elevation
//             ?? appBarTheme.elevation
//             ?? _defaultElevation,
//           shadowColor: widget.shadowColor
//             ?? appBarTheme.shadowColor
//             ?? _defaultShadowColor,
//           shape: widget.shape,
//           child: Semantics(
//             explicitChildNodes: true,
//             child: appBar,
//           ),
//         ),
//       ),
//     );
//   }
// }
// // Layout the AppBar's title with unconstrained height, vertically
// // center it within its (NavigationToolbar) parent, and allow the
// // parent to constrain the title's actual height.
// class _AppBarTitleBox extends SingleChildRenderObjectWidget {
//   const _AppBarTitleBox({ Key? key, required Widget child }) : assert(child != null), super(key: key, child: child);

//   @override
//   _RenderAppBarTitleBox createRenderObject(BuildContext context) {
//     return _RenderAppBarTitleBox(
//       textDirection: Directionality.of(context),
//     );
//   }

//   @override
//   void updateRenderObject(BuildContext context, _RenderAppBarTitleBox renderObject) {
//     renderObject.textDirection = Directionality.of(context);
//   }
// }

// class _RenderAppBarTitleBox extends RenderAligningShiftedBox {
//   _RenderAppBarTitleBox({
//     RenderBox? child,
//     TextDirection? textDirection,
//   }) : super(child: child, alignment: Alignment.center, textDirection: textDirection);

//   @override
//   Size computeDryLayout(BoxConstraints constraints) {
//     final BoxConstraints innerConstraints = constraints.copyWith(maxHeight: double.infinity);
//     final Size childSize = child!.getDryLayout(innerConstraints);
//     return constraints.constrain(childSize);
//   }

//   @override
//   void performLayout() {
//     final BoxConstraints innerConstraints = constraints.copyWith(maxHeight: double.infinity);
//     child!.layout(innerConstraints, parentUsesSize: true);
//     size = constraints.constrain(child!.size);
//     alignChild();
//   }
// }

// // Bottom justify the toolbarHeight child which may overflow the top.
// class _ToolbarContainerLayout extends SingleChildLayoutDelegate {
//   const _ToolbarContainerLayout(this.toolbarHeight);

//   final double toolbarHeight;

//   @override
//   BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
//     return constraints.tighten(height: toolbarHeight);
//   }

//   @override
//   Size getSize(BoxConstraints constraints) {
//     return Size(constraints.maxWidth, toolbarHeight);
//   }

//   @override
//   Offset getPositionForChild(Size size, Size childSize) {
//     return Offset(0.0, size.height - childSize.height);
//   }

//   @override
//   bool shouldRelayout(_ToolbarContainerLayout oldDelegate) =>
//       toolbarHeight != oldDelegate.toolbarHeight;
// }
