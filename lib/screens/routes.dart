import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_it/get_it.dart';
import 'package:hikee/components/button.dart';
import 'package:hikee/components/hiking_route_tile.dart';
import 'package:hikee/components/text_input.dart';
import 'package:hikee/data/districtValues.dart';
import 'package:hikee/data/sortValues.dart';
import 'package:hikee/data/filterValues.dart';
import 'package:hikee/models/route.dart';
import 'package:hikee/screens/route.dart';
import 'package:hikee/services/route.dart';
import 'package:provider/provider.dart';
import 'package:routemaster/routemaster.dart';

class RoutesScreen extends StatefulWidget {
  const RoutesScreen({Key? key}) : super(key: key);

  @override
  _RoutesScreenState createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen>
    with AutomaticKeepAliveClientMixin {
  bool get wantKeepAlive => true;

  RouteService get _routeService => GetIt.I<RouteService>();
  TextEditingController _searchController = TextEditingController(text: "");
  ScrollController _scrollController = ScrollController();

  List<HikingRoute> _hikingRoutes = [];
  bool _loading = false;
  bool _hasMore = true;

  String query = "";
  String? sort = "length";
  String? order = "ASC";

  //late Future<List<HikingRoute>> _hikingRoutes;

  @override
  void initState() {
    super.initState();
    fetchMore(query: query, sort: sort, order: order);
    _scrollController.addListener(() {
      double diff = _scrollController.position.maxScrollExtent -
          _scrollController.position.pixels;
      if (diff < 500 && !_loading && _hasMore) {
        fetchMore(query: query, sort: sort, order: order);
      }
    });
    _searchController.addListener(() {
      String text = _searchController.text;
      if (query.compareTo(text) != 0) {
        setState(() {
          query = text;
          _hikingRoutes.clear();
          fetchMore(query: query, sort: sort, order: order);
        });
      }
    });
  }

  void fetchMore(
      {String? query, int? after, String? sort, String? order}) async {
    setState(() {
      _loading = true;
    });
    print(sort);
    print(order);
    int? after = _hikingRoutes.isEmpty ? null : _hikingRoutes.last.id;
    List<HikingRoute> routes = await _routeService.getRoutes(
        query: query, after: after, sort: sort, order: order);
    if (mounted) {
      setState(() {
        if (routes.length > 0)
          _hikingRoutes.addAll(routes);
        else
          _hasMore = false;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final _libraryFilter = Provider.of<LibraryFilter>(context);
    final _libraryDistrict = Provider.of<LibraryDistrict>(context);
    List<String> filterValue = [];
    Color filterColor = (_libraryFilter.isEmpty())
        ? Colors.grey
        : Theme.of(context).primaryColor;
    Color districtColor = (_libraryDistrict.isEmpty())
        ? Colors.grey
        : Theme.of(context).primaryColor;

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextInput(
                textEditingController: _searchController,
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
                      onPressed: () async {
                        String newSortValue = await _showSortDialog(context);
                        print(newSortValue);
                        /*if (newSortValue.compareTo(sortValues[0]) == 0) {
                            sort = 'name_en';
                            order = 'ASC';
                          }
                          if (newSortValue.compareTo(sortValues[1]) == 0) {
                            sort = 'name_en';
                            order = 'DESC';
                          }*/
                        if (newSortValue.compareTo(sortValues[0]) == 0) {
                          sort = 'length';
                          order = 'ASC';
                        }
                        if (newSortValue.compareTo(sortValues[1]) == 0) {
                          sort = 'length';
                          order = 'DESC';
                        }
                        if (newSortValue.compareTo(sortValues[2]) == 0) {
                          sort = 'difficulty';
                          order = 'ASC';
                        }
                        if (newSortValue.compareTo(sortValues[3]) == 0) {
                          sort = 'difficulty';
                          order = 'DESC';
                        }
                        setState(() {
                          _hikingRoutes.clear();
                          fetchMore(query: query, sort: sort, order: order);
                        });
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
                child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPadding(
                  padding: EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return HikingRouteTile(
                        route: _hikingRoutes[index],
                        onTap: () {
                          Routemaster.of(context).push('/routes/${_hikingRoutes[index].id}');
                        },
                      );
                    }, childCount: _hikingRoutes.length),
                  ),
                ),
                if (_loading && _hasMore)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    fillOverscroll: true,
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: CircularProgressIndicator(),
                    )),
                  ),
              ],
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
                              Navigator.of(context).pop(value);
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

  RangeValues getRangeValues() {
    return _rangeValues;
  }

  setRangeValues(RangeValues rangeValues) {
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
    final _libraryDistrict = Provider.of<LibraryDistrict>(context);
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
                                ? _libraryDistrict.addDistrict(e)
                                : _libraryDistrict.removeDistrict(e);
                          });
                        },
                        selected: _libraryDistrict.isHaveDistrict(e),
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
                                ? _libraryDistrict.addDistrict(e)
                                : _libraryDistrict.removeDistrict(e);
                          });
                        },
                        selected: _libraryDistrict.isHaveDistrict(e),
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
                                ? _libraryDistrict.addDistrict(e)
                                : _libraryDistrict.removeDistrict(e);
                          });
                        },
                        selected: _libraryDistrict.isHaveDistrict(e),
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
                          _libraryDistrict.clear();
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
    final _libraryFilter = Provider.of<LibraryFilter>(context);
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
                    values: _libraryFilter.getRangeValues(),
                    onChanged: (value) {
                      _libraryFilter.setRangeValues(value);
                      setState(() {
                        labels = RangeLabels(value.start.toInt().toString(),
                            value.end.toInt().toString());
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
              children: View.map((e) => FilterChip(
                    label: Text(e),
                    selectedColor: Theme.of(context).primaryColor,
                    onSelected: (value) {
                      setState(() {
                        value
                            ? _libraryFilter.addFilter(e)
                            : _libraryFilter.removeFilter(e);
                      });
                    },
                    selected: _libraryFilter.isFiltered(e),
                  )).toList(),
            ),
            Divider(),
            Text(
              "Facilities :",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Wrap(
              spacing: 5.0,
              runSpacing: 2.0,
              children: Facilities.map((e) => FilterChip(
                    label: Text(e),
                    selectedColor: Theme.of(context).primaryColor,
                    onSelected: (value) {
                      setState(() {
                        value
                            ? _libraryFilter.addFilter(e)
                            : _libraryFilter.removeFilter(e);
                      });
                    },
                    selected: _libraryFilter.isFiltered(e),
                  )).toList(),
            ),
            Divider(),
            Text(
              "Activities :",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
            ),
            Wrap(
              spacing: 5.0,
              runSpacing: 2.0,
              children: Activities.map((e) => FilterChip(
                    label: Text(e),
                    selectedColor: Theme.of(context).primaryColor,
                    onSelected: (value) {
                      setState(() {
                        value
                            ? _libraryFilter.addFilter(e)
                            : _libraryFilter.removeFilter(e);
                      });
                    },
                    selected: _libraryFilter.isFiltered(e),
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
                          _libraryFilter.clear();
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
