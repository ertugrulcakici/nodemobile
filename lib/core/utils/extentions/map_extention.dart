extension MapExtentions<K, V> on Map {
  List<List> toList() {
    return entries.map((e) => [e.key, e.value]).toList();
  }

  Map<V, K> reverseKeyValue() {
    Map<V, K> temp = {};
    forEach((k, v) => temp[v] = k);
    return temp;
  }
}
