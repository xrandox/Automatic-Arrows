-- Constants
local far = I:Color(179, 16, 11)
local mid = I:Color(176, 137, 21)
local on = I:Color(48, 252, 3)
AA.distanceSettings = {
    Long = { 600, 300, 3, "For markers that are separated by long distances"},
    Medium = {300, 150, 3, "For markers that aren't really far apart, but aren't close"},
    Close = {200, 75, 3, "For markers that are close together"},
    Auto = { 0, 0, 3, "Auto-calibrate"}
}

Debug:Watch("AA_Dist", AA.distanceSettings)

-- Calibrates the far and medium distance settings based on the mean distance between all markers
function AA_AutomaticallyCalculateDistanceSetting()
    -- Get an arbitrarily large amount of markers
    local markers = World:GetClosestMarkers(AA.AutomaticArrows.workingCategory, 200)

    local tDist = 0
    local tMarkers = 0

    -- For each marker, get the length (distance) between it and all other markers, add that to totals
    for i = 1, #markers do
        for j = i + 1, #markers do
            local distance = (markers[i].Position - markers[j].Position):Length()
            tDist = tDist + distance
            tMarkers = tMarkers + 1
        end
    end

    -- Get mean of totals
    local mean = tDist / tMarkers

    -- Calculate a far and medium number based off of that mean
    AA.distanceSettings.Auto[1] = mean - (mean / 4)
    AA.distanceSettings.Auto[2] = mean / 4
end

-- Returns a Color depending on how large the given distance is, calibrated to the current distance setting
function AA_InterpolateColorByDistance(distance)
    local distanceLimits = AA.distanceSettings["Auto"]

    local red = 0
    local green = 0
    local blue = 0

    if distance >= distanceLimits[1] then
        red = far.R
        green = far.G
        blue = far.B
    elseif distance >= distanceLimits[2] then
        local mappedValue = 1 - (distance - distanceLimits[2]) / (distanceLimits[1] - distanceLimits[2])
        red = far.R + ((mid.R - far.R) * mappedValue)
        green = far.G + ((mid.G - far.G) * mappedValue)
        blue = far.B + ((mid.B - far.B) * mappedValue)
    elseif distance > distanceLimits[3] then
        local mappedValue = distance / distanceLimits[2]
        red = on.R + ((mid.R - on.R) * mappedValue)
        green = on.G + ((mid.G - on.G) * mappedValue)
        blue = on.B + ((mid.B - on.B) * mappedValue)
    else
        red = on.R
        green = on.G
        blue = on.B
    end

    return I:Color(red, green, blue)
end