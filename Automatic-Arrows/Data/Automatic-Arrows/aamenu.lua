-- #region Local Menu Functions
local function toggleTutorial(menu)
    AA_ToggleTutorial()
end

local targets = {}
local function changeTargetCategory(menu)
    AA_UncheckAll(targets)

    local dispName = menu.Name
    for _, category in ipairs(AA.loader.visibleCategories) do
        if (category.DisplayName == dispName) then
            AA.AutomaticArrows.workingCategory = category
        end
    end
    AA_AutomaticallyCalculateDistanceSetting()
    menu.Checked = true
end

local mtmit = {}
local function maximumTargets(menu)
    AA_UncheckAll(mtmit)
    AA_SaveValue("maximumTargets", menu.Name)
    AA_ChangeMaxArrows()
    menu.Checked = true
end

local function toggleAA(menu)
    if (AA.AutomaticArrows.arrowsToggledOn == "true") then
        AA.AutomaticArrows.arrowsToggledOn = "false"
    else
        AA.AutomaticArrows.arrowsToggledOn = "true"
        AA_LoadVisibleCategories()
        AA_AutomaticallyCalculateDistanceSetting()
    end

    AA_RefreshTargets()
    menu.Checked = (AA.AutomaticArrows.arrowsToggledOn == "true")
end
-- #endregion Local Menu Functions

-- #region Initial Menu Setup
local mainMenu = Menu:Add("Automatic Arrows", nil)

local stut = mainMenu:Add("Show/Hide Tutorial", toggleTutorial, false, false, "Shows/Hides the tutorial")

local targetMenu = mainMenu:Add("Current Target Category", nil, false, false, "Allows you to change the currently targeted markers, if there are multiple shown currently")

local maxTargMenu = mainMenu:Add("Change Maximum Arrows", nil, false, false, "Allows you to select how many arrows you would like to have shown at once. The arrows will point to the closest X markers")
for i = 1, 5 do
    local numStr = tostring(i)
    mtmit[i] = maxTargMenu:Add(numStr, maximumTargets, true, (AA.storage.maximumTargets == numStr))
end

local toggleMenu = mainMenu:Add("Toggle Automatic Arrows On/Off", toggleAA, true, false, "Toggles Automatic Arrows on/off. Please ensure you have only the markers you want to be guided to visible.")
-- #endregion Initial Menu Setup

-- #region Global Menu Functions
-- Unchecks all menu items in the given table
function AA_UncheckAll(table)
    for _, menuItem in ipairs(table) do
        menuItem.Checked = false
    end
end

-- Refresh the target menu items
function AA_RefreshTargets()
    -- Remove all old targets
    for index, target in ipairs(targets) do
        targetMenu:Remove(target)
        targets[index] = nil
    end

    -- For each visible category loaded, create a new menu item
    for i, category in ipairs(AA.loader.visibleCategories) do
        targets[i] = targetMenu:Add(category.DisplayName, changeTargetCategory, true, (AA.AutomaticArrows.workingCategory.DisplayName == category.DisplayName))
    end

    -- If no targets, show none
    if (targets[1] == nil) then
        targets[1] = targetMenu:Add("None", nil, false, false, "Toggle AA on to load visible categories. If this still shows none, then try restarting AA")
    end
end

-- Unchecks the AA menu toggle
function AA_ToggleMenuOff()
    toggleMenu.Checked = false
end
-- #endregion Global Menu Functions

-- Initial refresh
AA_RefreshTargets()