SView = ImportPackage("SurvivalView")

function ExecuteFromServer(eventName, ...)
    CallRemoteEvent(eventName, ...)
end
AddFunctionExport("ExecuteFromServer", ExecuteFromServer)

AddEvent("OnScriptError", function(message)
    AddPlayerChat('<span color="#ff0000bb" style="bold" size="10">'..message..'</>')
end)
