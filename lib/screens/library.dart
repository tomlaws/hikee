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

class _LibraryScreenState extends State<LibraryScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;
  String sort = '';
  List<String> filter = [];
  Color filterColor = Colors.grey;
  Color districtColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    final _LibraryFilter= Provider.of<LibraryFilter>(context);
    final _LibraryDistrict= Provider.of<LibraryDistrict>(context);
    filterColor = (_LibraryFilter.isEmpty())? Colors.grey : Theme.of(context).primaryColor;
    districtColor = (_LibraryDistrict.isEmpty())? Colors.grey : Theme.of(context).primaryColor;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                  TextButton(
                      onPressed: () => {
                            _showSortDialog(context),
                            FocusScope.of(context).unfocus(),
                            setState(() {})
                          },
                      style: TextButton.styleFrom(
                          primary: Theme.of(context).primaryColor),
                      child: Row(
                        children: [
                          Icon(Icons.sort),
                          Text(
                            "Sorting",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      )),

                  // Filter Button
                  TextButton(
                      onPressed: () => {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FilterPage()))
                          },
                      style: TextButton.styleFrom(
                        primary: filterColor,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.filter_list),
                          Text(
                            "Filter",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      )),

                  //District Button
                  TextButton(
                      onPressed: () => {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => DistrictPage()))
                          },
                      style: TextButton.styleFrom(
                        primary: districtColor,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.map),
                          Text(
                            "District",
                            style: TextStyle(fontSize: 15),
                          ),
                        ],
                      ))
                ],
              ),
            ),
            Expanded(
                child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: CustomScrollView(slivers: [
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
              ]),
            )),
          ]),
        ),
      ),
    );
  }

  // Show sort dialog funciton
  _showSortDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) {
        final _LibrarySort = Provider.of<LibrarySort>(context);
        return AlertDialog(
          title: Text("Sorting"),
          content: SingleChildScrollView(
            child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: sortValues
                      .map((e) => RadioListTile<String>(
                            activeColor: Theme.of(context).primaryColor,
                            title: Text(e),
                            value: e,
                            groupValue: _LibrarySort.currentSort,
                            selected: _LibrarySort.currentSort == e,
                            onChanged: (value) {
                              setState(() {});
                              _LibrarySort.updateSort(value!);
                              Navigator.of(context).pop();
                              FocusScope.of(context).unfocus();
                            },
                          ))
                      .toList(),
                )),
          ),
        );
      });
}

// ============Notifier==============
class LibrarySort extends ChangeNotifier {
  String _currentSort = sortValues[0];
  LibrarySort();

  String get currentSort => _currentSort;

  updateSort(String value) {
    if (value != _currentSort) {
      _currentSort = value;
      notifyListeners();
    }
  }
}

class LibraryFilter extends ChangeNotifier {
  List<String> _selectedFilter;
  LibraryFilter(this._selectedFilter);
  RangeValues _rangeValues = RangeValues(0, 12);

  List<String> get selectedFilter => _selectedFilter;

  bool isEmpty() {
    return _selectedFilter.isEmpty;
  }

  clear() {
    _selectedFilter.clear();
    notifyListeners();
  }

  bool isFiltered(String value) => _selectedFilter.contains(value);

  RangeValues getRangeValues(){
    return _rangeValues;
  }

  setRangeValues(RangeValues rangeValues){
    this._rangeValues = rangeValues;
    notifyListeners();
  }

  addFilter(String value) {
    if (!isFiltered(value)) {
      _selectedFilter.add(value);
      notifyListeners();
    }
  }

  removeFilter(String value) {
    if (isFiltered(value)) {
      _selectedFilter.remove(value);
      notifyListeners();
    }
  }


}

class LibraryDistrict extends ChangeNotifier {
  List<String> _selectedDistrict;
  LibraryDistrict(this._selectedDistrict);

  List<String> get selectedDistrict => _selectedDistrict;

  bool isEmpty() {
    return _selectedDistrict.isEmpty;
  }

  clear() {
    _selectedDistrict.clear();
    notifyListeners();
  }

  bool isHaveDistrict(String value) => _selectedDistrict.contains(value);

  addDistrict(String value) {
    if (!isHaveDistrict(value)) {
      _selectedDistrict.add(value);
      notifyListeners();
    }
  }

  removeDistrict(String value) {
    if (isHaveDistrict(value)) {
      _selectedDistrict.remove(value);
      notifyListeners();
    }
  }
}

//=============District=====
class DistrictPage extends StatefulWidget {
  const DistrictPage({Key? key}) : super(key: key);

  @override
  _DistrictPageState createState() => _DistrictPageState();
}

