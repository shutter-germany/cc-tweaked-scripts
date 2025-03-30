os.loadAPI("utils")

inputChest = peripheral.wrap("front")
outputChest = peripheral.wrap("top")
bufferChest = peripheral.wrap("right")

inputChestName = peripheral.getName(inputChest)
bufferChestName = peripheral.getName(bufferChest)

minStackSize = 9                -- Threshold of stack size of an item that should be there till it gets moved
minItemAmount = 8               -- Threshold of how big the stack of an item should be kept and NOT be moved
factorSeconds = 2               -- Time in seconds how long the crusher takes to process one item
factorRedstoneToAmount = 4.267  -- Factor for "comparator" calculation as it just provide a max of 15, so we need to multiply the factor to the current redstone level of get a rough idea of the current stack size the crusher is handling right now
cooldownInSeconds = 20          -- How long should the script pause till it checks the input chest again after the recent check failed
maxGapsSortingValidation = 5    -- After how many perpetuate empty slots the resort check should discontinue

function getFirstItem()
    for i = 1, inputChest.size() do
        currentSlotItem = inputChest.getItemDetail(i)
        if (nil ~= currentSlotItem and currentSlotItem.count >= minStackSize + minItemAmount) then
            return i
        end
    end

    return 0
end

function resortInputChest()
    local perpetuateEmptySlots = 0
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
        else
            perpetuateEmptySlots = perpetuateEmptySlots + 1
        end

        local nextItemName = "empty"
        if (nil ~= nextItem) then
            nextItemName = nextItem.name
        end
        print(utils.printf("Current Item: %s, next one: %s", currentItemName, nextItemName))

        if (perpetuateEmptySlots >= maxGapsSortingValidation) then
            break
        end
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
            item = inputChest.getItemDetail(slot)
            amount = item.count
            if (minItemAmount > 0 and minStackSize > 1) then
                amount = amount - minStackSize
            end
            if (amount == item.count) then -- there will be gaps otherwise
                resortInputChest()
            end
            inputChest.pushItems(peripheral.getName(outputChest), slot, amount)
        else
            print(utils.printf("Input is empty or the stack is not larger as %d items", minStackSize + minItemAmount))
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
