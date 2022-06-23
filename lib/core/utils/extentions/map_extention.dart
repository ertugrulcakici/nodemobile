extension MapExtentions<K, V> on Map {
  List<List> toList() {
    return entries.map((e) => [e.key, e.value]).toList();
  }

  Map<V, K> reverseKeyValue() {
    Map<V, K> temp = {};
    forEach((k, v) => temp[v] = k);
    return temp;
  }

  bool containsValues(Map<K, V> other) {
    for (var key in other.keys) {
      if (this[key] != other[key]) {
        return false;
      }
    }
    return true;
  }
}