class _DistrictPageState extends State<DistrictPage> {
  @override
  Widget build(BuildContext context) {
    final _LibraryDistrict = Provider.of<LibraryDistrict>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Select District(s)')),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Kowloon :",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Wrap(
              spacing: 5.0,
              runSpacing: 2.0,
              children: kowloonValues
                  .map((e) => FilterChip(
                        label: Text(e),
                        selectedColor: Theme.of(context).primaryColor,
                        onSelected: (value) {
                          setState(() {
                            value
                                ? _LibraryDistrict.addDistrict(e)
                                : _LibraryDistrict.removeDistrict(e);
                          });
                        },
                        selected: _LibraryDistrict.isHaveDistrict(e),
                      ))
                  .toList(),
            ),
            Divider(),
            Text(
              "New Territories :",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Wrap(
              spacing: 5.0,
              runSpacing: 2.0,
              children: newTerriValues
                  .map((e) => FilterChip(
                        label: Text(e),
                        selectedColor: Theme.of(context).primaryColor,
                        onSelected: (value) {
                          setState(() {
                            value
                                ? _LibraryDistrict.addDistrict(e)
                                : _LibraryDistrict.removeDistrict(e);
                          });
                        },
                        selected: _LibraryDistrict.isHaveDistrict(e),
                      ))
                  .toList(),
            ),
            Divider(),
            Text(
              "Hong Kong Island :",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Wrap(
              spacing: 5.0,
              runSpacing: 2.0,
              children: hkIslandValues
                  .map((e) => FilterChip(
                        label: Text(e),
                        selectedColor: Theme.of(context).primaryColor,
                        onSelected: (value) {
                          setState(() {
                            value
                                ? _LibraryDistrict.addDistrict(e)
                                : _LibraryDistrict.removeDistrict(e);
                          });
                        },
                        selected: _LibraryDistrict.isHaveDistrict(e),
                      ))
                  .toList(),
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
                      }),
                ),
                Container(width: 5),
                Expanded(
                  child: Button(
                      child: Text("Apply"),
                      backgroundColor: Theme.of(context).primaryColor,
                      onPressed: () {}),
                ),
              ],
            ),
          ],
        ),
      )),
    );
  }
}

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  _FilterPageState createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  RangeLabels labels = RangeLabels("1", "12");

  @override
  Widget build(BuildContext context) {
    final _LibraryFilter = Provider.of<LibraryFilter>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Select Filter(s)')),
      body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Duration (hour) :",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Row(
                  children: [
                    Text("0"),
                    Expanded(
                      child: RangeSlider(
                        activeColor: Theme.of(context).primaryColor,
                        min: 0,
                        max: 12,
                        divisions: 12,
                        labels: labels,
                        values: _LibraryFilter.getRangeValues(),
                        onChanged: (value){
                          _LibraryFilter.setRangeValues(value);
                          setState(() {
                            labels = RangeLabels(value.start.toInt().toString(), value.end.toInt().toString());
                          });
                        },
                      ),
                    ),
                    Text("12")
                  ],
                ),
                Divider(),
                Text(
                  "View :",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Wrap(
                  spacing: 5.0,
                  runSpacing: 2.0,
                  children: View
                      .map((e) => FilterChip(
                    label: Text(e),
                    selectedColor: Theme.of(context).primaryColor,
                    onSelected: (value) {
                      setState(() {
                        value
                            ? _LibraryFilter.addFilter(e)
                            : _LibraryFilter.removeFilter(e);
                      });
                    },
                    selected: _LibraryFilter.isFiltered(e),
                  ))
                      .toList(),
                ),
                Divider(),
                Text(
                  "Facilities :",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Wrap(
                  spacing: 5.0,
                  runSpacing: 2.0,
                  children: Facilities
                      .map((e) => FilterChip(
                    label: Text(e),
                    selectedColor: Theme.of(context).primaryColor,
                    onSelected: (value) {
                      setState(() {
                        value
                            ? _LibraryFilter.addFilter(e)
                            : _LibraryFilter.removeFilter(e);
                      });
                    },
                    selected: _LibraryFilter.isFiltered(e),
                  ))
                      .toList(),
                ),
                Divider(),
                Text(
                  "Activities :",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Wrap(
                  spacing: 5.0,
                  runSpacing: 2.0,
                  children: Activities
                      .map((e) => FilterChip(
                    label: Text(e),
                    selectedColor: Theme.of(context).primaryColor,
                    onSelected: (value) {
                      setState(() {
                        value
                            ? _LibraryFilter.addFilter(e)
                            : _LibraryFilter.removeFilter(e);
                      });
                    },
                    selected: _LibraryFilter.isFiltered(e),
                  ))
                      .toList(),
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
                              _LibraryFilter.clear();
                              //districtColor = Colors.grey;
                            });
                          }),
                    ),
                    Container(width: 5),
                    Expanded(
                      child: Button(
                          child: Text("Apply"),
                          backgroundColor: Theme.of(context).primaryColor,
                          onPressed: () {}),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
