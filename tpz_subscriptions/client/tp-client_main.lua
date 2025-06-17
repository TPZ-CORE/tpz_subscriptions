-----------------------------------------------------------
--[[ Base Events ]]--
-----------------------------------------------------------

AddEventHandler("tpz_core:isPlayerReady", function()
    TriggerServerEvent('tpz_subscriptions:server:addChatSuggestions')
end)