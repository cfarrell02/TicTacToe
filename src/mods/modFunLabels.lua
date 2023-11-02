-- Load Penlight's class module
local class = require("pl.class")

-- Define the TicTacToe class
local ModLabels = class.ModLabels()

function ModLabels:_init(game, splashScreen, label)
    self.game = game
    self.splashScreen = splashScreen
    self.modType = "labels"
    self.labels = label
end

function ModLabels:run()
    self.labels:replaceLabel("Main_Title", "Tic Tac Toe Royale!")
    self.labels:replaceLabel("Main_Subtitle", "Press Space To Begin the Battle!")
    self.labels:replaceLabel("Score_Text_Template", "Score %s: %d | Score %s: %d")
    self.labels:replaceLabel("Player_Turn_Template", "Player %s is shaking things up!")
    self.labels:replaceLabel("Save_Button_Label", "Stash Treasure")
    self.labels:replaceLabel("Load_Button_Label", "Loadup")
    self.labels:replaceLabel("Enable_Mods_Button_Label", "Mods Engage")
    self.labels:replaceLabel("Disable_Mods_Button_Label", "Mods Disengage")
    self.labels:replaceLabel("Singleplayer_Button_Label", "Solo Mode")
    self.labels:replaceLabel("Multiplayer_Button_Label", "Multi-Dimensional Mode")
    self.labels:replaceLabel("GridSize_Button_Template", "Grid Size: %d")
    self.labels:replaceLabel("Undo_Button_Label", "Rewind Time")
    self.labels:replaceLabel("Redo_Button_Label", "Forward in Time")
    self.labels:replaceLabel("Win_Text_Template", "%s Claims Victory!")
    self.labels:replaceLabel("Draw_Text", "It's a Stalemate!")
    self.labels:replaceLabel("Invalid_Move_Text", "That's a Silly Move!")
    self.labels:replaceLabel("AI_Pending_Text", "AI Plans a Sneak Attack")
    self.labels:replaceLabel("Undone_Template", "Oops, %s's Move Unhappened")
    self.labels:replaceLabel("Redone_Template", "Rewound and Redone by %s")
    self.labels:replaceLabel("Game_Over_Text", "It's All Over Now")
    self.labels:replaceLabel("Game_Over_Subtitle_Text", "Press Enter to Play Again or Run Away")
    self.labels:replaceLabel("Save_Notification_Text", "Ye Treasure Be Safely Stashed")
    self.labels:replaceLabel("Load_Notification_Text", "Ye Treasure Be Unearthed")
end


function ModLabels:remove()
    LABELS:reloadLabels()
end

return ModLabels