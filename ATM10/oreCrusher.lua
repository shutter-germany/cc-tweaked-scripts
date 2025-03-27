os.loadAPI("utils")

inputChest = peripheral.wrap("front")
outputChest = peripheral.wrap("top")
bufferChest = peripheral.wrap("right")

inputChestName = peripheral.getName(inputChest)
bufferChestName = peripheral.getName(bufferChest)

minStackSize = 8
factorSeconds = 2
factorRedstoneToAmount = 4.267
cooldownInSeconds = 20

function getFirstItem()
    for i = 1, inputChest.size() do
        currentSlotItem = inputChest.getItemDetail(i)
        if (nil ~= currentSlotItem and currentSlotItem.count >= minStackSize) then
            return i
        end
    end

    return 0
end

function resortInputChest()
    for i = 1, inputChest.size() do
        if (i == inputChest.size()) then
            break
        end
        print(utils.printf("current slot %d", i))
        local currentItem = inputChest.getItemDetail(i)
        local nextItem = inputChest.getItemDetail(i + 1)

        if (nil == currentItem and nil ~= nextItem) then
            inputChest.pushItems(bufferChestName, i + 1)
            bufferChest.pushItems(inputChestName, 1)
        end

        local currentItemName = "empty"
        if (nil ~= currentItem) then
            currentItemName = currentItem.name
        end

        local nextItemName = "empty"
        if (nil ~= nextItem) then
            nextItemName = nextItem.name
        end
        print(utils.printf("Current Item: %s, next one: %s", currentItemName, nextItemName))
    end

end
resortInputChest()

while (true) do
    local waitingFor = 0
    local currentItemStackSize = redstone.getAnalogueInput("back")
    print(utils.printf("Current stacksize %s", redstone.getAnalogueInput("back") * factorRedstoneToAmount))
    if (0 == currentItemStackSize) then
        local slot = getFirstItem()
        print(utils.printf("moving from slot %d", slot))
        if (0 ~= slot) then
            inputChest.pushItems(peripheral.getName(outputChest), slot)
            resortInputChest()
        else
            print(utils.printf("Input is empty or the stack is not larger as %d items", minStackSize))
        end
    end

    waitingFor = redstone.getAnalogueInput("back") * factorRedstoneToAmount * factorSeconds
    if (0 == waitingFor) then
        waitingFor = cooldownInSeconds
        print("going into cooldown")
    end
    print(utils.printf("waiting for %d seconds", waitingFor))
    sleep(waitingFor)
end