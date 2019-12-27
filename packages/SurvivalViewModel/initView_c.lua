SView = ImportPackage("SurvivalView")

function ExecuteFromServer(eventName, ...)
    CallRemoteEvent(eventName, ...)
end
AddFunctionExport("ExecuteFromServer", ExecuteFromServer)