Config = {}

-----------------------------------------------------------
--[[ Commands ]]--
-----------------------------------------------------------

-- (!) THE COMMANDS ARE ALSO SUPPORTED THROUGH THE TXADMIN CONSOLE.
Config.Commands = {

    ['INSERT'] = {

        Suggestion = "Execute this command to add a the selected user as a new subscription.",

        PermittedDiscordRoles  = { 11111111111111111, 2222222222222222 },
        PermittedGroups = { 'admin' },

        Command = 'addsubscription',
        CommandHelpTips = { { name = "Steam Hex", help = "Insert the user's Steam Hex" }, { name = "Days", help = "Insert the expire duration in days. Set to 0 for not having expiration (permanent - whitelisted subscription)." } },
    },

    ['EXTEND'] = {

        Suggestion = "Execute this command to extend of the selected user the subscription expiration duration.",

        PermittedDiscordRoles  = { 11111111111111111, 2222222222222222 },
        PermittedGroups = { 'admin' },

        Command = 'extendsubscription',
        CommandHelpTips = { { name = "Steam Hex", help = "Insert the user's Steam Hex" }, { name = "Days", help = "Extend the expire duration in days." } },
    },

    ['SET'] = { 

        Suggestion = "Execute this command to set of the selected user the subscription expiration duration.",

        PermittedDiscordRoles  = { 11111111111111111, 2222222222222222 },
        PermittedGroups = { 'admin' },

        Command = 'setsubscription',
        CommandHelpTips = { { name = "Steam Hex", help = "Insert the user's Steam Hex" }, { name = "Days", help = "Set the expire duration in days. Set to 0 for not having expiration (permanent - whitelisted subscription)." } },
    },

    ['CHECK'] = {

        Suggestion = "Execute this command to check of the selected user the subscription expiration duration.",

        PermittedDiscordRoles  = { 11111111111111111, 2222222222222222 },
        PermittedGroups = { 'admin' },

        Command = 'checksubscription',
        CommandHelpTips = { { name = "Steam Hex", help = "Insert the user's Steam Hex" } },
    },
}


---------------------------------------------------------------
--[[ Discord Webhooking ]]--
---------------------------------------------------------------

-- Webhooks for all commands except "CHECK" command which is pointless.
Config.Webhooks = { 

    ['COMMANDS'] = {
        Enabled = false,
        Url     = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx',
        Color   = 10038562,
    },

}

-----------------------------------------------------------
--[[ Notification Functions ]]--
-----------------------------------------------------------

-- @param source : The source always null when called from client.
-- @param type   : returns "error", "success", "info"
-- @param duration : the notification duration in milliseconds
function SendNotification(source, message, type, duration)

	if not duration then
		duration = 3000
	end

    if not source then
        TriggerEvent('tpz_core:sendBottomTipNotification', message, duration)
    else
        TriggerClientEvent('tpz_core:sendBottomTipNotification', source, message, duration)
    end
  
end
