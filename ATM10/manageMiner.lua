local minerShaft = peripheral.wrap("top")
--local router = peripheral.wrap("bottom")
local minerName = "occultism:miner_marid_master"

function pulseRouter()
    print("Pulsing router")
    redstone.setAnalogOutput("bottom", 15)
    sleep(0.5)
    redstone.setAnalogOutput("bottom", 0)
end


while (true) do
    local magicLamp = minerShaft.getItemDetail(1)
    if (nil ~= magicLamp) then
        if ((magicLamp.maxDamage * 0.2) > (magicLamp.maxDamage - magicLamp.damage)) then
            print("Miner duration is lower than 20% - Item will be moved to bottom inventory for repair")
            --minerShaft.pushItems("bottom", 1, 1, 1)
            --pulseRouter()
            minerShaft.pushItems("right", 1, 1, 1)
        else
            for slot = 1, minerShaft.size(), 1 do
                local item = minerShaft.getItemDetail(slot)
                if (nil ~= item and minerName ~= item.name) then
                    --minerShaft.pushItems("back", slot)
                    minerShaft.pushItems("right", slot)
                end
            end
        end
    end

    if (false and nil == magicLamp) then
        local minerItem = router.getItemDetail(1)
        if (nil == minerItem) then
            print("Bottom inventory is still empty")
        else
            if (minerItem.name ~= minerName) then
                print("Found wrong item in bottom inventory")
                -- ring the alarm
            else
                if (0 ~= minerItem.damage) then
                    print("Found miner in bottom inventory, but its still damaged")
                    pulseRouter()
                else
                    print("Pushed miner back to shaft")
                    router.pushItems("top", 1, 1, 1)
                end
            end
        end
    end

    print("\n")
    sleep(10)
end
