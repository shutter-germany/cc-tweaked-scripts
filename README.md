Lua scripts for ComputerCraft: Tweaked (CC: Tweaked)

Scripts
------------
manageMiner.lua (Direwolf20 1.21 Modpack)
* Using the miner of Occultism and a block to repair the magic lamp
* Pushes the lamp to the bottom inventory to get repaired
* Expects the repaired lamp back in the bottom inventory to send it into the shaft or you can send it directly into the shaft

mobSpawner.lua (Direwolf20 1.21 Modpack)
* Using Industrial Foregoing Mob Duplicator with Mob Imprision Tools and bundled network cables from More Red which are connected to AE emitters
* AE Emitter are configured to activate if the amount of an item is below the limit (e.g. less than 256 blaze rods)
* As soon as the emitter is active the bound network cable will be fetched by the script
* The colors of the cables are assigned to the spawnMap at the beginning of the script
* Also to mention you need to check the NBT values for the Mob Imprision Tools
* Those tools need to be stored in an inventory below the computer

witherSpawn.lua (Direwolf20 1.21 Modpack)
* Using Industrial Foregoing Blockplacer, Modular Router Routers and a bottom inventory to place the wither
* Checks if there're items in the inventory bellow and activates redstone to the left, where a router needs to be put with the redstone mode: Pulse
* The router is configure to grab at first the soul sand to send it to the appriopiate block placers and pulls afterwards the skulls and moves them into the upper block placer
* As soon the redstone is activated to the left the computer sends a redstone signal to the back and top, to activate at first the soulsand placers and shortly afterwards the top row

ATM10/manageMiner.lua
* same as above just without the push to a router to get the item repaired (early/mid game adjustment)

ATM10/oreCrusher.lua
* handles currently one Occultism Crusher
* reads the current stack size of the current crushed item if there is any
* for that I'm using the integrated dynamics entity reader
* Variables in integrated dynamics variable store: entity (aspect entity), held item (operator held item mainhand on entity variable), integer (value 4, to divide the stack size to fit within the max redstone strength of 15 - e.g. 40 items translate therefore to a redstone strength of 10), size (operator size, category item held in mainhand)
* Variables in integrated dynamics redstone writer consumed by the script: division (operator division and use the size variable and the integer of 4)
* let the writer directly connect to the computer so the readout for CC is really the redstone strength and not 1 or 0
* seems like you can also just output the stacksize to the redstone writer as CC recognizes redstone signals above 15. but I use the division just for safety reasons
* the computer needs an input chest in front, a buffer chest for sorting on the right and an output chest for the dropper (using just dire things dropper) on the top
