local TPZ = exports.tpz_core:getCoreAPI()


-----------------------------------------------------------
--[[ Commands ]]--
-----------------------------------------------------------

RegisterCommand(Config.Commands['INSERT'].Command, function(source, args, rawCommand)
    local _source = source

    local hasAcePermissions, await = false, true
    
    if _source ~= 0 then

        local xPlayer = TPZ.GetPlayer(source)

        hasAcePermissions = xPlayer.hasPermissionsByAce("tpzcore.subscriptions.add") or xPlayer.hasPermissionsByAce("tpzcore.subscriptions.all")

        if not hasAcePermissions then
            hasAcePermissions = xPlayer.hasAdministratorPermissions(Config.Commands['INSERT'].PermittedGroups, Config.Commands['INSERT'].PermittedDiscordRoles)
        end

        await = false

    else
        hasAcePermissions = true -- CONSOLE HAS PERMISSIONS.
        await = false
    end

    while await do
        Wait(100)
    end

    if not hasAcePermissions then -- ONLY FOR PLAYERS IN GAME.
        SendNotification(_source, Locales['NO_PERMISSIONS'], "error")
        return
    end

    local targetSteamHex = args[1]

    if targetSteamHex == nil or targetSteamHex == '' or targetSteamHex == ' ' then

        if _source ~= 0 then
            SendNotification(_source, Locales['INVALID_STEAM_INPUT_GAME'], "error")
        else
            print(Locales['INVALID_STEAM_INPUT_CONSOLE'])
        end

        return
    end

    local expiration = args[2]

    if expiration == nil or expiration == '' or expiration == ' ' or tonumber(expiration) == nil then

        if _source ~= 0 then
            SendNotification(_source, Locales['INVALID_EXPIRATION_INPUT_GAME'], "error")
        else
            print(Locales['INVALID_EXPIRATION_INPUT_CONSOLE'])
        end

        return
    end

    exports["ghmattimysql"]:execute("SELECT * FROM `subscriptions` WHERE `identifier` = @identifier", { ['identifier'] = targetSteamHex }, function(result)
		
		if result and result[1] then

            if _source ~= 0 then
                SendNotification(_source, Locales['USER_ALREADY_INSERTED_GAME'], "error")
            else
                print(Locales['USER_ALREADY_INSERTED_CONSOLE'])
            end

            return
        end

        expiration = tonumber(expiration)

        local fixedExpiration = expiration <= 0 and 0 or (os.time() + ( expiration * 86400))

        local Parameters = { 
            ['identifier']      = targetSteamHex, 
            ['expiration_date'] = fixedExpiration, -- in days.
        }
      
        exports.ghmattimysql:execute("INSERT INTO `subscriptions` (`identifier`, `expiration_date`) VALUES ( @identifier, @expiration_date )", Parameters)

        if _source ~= 0 then
            SendNotification(_source, Locales['USER_INSERT_SUCCESS_GAME'], "error")
        else
            print(Locales['USER_INSERT_SUCCESS_CONSOLE'])
        end

        if Config.Webhooks['COMMANDS'].Enabled then 
            local title   = "🔗` /".. Config.Commands['INSERT'].Command .. ' ' .. targetSteamHex .. " " .. expiration .. "`"
            local message = 'The specified command has been executed from the console (txadmin?).'

            if _source ~= 0 then

                local xPlayer = TPZ.GetPlayer(_source)
                local steamName, identifier, charIdentifier = GetPlayerName(_source), xPlayer.getIdentifier(), xPlayer.getCharacterIdentifier()
                message = string.format('The specified command has been executed by the user with the steam name: `%s`, identifier `%s` (Char Identifier: `%s`).', steamName, identifier, charIdentifier)
            end

            TPZ.SendToDiscord(Config.Webhooks['COMMANDS'].Url, title, message, Config.Webhooks['COMMANDS'].Color)

        end

    end)

end)


