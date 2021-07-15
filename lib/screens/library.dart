import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hikee/components/hiking_route_tile.dart';
import 'package:hikee/components/text_input.dart';
import 'package:hikee/data/routes.dart';
import 'package:hikee/data/sortValues.dart';
import 'package:hikee/screens/route.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: TextInput(
                    hintText: 'Search...',
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 3,
                        blurRadius: 3,
                        offset: Offset(0, 6), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      TextButton(onPressed: () => _showSortDialog(context),
                        style: TextButton.styleFrom( primary: Theme.of(context).primaryColor),
                          child: Row(
                            children: [
                              Icon(Icons.sort),
                              Text("Sorting", style: TextStyle(fontSize: 15),),
                            ],
                          )
                      ),
                      TextButton(onPressed: () => {},
                          style: TextButton.styleFrom( primary: Colors.grey,),
                          child: Row(
                            children: [
                              Icon(Icons.filter_list),
                              Text("Filter", style: TextStyle(fontSize: 15),),
                            ],
                          )
                      ),
                      TextButton(onPressed: () => {},
                          style: TextButton.styleFrom( primary: Theme.of(context).primaryColor,),
                          child: Row(
                            children: [
                              Icon(Icons.map),
                              Text("District", style: TextStyle(fontSize: 15),),
                            ],
                          )
                      )
                    ],
                  ),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                      child: CustomScrollView(

                          slivers: [
                            SliverList(

                              delegate: SliverChildBuilderDelegate(
                                // The builder function returns a ListTile with a title that
                                // displays the index of the current item.
                                (context, index) => Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                                  child: HikingRouteTile(
                                      route: HikingRouteData.retrieve()[index],
                                      onTap: () {
                                        Navigator.of(context).push(MaterialPageRoute(
                                            builder: (_) => RouteScreen(
                                                id: HikingRouteData.retrieve()[index].id)));
                                      }),
                                ),
                                // Builds 1000 ListTiles
                                childCount: HikingRouteData.retrieve().length,
                              ),
                            )
                          ]
                      ),
                    )
                ),

              ]),
        ),
      ),
    );
  }
}

_showSortDialog(BuildContext context) => showDialog(context: context, builder: (context){
  final _LibrarySort= Provider.of<LibrarySort>(context);
  return AlertDialog(
    title: Text("Sorting"),
    content: SingleChildScrollView(
      child: Container(
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: sortValues.map((e) => RadioListTile<String>(
            activeColor: Theme.of(context).primaryColor,
            title: Text(e),
            value: e,
            groupValue: _LibrarySort.currentSort,
            selected: _LibrarySort.currentSort == e,
            onChanged: (value) {
              _LibrarySort.updateSort(value!);
              Navigator.of(context).pop();
            },
          )).toList(),
        )

      ),
    ),
  );
});

class LibrarySort extends ChangeNotifier{

    String _currentSort = sortValues[0];
    LibrarySort();

    String get currentSort => _currentSort;

    updateSort(String value){
      if (value != _currentSort) {
        _currentSort = value;
        notifyListeners();
      }
    }
}

