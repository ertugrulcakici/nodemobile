class Row {
  final Map<String, dynamic> _data;
  Row(this._data);

  dynamic operator [](String key) => _data[key];
  get values => _data.values.toList();
  get keys => _data.keys.toList();
  get length => _data.length;
}
