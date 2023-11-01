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

TODO: Package game in release section

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

Alternatively, precompiled versions of the game are available in the release section. Please download the latest one.

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

Available in `src/mods/modClickEffects`.

Changes the cursor to be a white circle.

**More to come**


## Submission
### Self Assessment Rubric

Use Markdown table extensions for visual studio code to help.

Each entry should be kept succinct.  Point to documentation where required. A table that does not render correctly will result in lost marks

|               | **Gameplay Mechanics** | **Modding Support** | **User Interface (UI)** | **Code Quality & Extensibility** | **Documentation and Distribution** |
| ------------- | ---------------------- | ------------------- | ----------------------- | -------------------------------- | ---------------------------------- |
| **Starter**   |                        |                     |                         |                                  |                                    |
| **Basic**     |                        |                     |                         |                                  |                                    |
| **Good**      |                        |                     |                         |                                  |                                    |
| **Excellent** |                        |                     |                         |                                  |                                    |


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
