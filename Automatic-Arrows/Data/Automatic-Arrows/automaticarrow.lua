local attributes = {
    InGameVisibility = true,
    MiniMapVisibility = false,
    MapVisibility = false,
    IconSize = 0.75,
}

AA.AutomaticArrows = {
    arrowsToggledOn = "false",
    arrows = nil,
    distance = {},
    workingCategory = nil
}

Debug:Watch("AA_AutomaticArrows", AA.AutomaticArrows)

-- Generates a new group of arrows
local function generateNewArrowGroup()
    AA.AutomaticArrows.arrows = {}

    -- Create maximumTargets number of arrows
    for _ = 1, AA.storage.maximumTargets + 0 do
        local arrow = Pack:CreateMarker(attributes)
        arrow:SetTexture("Data/Automatic-Arrows/arrow.png")
        table.insert(AA.AutomaticArrows.arrows, arrow)
    end
end

-- Cleans up any existing markers
local function cleanupMarkers()
    if (AA.AutomaticArrows.arrows == nil) then return end

    for _, marker in pairs(AA.AutomaticArrows.arrows) do
        marker:Remove()
    end

    AA.AutomaticArrows.arrows = nil
end

-- Cleans up all the stuff needed to stop animating the arrows
local function stopAnimating()
    AA.AutomaticArrows.arrowsToggledOn = "false"
    AA_RefreshTargets()
    AA_ToggleMenuOff()
end

-- Animates the arrows to point towards their target
local function animate()
    -- Get closest markers in working category
    local closestMarkers = World:GetClosestMarkers(AA.AutomaticArrows.workingCategory, AA.storage.maximumTargets + 0)

    -- If no markers to point to, clean up the arrows
    if (closestMarkers[1] == nil) then return stopAnimating() end

    -- If we dont have any arrows, generate them
    if (AA.AutomaticArrows.arrows == nil) then generateNewArrowGroup() end

    -- For each arrow, do calculations and move/rotate/tint it accordingly
    for i, marker in ipairs(AA.AutomaticArrows.arrows) do
        if (closestMarkers[i] == nil) then
            marker.InGameVisibility = false
            return
        end

        marker.InGameVisibility = true
        -- Vector calculations
        local playerPos = Mumble.PlayerCharacter.Position
        local target = closestMarkers[i]
        local vector = (target.Position - playerPos)
        vector = vector / vector:Length()
        local markerPos = playerPos + vector * 2

        -- Set pos and rotation
        marker:SetPos(markerPos.X, markerPos.Y, markerPos.Z - 1.5)
        marker:SetRotZ(math.atan2(vector.Y, vector.X) - math.pi / 2)
        marker:SetRotX(math.atan(vector.Z, vector.X))

        -- Get distance
        local distance = target.DistanceToPlayer
        AA.AutomaticArrows.distance[i] = distance

        -- If player is close, lets remove it to simulate 'collecting' it
        if (distance < 3) then
            target:Remove()
        end

        -- Now tint based on distance
        marker.Tint = AA_InterpolateColorByDistance(distance)
    end
end

-- Cleans up the old markers and generates a new group with the new max amount
function AA_ChangeMaxArrows()
    cleanupMarkers()
    generateNewArrowGroup()
end

-- If turned on, animates the arrows, otherwise cleans up any leftover markers, or nothing
function AA_TickHandler(gameTime)
    if (AA.AutomaticArrows.arrowsToggledOn == "true") then
        animate()
    elseif (AA.AutomaticArrows.arrows ~= nil) then
        cleanupMarkers()
    end
end