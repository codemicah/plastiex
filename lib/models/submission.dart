class Submission {
  final String name, uid, avartar, type;
  final int quantity, worth, capacity;
  final bool isPending;

  Submission({
    this.name = "",
    this.uid,
    this.type = 'Bottle',
    this.quantity,
    this.worth,
    this.capacity,
    this.isPending = true,
    this.avartar = "",
  });
}
