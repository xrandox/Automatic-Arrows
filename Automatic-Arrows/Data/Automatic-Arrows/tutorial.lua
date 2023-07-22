AA.tutorial = {
    origin = nil,
    page = 1,
    marker = {
        info = {
            "Hey there commander! It looks like you've found my latest and greatest invention...automatic arrows!\n\nI've hooked into Blish's Pathing Module to integrate with other packs you've downloaded, creating arrows that point to the untoggled marker categories\n\nThis is a little tutorial to show you how to use it!\n\n(Press F to continue the tutorial)",
            "First things first, you need to have another pack installed. Once you do, go in and turn off all the categories that you aren't interested in\n\nWhen you're done, your category menu should look something like this:\n\n(Press F to continue the tutorial)",
            "After that, go to Scripts -> Automatic Arrows -> Toggle Automatic Arrows On\n\nAfter toggling them on, the arrows will detect currently visible categories and make arrows pointing to the closest ones!\n\nGreen arrows mean the marker is close, yellow are a medium distance, and red are really far away!\n\nYou can also change the maximum arrows, and the target category from the script menu\n\n(Press F to continue the tutorial)",
            "That's all there is to it! When you're done, you can just toggle the arrows back off\n\nThese arrows are meant for finding markers that don't have their own trail, like achievement markers\n\nIf you ever want to see this tutorial again, you can reopen it from the Script menu!\n\n(Press F to go back to the beginning)"
        },
        icon = {
            "Data/Automatic-Arrows/taimi.png",
            "Data/Automatic-Arrows/tut2.png",
            "Data/Automatic-Arrows/tut1.png",
            "Data/Automatic-Arrows/taimi.png"
        },
        iconSize = { 1, 8, 6, 1 },
        object = nil
    },
    shown = false,
    max = 4
}

Debug:Watch("AA_Tutorial", AA.tutorial)

local function showTutorial()
    local pos = Mumble.PlayerCharacter.Position
    AA.tutorial.origin = pos

    local attributes = {
        xpos = pos.X,
        ypos = pos.Z,
        zpos = pos.Y,
        MapVisibility = false,
        InGameVisibility = true,
        Info = AA.tutorial.marker.info[1],
        iconSize = AA.tutorial.marker.iconSize[1],
        InfoRange = 5,
        ["script-trigger"] = "AA_Flip()"
    }

    local marker = Pack:CreateMarker(attributes)
    marker:SetTexture(AA.tutorial.marker.icon[1])
    AA.tutorial.marker.object = marker

    AA.tutorial.shown = true
    Storage:UpsertValue("automaticarrows", "firstTime", "false")
end

local function hideTutorial()
    AA.tutorial.marker.object:Remove()
    AA.tutorial.shown = false
end

function AA_Flip(marker, isAutoTriggered)
    if (isAutoTriggered == false) then
        local newPage = AA.tutorial.page + 1
        if (newPage > AA.tutorial.max) then newPage = 1 end
        AA.tutorial.page = newPage

        marker:SetTexture(AA.tutorial.marker.icon[newPage])
        marker.Size = AA.tutorial.marker.iconSize[newPage]
        marker:GetBehavior("InfoModifier").InfoValue = AA.tutorial.marker.info[newPage]
    end
end

function AA_ToggleTutorial()
    if (AA.tutorial.shown) then
        hideTutorial()
    else
        showTutorial()
    end
end

local function tutorialTickHandler(gametime)
    if (AA.tutorial.shown) then
        if ((Mumble.PlayerCharacter.Position - AA.tutorial.origin):Length() > 50) then
            hideTutorial()
        end
    end
end

Event:OnTick(tutorialTickHandler)

local isFirstTime = Storage:ReadValue("automaticarrows", "firstTime")
if (isFirstTime == nil) then
    showTutorial()
end