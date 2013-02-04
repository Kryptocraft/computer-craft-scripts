-- Dig out area to create room
-- Ensures there is floor, ceiling, walls for room
-- 
-- Place turtle at floor level facing long ways on left wall
-- Turtle will dig out 'w' blocks, then turn right and dig 'l' blocks
--
-- Note - for now, L will be treated as an even number
--
-- Place ender chest in slot 1, filler blocks in slot 2
--

-- Globals
local ender=1
local filler=2

-- Get command line
local tArgs = { ... }
local fullw = tonumber(tArgs[1])
local fulll = tonumber(tArgs[2])

print("Time to build a room: "..fullw.." x "..fulll)

-- Status tracking vars
local curPass = 1
local passL = fulll

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

-- Dig one pass
-- Check ceiling if curPass=1
-- Check floor if curPass=3
function digPass()
  for iStep=1,fullw,1
  do
    digGravel()

    if curPass==1 then
      -- Ceiling pass
      if turtle.detectUp() == false then
        turtle.select(filler)
        turtle.placeUp()
      end
      turtle.digDown()

    elseif curPass==2 then
      -- Mid pass
      digGravelUp()
      turtle.digDown()

    elseif curPass==3 then
      -- Floor pass
      if turtle.detectDown() == false then
        turtle.select(filler)
        turtle.placeDown()
      end
      digGravelUp()
    end

    turtle.forward()

  end
end

-- fullDigPass - Complete a full pass of the room
function fullDigPass()
  -- Assume we are in the starting square - position to dig
  digGravel()
  turtle.forward()

  for i = 1, fulll, 2 do
    digPass()
    turtle.turnRight()
    digGravel()
    turtle.forward()
    turtle.turnRight()

    digPass()
    turtle.turnLeft()
    digGravel()
    unloadInventory()
    turtle.forward()
    turtle.turnLeft()

  end

  -- Return to start
  turtle.turnRight()
  for i = 1, fulll, 1 do
    turtle.forward()
  end
  turtle.turnLeft()
  turtle.forward()
  turtle.turnLeft()
  turtle.turnLeft()

end

-- Empty room
-- Clear out entire room, fix floor/ceiling
function emptyRoom()
  -- Move from floor to ceiling
  for iHeight=1,6,1 do
    digGravelUp()
    turtle.up()
  end

  -- Do ceiling
  print("Building ceiling")
  curPass=1
  fullDigPass()

  -- Do middle
  print("Clearing out middle of room")
  curPass=2
  fullDigPass()

  -- Do floor
  print("Building floor")
  curPass=3
  fullDigPass()
end

-- Check and rebuild the walls of the room
-- Note: Currently this won't work properly
function doWalls()

end

-- main program segment
-- Empty out the room
emptyRoom()
doWalls()
