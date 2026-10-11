# Anti-Gaspi

Application mobile (Flutter, Android) pour réduire le gaspillage alimentaire.

## Fonctionnalités (v1)

- **Mes ingrédients** : liste de ce que tu as chez toi, organisée par catégorie.
- **Recettes anti-gaspi** : suggestions triées par pourcentage d'ingrédients déjà disponibles, avec filtres par catégorie et "prêtes à cuisiner".
- **Liste de courses intelligente** : génère automatiquement la liste des ingrédients manquants pour une recette choisie, plus ajout manuel et cases à cocher.

Tout est stocké localement sur l'appareil (Hive), sans compte ni connexion internet requise.

## Compilation

Le fichier `.apk` est généré automatiquement par la pipeline GitHub Actions (`.github/workflows/build-apk.yml`) à chaque push sur `main`, et peut aussi être déclenché manuellement depuis l'onglet **Actions** du dépôt (« Run workflow »). L'APK compilé est disponible en téléchargement dans les **Artifacts** du run.

### En local (si Flutter est installé sur ta machine)

```bash
flutter create --platforms=android --org com.fatih .
flutter pub get
flutter build apk --release
```

L'APK se trouve ensuite dans `build/app/outputs/flutter-apk/app-release.apk`.

## Prochaines étapes avant publication sur le Play Store

- Créer une icône d'application personnalisée (actuellement l'icône Flutter par défaut).
- Générer une clé de signature de release et configurer `android/key.properties` (actuellement signé avec la clé debug, insuffisant pour publier).
- Rédiger la fiche Play Store (captures d'écran, description, politique de confidentialité).
- Créer un compte développeur Google Play (frais unique de 25 USD).
