local TPZ   = exports.tpz_core:getCoreAPI()
local Queue = {}

-----------------------------------------------------------
--[[ Local Functions ]]--
-----------------------------------------------------------

local GetSteamID = function(src)
    local sid = GetPlayerIdentifiers(src)[1] or false

    if (sid == false or sid:sub(1,5) ~= "steam") then
        return false
    end

    return sid
end

local function RemovePlayerFromQueue(_source)
    local leavingPosition = Queue[_source] and Queue[_source].position
    Queue[_source] = nil
    
    if leavingPosition then
        
        for _, user in pairs(Queue) do
            if user.position > leavingPosition then
                user.position = user.position - 1
            end
        end
    end
end

-----------------------------------------------------------
--[[ Base Events  ]]--
-----------------------------------------------------------

-- The following event is triggered when player is connecting in order to check the user's subscription.
AddEventHandler('playerConnecting', function(name, setKickReason, defer) 
    local _source      = source
    local currentTime  = 0

	defer.defer();

    local steamIdentifier

    -- mandatory wait!
    Wait(0) 

    defer.update(string.format(Locales['CHECKING_SUBSCRIPTION'], name))

    steamIdentifier = GetSteamID(_source)
    -- mandatory wait!
    Wait(0)

    local hasSubscription, expired, await = false, false, true

    exports["ghmattimysql"]:execute("SELECT `expiration_date` FROM `subscriptions` WHERE `identifier` = @identifier", { ['identifier'] = steamIdentifier }, function(result)
		
        local res = result[1]

		if result == nil or result and result[1] == nil then
            hasSubscription = false -- not added on the subscriptions.
            await = false

        else

			local current_timestamp = os.time()

			if res.expiration_date ~= 0 and current_timestamp > res.expiration_date then 
                hasSubscription = false -- subscription has been expired.
                expired = true
                await   = false
            else

                hasSubscription = true

                if res.expiration_date > 0 then
                    local date_string = os.date("%Y-%m-%d %H:%M:%S", res.expiration_date)
                    defer.update(string.format(Locales['SUBSCRIPTION_VALID_UNTIL'], date_string))
                    Wait(5000) -- mandatory wait for displaying the subscription validation text. 
                end

                await = false
                
            end

        end


    end)

    while await do
        Wait(500)
    end

    if ( not hasSubscription ) then

        local consoleWarning = not expired and Locales['CONSOLE_USER_JOIN_ATTEMPT'] or Locales['CONSOLE_USER_EXPIRED_JOIN_ATTEMPT']

        local warning = not expired and Locales['NO_SUBSCRIPTION'] or Locales['SUBSCRIPTION_EXPIRED']
        defer.done(warning)
        return
    end

    local insertPosition = 1
    local now = os.time()

    local priority = Config.DefaultPriority

    if Config.Priorities[steamIdentifier] then
        priority = Config.Priorities[steamIdentifier]
    end

    for _, user in pairs(Queue) do
        if priority > user.priority then
            insertPosition = math.max(insertPosition, user.position + 1)

        elseif priority == user.priority and now > (user.joinedAt or now) then
            insertPosition = math.max(insertPosition, user.position + 1)
        end
    end

    -- Shift others down
    for _, user in pairs(Queue) do
        if user.position >= insertPosition then
            user.position = user.position + 1
        end
    end

    -- Add to queue
    Queue[_source] = {
        source   = _source,
        position = insertPosition,
        priority = priority,
        joinedAt = now,
        waiting  = 0,
        defer    = defer
    }

end)

-----------------------------------------------------------
--[[ Threads ]]--
-----------------------------------------------------------

Citizen.CreateThread(function() 

    while true do

        Wait(1000)

        local length = TPZ.GetTableLength(Queue)

        if length > 0 then

            local maxPlayers     = Config.sv_maxclients
            local currentPlayers = TPZ.GetTableLength(GetPlayers())

            for _, user in pairs (Queue) do

                user.waiting = user.waiting + 1

                user.defer.update(string.format(Locales['CHECKING_PRIORITY_POSITION'], user.position, length, user.waiting))

                if currentPlayers < maxPlayers and user.position <= 1 then
                    RemovePlayerFromQueue(user.source)
                    user.defer.done();
                end

                if GetPlayerName(user.source) == nil then
                    RemovePlayerFromQueue(user.source)
                end

            end

        end
    end

end)
