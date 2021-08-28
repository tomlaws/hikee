enum Order {
  ASC,
  DESC
}

extension OrderExtension on Order {
  get name => ['Ascending', 'Descending'][this.index];
}