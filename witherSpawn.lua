
function emitRedstone(value)
    redstone.setAnalogOutput("bottom", value)
    redstone.setAnalogOutput("back", value)
    sleep(0.5)
    redstone.setAnalogOutput("top", value)
end

local chest = peripheral.wrap("bottom")
print("Chest initialized")
while (true) do
    print("Checking inventory")
    if (nil == chest.getItemDetail(1)) then
        print("Found nothing")
    else
        print("Found items")
        emitRedstone(15)
        sleep(3)
    end
    emitRedstone(0)
    sleep(20)
end
