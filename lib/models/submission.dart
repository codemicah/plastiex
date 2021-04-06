class Submission {
  final String name, user, avartar, type, location, price;
  final int quantity, worth, capacity;
  final bool isPending;
  final DateTime date;

  Submission({
    this.name = "",
    this.user,
    this.type = 'Bottle',
    this.quantity,
    this.worth = 0,
    this.capacity,
    this.isPending = true,
    this.avartar = "",
    this.date,
    this.location,
    this.price = "0",
  });
}
