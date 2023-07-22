AA.AutomaticArrows = {
    arrowsToggledOn = "false",
    maximumTargets = "3",
    arrows = nil,
    distance = {},
    workingCategory = nil
}

AA.storage = {
    arrowsToggledOn = "false",
    maximumTargets = "3",
}

Debug:Watch("AA_AutomaticArrows", AA.AutomaticArrows)

-- Check for stored values
for key, default in pairs(AA.storage) do
    local storedValue = Storage:ReadValue("automaticarrows", key)
    if (storedValue ~= nil) then
        AA.AutomaticArrows[key] = storedValue
    else
        AA.AutomaticArrows[key] = default
    end
end

local function createArrow()
    local arrow = Pack:CreateMarker({
        InGameVisibility = true,
        MiniMapVisibility = false,
        MapVisibility = false,
        IconSize = 0.75,
    })

    arrow:SetTexture("Data/Automatic-Arrows/arrow.png")

    table.insert(AA.AutomaticArrows.arrows, arrow)
end

local function cleanupMarkers()
    Debug:Print("Cleaning up markers")

    if (AA.AutomaticArrows.arrows == nil) then return end

    for _, marker in pairs(AA.AutomaticArrows.arrows) do
        marker:Remove()
    end
    AA.AutomaticArrows.arrows = nil
end

local function generateNewArrowGroup()
    Debug:Print("Generating new arrow group")
    AA.AutomaticArrows.arrows = {}
    for i = 1, AA.AutomaticArrows.maximumTargets + 0 do
        createArrow()
    end
end

local function point()

    local closestMarkers = World:GetClosestMarkers(AA.AutomaticArrows.workingCategory, AA.AutomaticArrows.maximumTargets + 0)

    if (AA.AutomaticArrows.arrows == nil) then
        generateNewArrowGroup()
    end

    for i, marker in ipairs(AA.AutomaticArrows.arrows) do
        local playerPos = Mumble.PlayerCharacter.Position
        local target = closestMarkers[i]
        local vector = (target.Position - playerPos)
        vector = vector / vector:Length()
        local markerPos = playerPos + vector * 2
        local markerVector = (target.Position - markerPos)
        markerVector = markerVector / markerVector:Length()

        marker:SetPos(markerPos.X, markerPos.Y, markerPos.Z - 1.5)
        marker:SetRotZ(math.atan2(markerVector.Y, markerVector.X) - math.pi / 2)
        marker:SetRotX(math.atan(markerVector.Z, markerVector.X))

        -- get distance
        local distance = (target.Position - playerPos):Length()
        AA.AutomaticArrows.distance[i] = distance
        -- if close, lets delete it because we've 'collected' it
        if (distance < 3) then
            target:Remove()
        end

        -- tint from distance
        local tint = AA_InterpolateColorByDistance(distance)
        marker.Tint = tint
    end
end

AA_LoadVisibleCategories()
AA.AutomaticArrows.workingCategory = AA.loader.visibleCategories[1]

function AA_ChangeMaxArrows()
    Debug:Print("Changing Max Arrows")
    cleanupMarkers()
    generateNewArrowGroup()
end

function AA_TickHandler(gameTime)
    if (AA.AutomaticArrows.arrowsToggledOn == "true") then
        point()
    elseif (AA.AutomaticArrows.arrows ~= nil) then
        cleanupMarkers()
    end
end