RegisterCommand(Config.Commands['EXTEND'].Command, function(source, args, rawCommand)
    local _source = source

    local hasAcePermissions, await = false, true
    
    if _source ~= 0 then

        local xPlayer = TPZ.GetPlayer(source)

        hasAcePermissions = xPlayer.hasPermissionsByAce("tpzcore.subscriptions.extend") or xPlayer.hasPermissionsByAce("tpzcore.subscriptions.all")

        if not hasAcePermissions then
            hasAcePermissions = xPlayer.hasAdministratorPermissions(Config.Commands['EXTEND'].PermittedGroups, Config.Commands['EXTEND'].PermittedDiscordRoles)
        end

        await = false

    else
        hasAcePermissions = true -- CONSOLE HAS PERMISSIONS.
        await = false
    end

    while await do
        Wait(100)
    end

    if not hasAcePermissions then -- ONLY FOR PLAYERS IN GAME.
        SendNotification(_source, Locales['NO_PERMISSIONS'], "error")
        return
    end

    local targetSteamHex = args[1]

    if targetSteamHex == nil or targetSteamHex == '' or targetSteamHex == ' ' then

        if _source ~= 0 then
            SendNotification(_source, Locales['INVALID_STEAM_INPUT_GAME'], "error")
        else
            print(Locales['INVALID_STEAM_INPUT_CONSOLE'])
        end

        return
    end

    local expiration = args[2]

    if expiration == nil or expiration == '' or expiration == ' ' or tonumber(expiration) == nil then

        if _source ~= 0 then
            SendNotification(_source, Locales['INVALID_EXPIRATION_INPUT_GAME'], "error")
        else
            print(Locales['INVALID_EXPIRATION_INPUT_CONSOLE'])
        end

        return
    end

    exports["ghmattimysql"]:execute("SELECT * FROM `subscriptions` WHERE `identifier` = @identifier", { ['identifier'] = targetSteamHex }, function(result)
		
		if result == nil or result and result[1] == nil then

            if _source ~= 0 then
                SendNotification(_source, Locales['USER_NO_SUBSCRIBER_GAME'], "error")
            else
                print(Locales['USER_NO_SUBSCRIBER_CONSOLE'])
            end

            return
        end

        local res  = result[1]

        expiration = tonumber(expiration)

        if res.expiration_date == 0 then 
            res.expiration_date = os.time()
        end

        local Parameters = { 
            ['identifier']       = targetSteamHex, 
            ['expiration_date']  = res.expiration_date + ( expiration * 86400), -- in days
        }
      
        exports.ghmattimysql:execute("UPDATE `subscriptions` SET `expiration_date` = @expiration_date WHERE `identifier` = @identifier", Parameters)

        if _source ~= 0 then
            SendNotification(_source, string.format(Locales['USER_SUBSCRIPTION_EXTENDED_GAME'], expiration), "error")
        else
            print( string.format(Locales['USER_SUBSCRIPTION_EXTENDED_CONSOLE'], expiration) )
        end

        if Config.Webhooks['COMMANDS'].Enabled then 
            local title   = "🔗` /".. Config.Commands['EXTEND'].Command .. ' ' .. targetSteamHex .. " " .. expiration .. "`"
            local message = 'The specified command has been executed from the console (txadmin?).'

            if _source ~= 0 then

                local xPlayer = TPZ.GetPlayer(_source)
                local steamName, identifier, charIdentifier = GetPlayerName(_source), xPlayer.getIdentifier(), xPlayer.getCharacterIdentifier()
                message = string.format('The specified command has been executed by the user with the steam name: `%s`, identifier `%s` (Char Identifier: `%s`).', steamName, identifier, charIdentifier)
            end

            TPZ.SendToDiscord(Config.Webhooks['COMMANDS'].Url, title, message, Config.Webhooks['COMMANDS'].Color)

        end

    end)

end)

RegisterCommand(Config.Commands['SET'].Command, function(source, args, rawCommand)
    local _source = source

    local hasAcePermissions, await = false, true
    
    if _source ~= 0 then

        local xPlayer = TPZ.GetPlayer(source)

        hasAcePermissions = xPlayer.hasPermissionsByAce("tpzcore.subscriptions.set") or xPlayer.hasPermissionsByAce("tpzcore.subscriptions.all")

        if not hasAcePermissions then
            hasAcePermissions = xPlayer.hasAdministratorPermissions(Config.Commands['SET'].PermittedGroups, Config.Commands['SET'].PermittedDiscordRoles)
        end

        await = false

    else
        hasAcePermissions = true -- CONSOLE HAS PERMISSIONS.
        await = false
    end

    while await do
        Wait(100)
    end

    if not hasAcePermissions then -- ONLY FOR PLAYERS IN GAME.
        SendNotification(_source, Locales['NO_PERMISSIONS'], "error")
        return
    end

    local targetSteamHex = args[1]

    if targetSteamHex == nil or targetSteamHex == '' or targetSteamHex == ' ' then

        if _source ~= 0 then
            SendNotification(_source, Locales['INVALID_STEAM_INPUT_GAME'], "error")
        else
            print(Locales['INVALID_STEAM_INPUT_CONSOLE'])
        end

        return
    end

    local expiration = args[2]

    if expiration == nil or expiration == '' or expiration == ' ' or tonumber(expiration) == nil then

        if _source ~= 0 then
            SendNotification(_source, Locales['INVALID_EXPIRATION_INPUT_GAME'], "error")
        else
            print(Locales['INVALID_EXPIRATION_INPUT_CONSOLE'])
        end

        return
    end

    exports["ghmattimysql"]:execute("SELECT * FROM `subscriptions` WHERE `identifier` = @identifier", { ['identifier'] = targetSteamHex }, function(result)
		
		if result == nil or result and result[1] == nil then

            if _source ~= 0 then
                SendNotification(_source, Locales['USER_NO_SUBSCRIBER_GAME'], "error")
            else
                print(Locales['USER_NO_SUBSCRIBER_CONSOLE'])
            end

            return
        end

        expiration = tonumber(expiration)
        
        local fixedExpiration = expiration <= 0 and 0 or (os.time() + ( expiration * 86400))

        local Parameters = { 
            ['identifier']       = targetSteamHex, 
            ['expiration_date']  = fixedExpiration, -- in days.
        }
      
        exports.ghmattimysql:execute("UPDATE `subscriptions` SET `expiration_date` = @expiration_date WHERE `identifier` = @identifier", Parameters)

        if _source ~= 0 then

            local setDisplay = expiration <= 0 and Locales['USER_SUBSCRIPTION_SET_NO_EXPIRATION_GAME'] or string.format(Locales['USER_SUBSCRIPTION_SET_GAME'], expiration)
            SendNotification(_source, setDisplay, "error")
        else

            local setDisplay = expiration <= 0 and Locales['USER_SUBSCRIPTION_SET_NO_EXPIRATION_CONSOLE'] or string.format(Locales['USER_SUBSCRIPTION_SET_CONSOLE'], expiration)
            print(setDisplay)
        end

        if Config.Webhooks['COMMANDS'].Enabled then 
            local title   = "🔗` /".. Config.Commands['SET'].Command .. ' ' .. targetSteamHex .. " " .. expiration .. "`"
            local message = 'The specified command has been executed from the console (txadmin?).'

            if _source ~= 0 then

                local xPlayer = TPZ.GetPlayer(_source)
                local steamName, identifier, charIdentifier = GetPlayerName(_source), xPlayer.getIdentifier(), xPlayer.getCharacterIdentifier()
                message = string.format('The specified command has been executed by the user with the steam name: `%s`, identifier `%s` (Char Identifier: `%s`).', steamName, identifier, charIdentifier)
            end

            TPZ.SendToDiscord(Config.Webhooks['COMMANDS'].Url, title, message, Config.Webhooks['COMMANDS'].Color)

        end

    end)

end)

