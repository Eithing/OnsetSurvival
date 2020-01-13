function SetZombieCloth(npc)
    if npc ~= nil then
        SetNPCClothingPreset(npc, 21)
    end
end

AddEvent("OnNPCStreamIn", function(npc, player)
    SetZombieCloth(npc)
end)
