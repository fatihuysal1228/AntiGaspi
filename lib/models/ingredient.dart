/// Un ingrédient que l'utilisateur possède chez lui (son "garde-manger").
class Ingredient {
  final String id;
  final String name;
  final String category;
  final String quantity;

  Ingredient({
    required this.id,
    required this.name,
    required this.category,
    this.quantity = '',
  });

  /// Nom normalisé pour les comparaisons (minuscules, sans accents, sans espaces superflus).
  String get normalizedName => normalize(name);

  static String normalize(String input) {
    var value = input.trim().toLowerCase();
    const withAccents = 'àâäáãåèéêëìíîïòóôöõùúûüçñ';
    const withoutAccents = 'aaaaaaeeeeiiiiooooouuuucn';
    for (var i = 0; i < withAccents.length; i++) {
      value = value.replaceAll(withAccents[i], withoutAccents[i]);
    }
    // Retire un "s" final simple pour matcher singulier/pluriel grossièrement.
    if (value.endsWith('s') && value.length > 3) {
      value = value.substring(0, value.length - 1);
    }
    return value;
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'category': category,
        'quantity': quantity,
      };

  factory Ingredient.fromMap(Map<dynamic, dynamic> map) => Ingredient(
        id: map['id'] as String,
        name: map['name'] as String,
        category: map['category'] as String? ?? 'Autre',
        quantity: map['quantity'] as String? ?? '',
      );

  Ingredient copyWith({String? name, String? category, String? quantity}) =>
      Ingredient(
        id: id,
        name: name ?? this.name,
        category: category ?? this.category,
        quantity: quantity ?? this.quantity,
      );
}

/// Catégories utilisées pour organiser le garde-manger et les recettes.
const List<String> kIngredientCategories = [
  'Fruits & légumes',
  'Féculents',
  'Produits laitiers',
  'Viande & poisson',
  'Épicerie',
  'Épices & condiments',
  'Autre',
];
