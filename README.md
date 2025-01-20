# PokeDex

The PokeDex app is a Pokémon data viewer that provides detailed information, stats, and visuals for various Pokémon. It is designed for both iPhone and iPad, offering a smooth and interactive user experience. This repository contains two versions of the app, each showcasing different approaches to iOS development.

## Version 2 (SwiftUI)

The latest version of the app is built using SwiftUI, focusing on modern animations and visual effects.
- Cool animations using ScrollView visual effects.
- New zoom transition to open cards with anchors provided by Swift.
- Fully interactive and visually appealing UI.
- To try this version, switch to the **version2** branch and use the **PokemonSwiftUI** target after cloning.

## Demo
![ScreenRecording2025-01-20at12 22 43-ezgif com-video-to-gif-converter](https://github.com/user-attachments/assets/be2f38d8-5ca1-4516-ad51-fdfb494485e2)

## Version 1 (UIKit)

The original version of the app is built using UIKit, leveraging CollectionView compositional layouts.
- Custom header created using UIBezierPath().
- CollectionView compositional layout to display cards of different sizes based on screen dimensions.
- Diffable data source for seamless data management.
- Custom animations for highlighting/unhighlighting cells.
- Custom transition manager for showing and dismissing Pokémon details.
- Sequential animations to load Pokémon details interactively.

## Demo
![ezgif com-gif-maker](https://user-images.githubusercontent.com/25391160/214637836-5627834d-3263-47ca-8927-697da587bd39.gif)
