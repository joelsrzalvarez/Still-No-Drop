# Still No Drop

**Still No Drop** is a simple, lightweight addon for World of Warcraft: Wrath of the Lich King (WotLK) that helps you track your farming attempts for rare drops—such as mounts, pets, or other collectibles.

## Features

- Easily add and manage a list of “runs” (targets you’re farming for), with custom names.
- Track your attempts for rare mount and item drops by incrementing or decrementing counts.
- Mark a run as completed (“Got it!”), which highlights the row in green and disables further changes.
- Report your farming progress to chat with a single click.
- Displays a clear, numbered list of all your saved runs.
- Pagination: Only 10 runs are shown per page; use navigation buttons to switch pages.
- Data is automatically saved between sessions using WoW’s SavedVariables system.
- Clean, minimalist UI with an easy-to-use slash command (/snd).

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

### Pagination

If you are tracking more than 10 runs, the addon will automatically split them into pages. Use the navigation buttons at the bottom to switch between pages and view all your runs. Each page shows up to 10 runs.