RegisterCommand(Config.Commands['CHECK'].Command, function(source, args, rawCommand)
    local _source = source

    local hasAcePermissions, await = false, true
    
    if _source ~= 0 then

        local xPlayer = TPZ.GetPlayer(source)

        hasAcePermissions = xPlayer.hasPermissionsByAce("tpzcore.subscriptions.check") or xPlayer.hasPermissionsByAce("tpzcore.subscriptions.all")

        if not hasAcePermissions then
            hasAcePermissions = xPlayer.hasAdministratorPermissions(Config.Commands['CHECK'].PermittedGroups, Config.Commands['EXTEND'].PermittedDiscordRoles)
        end

        await = false

    else
        hasAcePermissions = true -- CONSOLE HAS PERMISSIONS.
        await = false
    end

    while await do
        Wait(100)
    end

    if not hasAcePermissions then -- ONLY FOR PLAYERS IN GAME.
        SendNotification(_source, Locales['NO_PERMISSIONS'], "error")
        return
    end

    local targetSteamHex = args[1]

    if targetSteamHex == nil or targetSteamHex == '' or targetSteamHex == ' ' then

        if _source ~= 0 then
            SendNotification(_source, Locales['INVALID_STEAM_INPUT_GAME'], "error")
        else
            print(Locales['INVALID_STEAM_INPUT_CONSOLE'])
        end

        return
    end

    exports["ghmattimysql"]:execute("SELECT * FROM `subscriptions` WHERE `identifier` = @identifier", { ['identifier'] = targetSteamHex }, function(result)
		
		if result == nil or result and result[1] == nil then

            if _source ~= 0 then
                SendNotification(_source, Locales['USER_NO_SUBSCRIBER_GAME'], "error")
            else
                print(Locales['USER_NO_SUBSCRIBER_CONSOLE'])
            end

            return
        end

        local res = result[1]

        if res.expiration_date ~= 0 then
            -- Expiration Date to string.
            local date_string = os.date("%Y-%m-%d %H:%M:%S", res.expiration_date)

            if _source ~= 0 then
                SendNotification(_source, string.format(Locales['USER_SUBSCRIPTION_VALID_UNTIL_GAME'], date_string) , "error")
            else
                print( string.format(Locales['USER_SUBSCRIPTION_VALID_UNTIL_CONSOLE'], date_string) )
            end

        else

            if _source ~= 0 then
                SendNotification(_source, Locales['USER_SUBSCRIPTION_NO_EXPIRATION_GAME'], "error")
            else
                print( Locales['USER_SUBSCRIPTION_NO_EXPIRATION_CONSOLE'] )
            end

        end

    end)

end)

-----------------------------------------------------------
--[[ Chat Suggestion Registrations ]]--
-----------------------------------------------------------

RegisterServerEvent("tpz_subscriptions:server:addChatSuggestions")
AddEventHandler("tpz_subscriptions:server:addChatSuggestions", function()
  local _source = source

  for index, command in pairs (Config.Commands) do

    local displayTip = command.CommandHelpTips 

    if not displayTip then
      displayTip = {}
    end

    TriggerClientEvent("chat:addSuggestion", _source, "/" .. command.Command, command.Suggestion, command.CommandHelpTips )

  end

end)
