/// Un article de la liste de courses.
class ShoppingItem {
  final String id;
  final String name;
  final String quantity;
  final String category;
  final bool checked;
  final String? sourceRecipeTitle;

  ShoppingItem({
    required this.id,
    required this.name,
    this.quantity = '',
    this.category = 'Autre',
    this.checked = false,
    this.sourceRecipeTitle,
  });

  ShoppingItem copyWith({
    String? name,
    String? quantity,
    String? category,
    bool? checked,
    String? sourceRecipeTitle,
  }) =>
      ShoppingItem(
        id: id,
        name: name ?? this.name,
        quantity: quantity ?? this.quantity,
        category: category ?? this.category,
        checked: checked ?? this.checked,
        sourceRecipeTitle: sourceRecipeTitle ?? this.sourceRecipeTitle,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'quantity': quantity,
        'category': category,
        'checked': checked,
        'sourceRecipeTitle': sourceRecipeTitle,
      };

  factory ShoppingItem.fromMap(Map<dynamic, dynamic> map) => ShoppingItem(
        id: map['id'] as String,
        name: map['name'] as String,
        quantity: map['quantity'] as String? ?? '',
        category: map['category'] as String? ?? 'Autre',
        checked: map['checked'] as bool? ?? false,
        sourceRecipeTitle: map['sourceRecipeTitle'] as String?,
      );
}
