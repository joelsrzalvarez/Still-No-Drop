# Still No Drop

**Still No Drop** is a simple, lightweight addon for World of Warcraft: Wrath of the Lich King (WotLK) that helps you track your farming attempts for rare drops—such as mounts, pets, or other collectibles.

## Features

- Easily add and manage a list of “runs” or targets you’re farming for
- Input new runs with a custom name, right in the addon’s interface
- Displays a numbered list of all your saved runs
- Data is automatically saved between sessions using WoW’s SavedVariables system
- Clean, minimalist UI with an easy-to-use slash command

## Installation

1. Download or clone this repository.
2. Extract the folder into:
   ```
   World of Warcraft/_classic_/Interface/AddOns/
   ```
3. Make sure the folder name is **StillNoDrop** and contains the `.toc` and `.lua` files.
4. Enable the addon on the character select screen in-game.

## Usage

- Type `/snd` in the chat to open or close the Still No Drop window.
- To add a new run, type a name into the input box and click `OK`.
- Your run will appear in the “My runs” list below.
- All data is automatically saved; you can /reload, log out, or close WoW without losing your runs.

## How does it save your data?

Still No Drop uses WoW’s built-in `SavedVariables` feature to store your runs.  
All your run names are saved in a file:
