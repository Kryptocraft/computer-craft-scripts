-- Dig a 3x3 tunnel for x blocks
-- Place turtle at left side of tunnel at middle
-- Place sorter ender chest in slot 1
-- Place torches in slot 2 - autoplace torches every 4 blocks
-- Place filler blocks (cobble or similar) in slot 3
--   Currently only used to place blocks for torches
--
-- Note: bug with digging gravel can cause turtle to get lost.
-- Attempting to fix with longer delay after digging to check for block

local ender=1
local torch=2
local filler=3

local placeTorchEvery=6

-- Tracking variables
local torchBlock=0
local advanceDir=1

function unloadInventory()
  turtle.select(ender)
  turtle.place()
  for islot = 4, 16, 1
    do
      turtle.select(islot)
      turtle.drop()
    end
  turtle.select(ender)
  turtle.dig()
end

-- Place a torch every 4th block along the tunnel
function torchPlace()
  torchBlock=torchBlock+1
  if torchBlock == placeTorchEvery
    then
      torchBlock = 0
      turtle.down()
      if turtle.detectDown() == false
        then
          turtle.select(filler)
          turtle.placeDown()
        end
      turtle.up()
      turtle.select(torch)
      turtle.placeDown()
    end
end

-- Dig forward until no block is detected
function digGravel()
  repeat
    turtle.dig()
    sleep(0.5)
  until turtle.detect() == false
end

-- Dig up until no block is detected
function digGravelUp()
  repeat
    turtle.digUp()
    sleep(0.5)
  until turtle.detectUp() == false
end

-- Turtle should be in space 4 or space 6 pointing across the tunnel
function tunnelPass()
  digGravel()
  digGravelUp()
  turtle.digDown()

  -- Forward to space 5
  turtle.forward()
  digGravel()
  digGravelUp()
  turtle.digDown()

  -- Call every pass, places a torch when needed
  torchPlace()

  -- Forward to space 4 or space 6
  turtle.forward()
  digGravelUp()
  turtle.digDown()
end

-- Advance turtle forward to next part of tunnel
function advance()
  -- advanceDir==1, turn left
  -- advanceDir==2, turn right

  if advanceDir==1
    then
      advanceDir=2
      turtle.turnLeft()

      digGravel()
      turtle.forward()
      turtle.turnLeft()
    else
      advanceDir=1
      turtle.turnRight()

      digGravel()
      unloadInventory()
      turtle.forward()
      turtle.turnRight()
    end
end

-- Main program
local tArgs = { ... }
length = tonumber(tArgs[1])
if length < 3
  then
    print( "Clear it out yourself you lazy bum!" )
    exit()
  end

turtle.turnRight()

while length > 0
do
  print( "Tunneling... " .. length .. " blocks remain..")
  length = length - 1
  tunnelPass()
  advance()
end
