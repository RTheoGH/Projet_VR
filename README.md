# Magicien VR Polyvalent - Maige Academy VR
## M2 IMAGINE

![Godot Engine](https://img.shields.io/badge/GODOT-%23FFFFFF.svg?style=for-the-badge&logo=godot-engine)
![GDScript](https://img.shields.io/badge/GDScript-%2374267B.svg?style=for-the-badge&logo=godotengine&logoColor=white)
![Duckdb](https://img.shields.io/badge/duckdb-%23FFF000.svg?style=for-the-badge&logo=duckdb&logoColor=black)

Projet VR par :
- MANSOUR Andrew
- REYNIER Théo
- VIGUIER Killian
- ZINCK Tom

## Description

Expérience de réalité virtuelle où le joueur incarne un mage dans un univers médiéval. Le joueur peut lancer des sorts via trois méthodes différentes et résoudre des énigmes pour progresser.

## Trois Systèmes de Sorts

### Baguette Magique

Effectuez des mouvements spécifiques avec la baguette pour lancer des sorts. Maintenez le bouton A pour faire apparaître un cercle magique, réalisez le mouvement, puis confirmez.

### Plume Enchantée

Dessinez des runes sur les surfaces interactives. Le système reconnaît les formes dessinées grâce à l'algorithme $Q qui convertit les tracés 3D en nuages de points 2D pour la détection de motifs.

### Livre de Sorts

Prononcez le nom des sorts à voix haute. Le système utilise Godot Whisper pour la reconnaissance vocale et convertit la parole en sorts activables.

## Installation

### Prérequis

- Casque VR avec contrôleurs
- Godot Engine avec support VR
- Modèle de reconnaissance vocale : configurer "tiny.en" dans l'addon Godot Whisper avant le lancement

### Contrôles VR

- Joystick gauche : déplacement
- Gâchette arrière droite : attraper les objets
- Gâchette arrière gauche supérieure : téléportation

## Extensions Utilisées

- Godot XRTools : contrôles et interactions VR
- Godot Whisper : reconnaissance vocale
- Multistroke Gesture Recognizer : détection de formes dessinées

## Analytiques

Le projet inclut un système de collecte de données pour comparer l'efficacité des trois méthodes de sorts. Un questionnaire initial établit le profil du joueur (âge, genre, familiarité avec les jeux vidéo et la VR). Les données de jeu sont enregistrées en temps réel via DuckDB.

## Références

### Addons
- XRTools : https://github.com/GodotVR/godot-xr-tools
- Godot Whisper : https://github.com/V-Sekai/godot-whisper
- Multistroke Gesture Recognizer : https://godotengine.org/asset-library/asset/3964

### Assets
- Medieval Castle Kit : https://rendercrate.com/objects/RenderCrate-Medieval_Castle_Kit
- Medieval Market Low Poly : https://sketchfab.com/3d-models/medieval-market-low-poly-a06ad22defbf4b2b8a18193a9189ca56

Aucune IA générative n'a été utilisée pour la conception de ce projet.
