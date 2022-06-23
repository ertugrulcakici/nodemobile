import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchView extends ConsumerStatefulWidget {
  final String label;
  final String titleKey;
  final List<dynamic> subTitles = [];
  final List<String> searchBy;
  final List<Map<String, dynamic>> data;
  SearchView(
      {Key? key,
      required this.label,
      required this.data,
      required this.titleKey,
      subTitles,
      required this.searchBy})
      : super(key: key) {
    if (subTitles != null) {
      this.subTitles.addAll(subTitles);
    }
  }

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SecmeEkraniViewState();
}

class _SecmeEkraniViewState extends ConsumerState<SearchView> {
  late TextEditingController _searchController;
  List<Map<String, dynamic>> filteredData = [];
  @override
  void initState() {
    filteredData.addAll(widget.data);
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(),
          body: Padding(
            padding: EdgeInsets.all(0.025.sh),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextField(
                  onChanged: _search,
                  decoration: InputDecoration(
                    labelText: widget.label,
                    hintText: widget.label,
                  )),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> element = filteredData[index];
                    String subtitleString = "";
                    if (widget.subTitles.isNotEmpty) {
                      for (String subtitleKey in widget.subTitles) {
                        subtitleString +=
                            "$subtitleKey: ${element[subtitleKey]}\n";
                      }
                    }
                    return ListTile(
                      title: Text(element[widget.titleKey].toString()),
                      subtitle: Text(subtitleString.trimRight()),
                      onTap: () {
                        Navigator.pop(context, element);
                      },
                    );
                  },
                ),
              )
            ]),
          )),
    );
  }

  void _search(String value) {
    filteredData.clear();
    for (Map<String, dynamic> element in widget.data) {
      String searchString = widget.searchBy
          .map((searchKey) => element[searchKey])
          .toList()
          .join(" ");
      if (value.split(" ").every(
          (part) => searchString.toLowerCase().contains(part.toLowerCase()))) {
        filteredData.add(element);
      }
    }
    setState(() {});
  }
}
