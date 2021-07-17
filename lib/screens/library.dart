import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/hiking_route_tile.dart';
import 'package:hikee/components/text_input.dart';
import 'package:hikee/data/districtValues.dart';
import 'package:hikee/data/routes.dart';
import 'package:hikee/data/sortValues.dart';
import 'package:hikee/data/filterValues.dart';
import 'package:hikee/screens/route.dart';
import 'package:provider/provider.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  String sort = '';
  List<String> filter = [];
  Color filterColor = Colors.grey;
  Color districtColor = Colors.grey;

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
                      //Sort Button
                      TextButton(onPressed: () => {
                        _showSortDialog(context),
                        FocusScope.of(context).unfocus(),
                        setState(
                            (){

                            }
                        )
                      },
                        style: TextButton.styleFrom( primary: Theme.of(context).primaryColor),
                          child: Row(
                            children: [
                              Icon(Icons.sort),
                              Text("Sorting", style: TextStyle(fontSize: 15),),
                            ],
                          )
                      ),

                      // Filter Button
                      TextButton(onPressed: () => {_showFilterDialog(context),FocusScope.of(context).unfocus()},
                          style: TextButton.styleFrom( primary: filterColor,),
                          child: Row(
                            children: [
                              Icon(Icons.filter_list),
                              Text("Filter", style: TextStyle(fontSize: 15),),
                            ],
                          )
                      ),

                      //District Button
                      TextButton(onPressed: () => {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => DistrictPage()))
                      },
                          style: TextButton.styleFrom( primary: districtColor,),
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

  // Show sort dialog funciton
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
                  setState(() {

                  });
                  _LibrarySort.updateSort(value!);
                  Navigator.of(context).pop();
                  FocusScope.of(context).unfocus();
                },
              )).toList(),
            )

        ),
      ),
    );
  });

  // Show filter dialog funciton
  _showFilterDialog(BuildContext context) => showDialog(
    context: context,
    builder: (context){
      final _LibraryFilter= Provider.of<LibraryFilter>(context);
      return AlertDialog(
        title: Text('Filter'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 5.0,
                runSpacing: 5.0,
                children: filterValues.map((e) => FilterChip(
                  label: Text(e),
                  selectedColor: Theme.of(context).primaryColor,
                  //autofocus: _LibraryFilter.isFiltered(e),
                  onSelected: (value){
                    setState(() {
                      value ? _LibraryFilter.addFilter(e) : _LibraryFilter.removeFilter(e);
                      if (_LibraryFilter.isEmpty())
                        filterColor = Colors.grey;
                      else filterColor = Theme.of(context).primaryColor;
                    });
                  },
                  selected: _LibraryFilter.isFiltered(e),
                )).toList(),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Button(
                      child: Text("Clear"),
                      backgroundColor: Colors.grey.withOpacity(0.6),
                      onPressed: () {
                        setState(() {
                          _LibraryFilter.clear();
                          filterColor = Colors.grey;
                        });
                      }
                  ),
                ),
                Container(width:5),
                Expanded(
                  child: Button(
                      child: Text("Filter"),
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () {}
                  ),
                ),
              ],
            ),
          ],
        )
      );
    }
  );
}

// ============Notifier==============
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

class LibraryFilter extends ChangeNotifier{
  List<String> _selectedFilter;
  LibraryFilter(this._selectedFilter);

  List<String> get selectedFilter => _selectedFilter;

  bool isEmpty() {
    return _selectedFilter.isEmpty;
  }

  clear(){
    _selectedFilter.clear();
    notifyListeners();
  }

  bool isFiltered(String value) => _selectedFilter.contains(value);

  addFilter(String value){
    if (!isFiltered(value)) {
      _selectedFilter.add(value);
      notifyListeners();
    }
  }

  removeFilter(String value){
    if (isFiltered(value)){
      _selectedFilter.remove(value);
      notifyListeners();
    }
  }
}

class LibraryDistrict extends ChangeNotifier{
  List<String> _selectedDistrict;
  LibraryDistrict(this._selectedDistrict);

  List<String> get selectedDistrict => _selectedDistrict;

  bool isEmpty() {
    return _selectedDistrict.isEmpty;
  }

  clear(){
    _selectedDistrict.clear();
    notifyListeners();
  }

  bool isHaveDistrict(String value) => _selectedDistrict.contains(value);

  addDistrict(String value){
    if (!isHaveDistrict(value)) {
      _selectedDistrict.add(value);
      notifyListeners();
    }
  }

  removeDistrict(String value){
    if (isHaveDistrict(value)){
      _selectedDistrict.remove(value);
      notifyListeners();
    }
  }
}

//=============District=====
class DistrictPage extends StatefulWidget{
  const DistrictPage({Key? key}) : super(key: key);

  @override
  _DistrictPageState createState() => _DistrictPageState();
}

class _DistrictPageState extends State<DistrictPage>{
  @override
  Widget build(BuildContext context) {
    final _LibraryDistrict = Provider.of<LibraryDistrict>(context);
    return Scaffold(
      appBar: AppBar( title: Text('Select District(s)')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Kowloon :",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
              Wrap(
                spacing: 5.0,
                runSpacing: 5.0,
                children: kowloonValues.map((e) => FilterChip(
                  label: Text(e),
                  selectedColor: Theme.of(context).primaryColor,
                  onSelected: (value){
                    setState(() {
                      value ? _LibraryDistrict.addDistrict(e) : _LibraryDistrict.removeDistrict(e);
                     // if (_LibraryDistrict.isEmpty())
                     //   districtColor = Colors.grey;
                     // else districtColor = Theme.of(context).primaryColor;
                    });
                  },
                  selected: _LibraryDistrict.isHaveDistrict(e),
                )).toList(),
              ),
              Text("New Territories :",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
              Wrap(
                spacing: 5.0,
                runSpacing: 5.0,
                children: newTerriValues.map((e) => FilterChip(
                  label: Text(e),
                  selectedColor: Theme.of(context).primaryColor,
                  onSelected: (value){
                    setState(() {
                      value ? _LibraryDistrict.addDistrict(e) : _LibraryDistrict.removeDistrict(e);
                     // if (_LibraryDistrict.isEmpty())
                      //  districtColor = Colors.grey;
                      //else districtColor = Theme.of(context).primaryColor;
                    });
                  },
                  selected: _LibraryDistrict.isHaveDistrict(e),
                )).toList(),
              ),
              Text("Hong Kong Island :",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
              Wrap(
                spacing: 5.0,
                runSpacing: 5.0,
                children: hkIslandValues.map((e) => FilterChip(
                  label: Text(e),
                  selectedColor: Theme.of(context).primaryColor,
                  onSelected: (value){
                    setState(() {
                      value ? _LibraryDistrict.addDistrict(e) : _LibraryDistrict.removeDistrict(e);
                      //if (_LibraryDistrict.isEmpty())
                       // districtColor = Colors.grey;
                      //else districtColor = Theme.of(context).primaryColor;
                    });
                  },
                  selected: _LibraryDistrict.isHaveDistrict(e),
                )).toList(),
              ),
              Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Button(
                        child: Text("Clear"),
                        backgroundColor: Colors.grey.withOpacity(0.6),
                        onPressed: () {
                          setState(() {
                            _LibraryDistrict.clear();
                            //districtColor = Colors.grey;
                          });
                        }
                    ),
                  ),
                  Container(width:5),
                  Expanded(
                    child: Button(
                        child: Text("Apply"),
                        backgroundColor: Theme.of(context).primaryColor,
                        onPressed: () {}
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
      ),
    );
  }
}