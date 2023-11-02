[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-24ddc0f5d75046c5622901739e7c5dd533143b0c8e959d652212380cedb1ea36.svg)](https://classroom.github.com/a/aMX_0OFj)
[![Open in Visual Studio Code](https://classroom.github.com/assets/open-in-vscode-718a45dd9cf7e7f842a935f5ebbe5719a5e09af4491e668f4dbf3b35d5cca122.svg)](https://classroom.github.com/online_ide?assignment_repo_id=12208532&assignment_repo_type=AssignmentRepo)
# setu-mobile-game-dev-1-2023-assignment-1

## The Assignment

Provided this Tic Tac Toe game in Lua, improve, augment and add in the following categories:

|               | **Gameplay Mechanics**                                                             | **Modding Support**                                                                                         | **User Interface (UI)**                                           | **Code Quality & Extensibility**                               | **Documentation and Distribution**                                             |
| ------------- | ---------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------- | -------------------------------------------------------------- | ------------------------------------------------------------------------------ |
| **Starter**   | Basic rules implemented, games ends in draw or win                                 | Modding possible but lacks docs. Minimal mods available.                                                    | Functional but lacks user-friendliness.                           | Basic codebase structure.                                      | Limited README                                                                 |
| **Basic**     | Customizable Grid size (natively selectable, not mod)                              | Basic modding documentation. More mods available.                                                           | Clear and intuitive CLI interface.                                | Reasonably organized code. Mods external to source             | README to guide a developer                                                    |
| **Good**      | Undo, redo, score tracking/persistence, highscores, user profiles, continue game   | Well-documented modding tools. Separate from source.                                                        | Splash screens, options menu, high score UI                       | Clear, concise, encapsulated code. Class structures (or other) | User guide to aid modders                                                      |
| **Excellent** | "AI" opponent (local implementation in lua, will be graded based on effectiveness) | Modding framework documented,  inspiration of framework documented, mods that truly enhance the experience, | Modder-created UI themes.  Responds to events from event handler. | Exemplary moddable code. Coding style documented               | Deployable artefact that can run and is documented, modding process documented |


Note, the above is guidance only.  Feel free to highlight where you feel you have excelled.  This assignment will be 30% of your final grade.

# Submission

1. You must use the github classroom repository and commits should be spread over time
2. The grading rubric at the end of this README must be filled in to highlight the areas you believe you deserve marks
3. A video showcasing features and modding must be provided, break it into 2.  The game and modding.  Area provided below to provide link.
3. Everything must be contained in this repository
4. A Moodle submission link will be provided to upload a zip of the repository before the deadline
5. Deadline is Wednesday the 1st of November 2023, 11am.
6. Non response to issues with submission or non response to questions will result in 10% lost for each incident
7. You may be asked to attend an interview to verify your work, the likelihood of this increases if:
    1. You are not attending lab/lectures
    2. Your labs repository is way behind
    3. You do not commit over time
    4. Suspicion of plagiarism
    5. Particularly weak submission 
8. The use of generative AI is not permitted to generate source code or documentation in this assignment (copilot, chatgpt, or otherwise, locally or hosted)
    1. Generative AI is an excellent tool but you risk not learning fundamental skills by relying on it too soon
9. Usage of any published source should be referenced and documented via comments, you may be asked to explain inner workings of such usages
10. Feel free to have a separate docs directory within the repository e.g. docs/gameplay & docs/modding, docs in markdown only and rendering via github 
11. Remember this is 30%, you could go overboard, feel free to highlight where you paid particular attention to quality over quantity or vice versa
12. Comprehension of Lua is the main objective here.  Look into how Lua is used in modding and go for a lite version.

## Setup Instructions

* Student Number: 20094046    
* Name: Cian Farrell
* GitHub username: cfarrell02

## Installing

Game is available in release section.

### Lua

Required Lua 5.4.6

### Love2D

This game runs on the Love2D game engine. It is required to run the game.

### Modules

```
luarocks install penlight
```

## Starting the game

To play:

```
love ./src
```

Alternatively, precompiled versions of the game are available in the release section. Please download the latest one for your platform. 

- Windows: Download the zip and run the exe file. Note. The zip also contains dlls that are crucial to running the game.
- MacOS: TODO.

## Mods


### ModPlayerIcons

Available in `src/mods/modPlayerIcons`.

Augments the icons used per player.

### ModTheme

Available in `src/mods/modTheme.lua`.

Switches the game to a dark mode theme

### ModBackgroundEffect

Available in `src/mods/modBackgroundEffects.lua`.

Changes the background of the game randomly every second

### ModClickEffect

Available in `src/mods/modClickEffects.lua`.

Changes the cursor to be a white circle.

### ModFunLabels

Available in `src/mods/modFunLabels.lua`.

Changes all text to be pirate themed, Y'arr!

## Create your own mods.

When building a mod you will have access to 3 object that can be used to manipulate the game. The basic layout of a mod is shown here.

```
-- Load Penlight's class module
local class = require("pl.class")

-- Define the TicTacToe class
local GenericMod = class.GenericMod()

function GenericMod:_init(game, splashScreen, gameOverScreen, label)
    self.game = game
    self.splashScreen = splashScreen
    self.gameOverScreen = gameOverScreen
    self.modType = "theme" -- Must specify if mod is to do with labels or not
end


function GenericMod:run()
    -- Code to manipulate game
end

function GenericMod:remove()
    -- Removal of code
end

return GenericMod
```

### Game
This will be supplied as "game. Here is a list of items that can be modified in this object.

**Variables:**

- boardSize (Num): The number of tiles high/wide the board is.
- playerOne (String): The string of player one.
- playerTwo (String): The string of player two.
- padding (Num): The amount of space on all sides of the board.
- tileWidth (Num): The width of the tiles.
- backgroundColor (Table): The background colour, takes the form {R,G,B} where R G and B are values from 0-1.
- gameOverDelay (Num): Delay in seconds at the end of the game.

**Functions:**

- registerModDrawFunction(func): Adds a function the draw table, this will be called in the love.draw function.
- clearModDrawFunctions(): Removes all mod functions from the draw table.
- setPlayerIcons(playerOneIcon, playerTwoIcon): Takes in two strings and sets the string for each player.
- setTheme(theme): Takes in "dark" or "light" and sets the theme based on that.

Other functions and variables are available, however it is recommended not to alter them.

### Splashscreen

**Variables:**

- blinkDuration (Num): Time in seconds taken for subtitle text to blink.

Other functions and variables are available, however it is recommended not to alter them.

### Labels

**Functions:**

- getLabel(key): This will return a label for a given key.
- replaceLabel(key, value): This will replace a label for a given key, returning "Label not found" if unsuccessful.
- addLabel(key, value): This will add a label for a given key, returning "Label already exists" if unsuccessful.
- reloadLabels(): This will reload all labels to the default state.

**Preexising label keys:**

- Main_Title
- Main_Subtitle
- Score_Text_Template
- Player_Turn_Template
- Save_Button_Label
- Load_Button_Label
- Enable_Mods_Button_Label
- Disable_Mods_Button_Label
- Singleplayer_Button_Label
- Multiplayer_Button_Label
- GridSize_Button_Template
- Undo_Button_Label
- Redo_Button_Label
- Win_Text_Template
- Draw_Text
- Invalid_Move_Text
- AI_Pending_Text
- Undone_Template
- Redone_Template
- Game_Over_Text
- Game_Over_Subtitle_Text
- Save_Notification_Text
- Load_Notification_Text
- Incompatible_Save_Notification_Text

## Submission
### Self Assessment Rubric

Use Markdown table extensions for visual studio code to help.

Each entry should be kept succinct.  Point to documentation where required. A table that does not render correctly will result in lost marks

|               | **Gameplay Mechanics** | **Modding Support** | **User Interface (UI)** | **Code Quality & Extensibility** | **Documentation and Distribution** |
| ------------- | ---------------------- | ------------------- | ----------------------- | -------------------------------- | ---------------------------------- |
| **Starter**   |Game logic is fully implemented, wins/draws are recognised|Modding is possible with documentation in readme|Functional Love2D UI |Codebase exists|ReadMe Exists|
| **Basic**     |Grid is selectable from splashscreen|Modding documentation and mods are available|Clear and intuitive Love2D interface|Codebase is reasonably organised into classes |ReadMe has been updated to guide developers on codebase. |
| **Good**      |Undo, Redo and score tracking is available. Persistance is also available.|Modding is well documented and mostly seperate from source |Pretty splashscreen/gameover screen is available. Effects added to splashscreen with Love2D|Code is clear and concise, classes are used.|User guide to aid modders available in readme|
| **Excellent** |AI opponent with reasonable effectiveness |Modding framework documented. Amazing mods available in mods folder|Modded themes are available.|Code is easy to manipulate with mods.|Deployable artefacts are available.|


### Video Link

Part 1 (or video 1): Gameplay & features 
Part 2 (or video 2): Modding
Video Link:

### Checklist

1. Final push to github repository?
2. Documentation added to repo?
3. Video links added to README?
4. Grading Rubric filled in?
5. Zip of repository uploaded to Moodle?
