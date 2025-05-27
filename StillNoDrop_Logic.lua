if not SND then SND = {} end

if not SND_DB then SND_DB = {} end

function SND:AddRun(runName)
    if runName and runName ~= "" then
        if not SND_DB[runName] then
            SND_DB[runName] = { attempts = 0 }
            return true, "Added!"
        else
            return false, "Run already exists!"
        end
    end
    return false, "Invalid name!"
end

function SND:GetRuns()
    local runs = {}
    for runName, data in pairs(SND_DB) do
        table.insert(runs, {name = runName, attempts = data.attempts or 0})
    end
    table.sort(runs, function(a, b)
        return a.attempts > b.attempts
    end)
    local orderedNames = {}
    for i, v in ipairs(runs) do
        table.insert(orderedNames, v.name)
    end
    return orderedNames
end
