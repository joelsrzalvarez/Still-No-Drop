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
        table.insert(runs, runName)
    end
    table.sort(runs)
    return runs
end
