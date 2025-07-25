arkeo = arkeo or {}

function ShowProgressBar(label, duration)
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "arkeo-ui:showProgressBar",
        data = {
            label = label or "Doing something...",
            duration = duration or 3000
        }
    })
end

function CancelProgressBar()
    SendNUIMessage({ action = "arkeo-ui:cancelProgressBar" })
    SetNuiFocus(false, false)
end

function Notification(message, notificationType, duration, title)
    SendNUIMessage({
        action = "arkeo-ui:addNotification",
        data = {
            type = notificationType,     
            title = title or "",          
            message = message,
            duration = duration or 5000   
        }
    })
    SetNuiFocus(false, false)
end

function ShowMissionCard(title, message)
    SendNUIMessage({
        action = "arkeo-ui:showMissionCard",
        data = {
            title = title or "",
            message = message or ""
        }
    })
    SetNuiFocus(false, false)
end

function HideMissionCard()
    SendNUIMessage({
        action = "arkeo-ui:hideMissionCard"
    })
    SetNuiFocus(false, false)
end

local Promise = {}
Promise.__index = Promise
function Promise:new()
    return setmetatable({resolved = false, value = nil}, Promise)
end
function Promise:resolve(val)
    if self.resolved then return end -- prevent double-resolve
    self.resolved = true
    self.value = val
end
function Promise:wait()
    while not self.resolved do Wait(0) end
    return self.value
end

local lastPromise = nil

function arkeo.progressBar(args)
    local label = args.label or "Doing something..."
    local duration = args.duration or 3000

    local promise = Promise:new()
    lastPromise = promise

    ShowProgressBar(label, duration)

    local result = promise:wait()
    lastPromise = nil
    SetNuiFocus(false, false)
    return result
end

RegisterNUICallback('CancelProgressBar', function(_, cb)
    if lastPromise and not lastPromise.resolved then
        lastPromise:resolve(false)
        CancelProgressBar()
    end
    cb({})
end)

RegisterNUICallback('ProgressBarDone', function(_, cb)
    if lastPromise and not lastPromise.resolved then
        lastPromise:resolve(true)
    end
    cb({})
end)

RegisterNUICallback('ProgressBarCancelled', function(_, cb)
    if lastPromise and not lastPromise.resolved then
        lastPromise:resolve(false)
        CancelProgressBar()
    end
    cb({})
end)

-- =========================
-- Test/Dev Commands
-- =========================

RegisterCommand('drinkwater', function()
    if arkeo.progressBar({ label = "Drinking water...", duration = 3500 }) then
        print("SUCCESS! Player finished drinking.")
    else
        print("FAILED or cancelled.")
    end
end, false)

RegisterCommand('notification', function()
    Notification("This is a success", "success", 5000)
    Notification("This is an alert", "alert", 5000)
    Notification("This is an error", "error", 5000)
end, false)

RegisterCommand('activeMission', function()
    ShowMissionCard("Test Mission", "This is a test")
end, false)