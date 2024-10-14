
local redstoneInput = nil
local spawner = peripheral.wrap("top")
local chest = peripheral.wrap("bottom")
local chestSize = chest.size()
local chestContent = chest.list()

if (nil ~= spawner.getItemDetail(3)) then
    spawner.pushItems("bottom", 3)
end

local spawningMap = {
    enderman = {
        color = colors.lime,
        nbt = "9263048207b3300548b004d652701fe5",
        slot = nil
    },
    blaze = {
        color = colors.red,
        nbt = "7728838de6515e45f5a974383995b2bd",
        slot = nil
    },
    witherSkeleton = {
        color = colors.blue,
        nbt = "07cc4001b79d25954d410d9dcfb344ef",
        slot = nil
    },
    evoker = {
        color = colors.gray,
        nbt = "6d7659241912bfa3aecc3d69793b0ce4",
        slot = nil
    },
    magmaCube = {
        color = colors.orange,
        nbt = "4d11c30c71e8bb3cdbff1c866f45877a",
        slot = nil
    }
}

local nbtMap = {}

for slot = 1, chestSize, 1 do
    local item = chest.getItemDetail(slot)
    if (nil ~= item) then
        for name, data in pairs(spawningMap) do
            if (data.nbt == item.nbt) then
                print(string.format("Tool for %s in slot #%d", name, slot))
                spawningMap[name].slot = slot
                nbtMap[data.nbt] = name
                break
            end
        end
    end
end

while (true) do
    redstoneInput = redstone.getBundledInput("left")
    local spawnerContent = spawner.getItemDetail(3)

    if (0 == redstoneInput) then
        print("No Emitter enabled")
        if (nil ~= spawnerContent) then
            spawner.pushItems("bottom", 3, 1, spawningMap[nbtMap[spawnerContent.nbt]].slot)
            redstone.setAnalogOutput("top", 0)
            print("Moving Imprisonment Tool to chest and disabling spawner")
        end
    end
    if (0 ~= redstoneInput) then
        for name, data in pairs(spawningMap) do
            if (true == colors.test(redstoneInput, data.color)) then
                print(string.format("Emitter enabled for %s", name))
                if (nil ~= spawnerContent) then
                    if (spawnerContent.nbt == data.nbt) then
                        print("Imprisonment Tool already in Spawner")
                        break
                    else
                        spawner.pushItems("bottom", 3, 1, spawningMap[nbtMap[spawnerContent.nbt]].slot)
                        print("Found other Imprisonment Tool already in Spawner, will be moved to chest")
                    end
                end
                chest.pushItems("top", data.slot, 1, 3)
                print("Pushed Imprisonment Tool to spawner")
                redstone.setAnalogOutput("top", 15)
                break
            end
        end
    end
    sleep(5)
    print("\n---\n")
end
