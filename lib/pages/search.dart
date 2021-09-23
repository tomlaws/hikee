import 'package:flutter/material.dart';
import 'package:hikee/components/core/app_bar.dart';
import 'package:hikee/components/core/infinite_scroll.dart';
import 'package:hikee/components/core/text_input.dart';
import 'package:hikee/old_providers/pagination_change_notifier.dart';
import 'package:provider/provider.dart';

class SearchPage<P extends AdvancedPaginationChangeNotifier<T, dynamic>, T>
    extends StatefulWidget {
  final Widget Function(T item) builder;
  const SearchPage({Key? key, required this.builder}) : super(key: key);

  @override
  _SearchPageState<P, T> createState() => _SearchPageState<P, T>();
}

class _SearchPageState<P extends AdvancedPaginationChangeNotifier<T, dynamic>,
    T> extends State<SearchPage<P, T>> {
  TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<P>().clearState());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: HikeeAppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: TextInput(
                  textEditingController: _searchController,
                  hintText: 'Search...',
                  textInputAction: TextInputAction.search,
                  icon: Icon(Icons.search),
                  autoFocus: true,
                  onSubmitted: (q) {
                    context.read<P>().query = q;
                  },
                ),
              ),
            ],
          ),
        ),
        body: InfiniteScroll<P, T>(
          init: false,
          selector: (p) => p.items,
          separator: SizedBox(
            height: 8,
          ),
          builder: (item) {
            return widget.builder(item);
          },
          fetch: (next) {
            return context.read<P>().fetch(next);
          },
        ));
  }
}
