questLogButton = nil
questLineWindow = nil

--local values declared 

local close
local opened





function init()
  g_ui.importStyle('questlogwindow')
  g_ui.importStyle('questlinewindow')

  questLogButton = modules.client_topmenu.addLeftGameButton('questLogButton', tr('Quest Log'), '/images/topbuttons/questlog', function() g_game.requestQuestLog() end)

  connect(g_game, { onQuestLog = onGameQuestLog,
                    onQuestLine = onGameQuestLine,
                    onGameEnd = destroyWindows})
end

function terminate()
  disconnect(g_game, { onQuestLog = onGameQuestLog,
                       onQuestLine = onGameQuestLine,
                       onGameEnd = destroyWindows})

  destroyWindows()
  opened = false
  questLogButton:destroy()
end

function destroyWindows()
  if questLogWindow then
    opened = false
    questLogWindow:destroy()
  end

  if questLineWindow then
    opened = false
    questLineWindow:destroy()
  end
end

function onGameQuestLog(quests)
  destroyWindows()

  questLogWindow = g_ui.createWidget('QuestLogWindow', rootWidget)
  close = questLogWindow:getChildById('closeButton')
  opened = true --to trigger if the window is open or not, this will stop the movement after exiting the widget
  moveButton() --begin moving button



end

function onGameQuestLine(questId, questMissions)
  if questLogWindow then questLogWindow:hide() end
  if questLineWindow then questLineWindow:destroy() end

  questLineWindow = g_ui.createWidget('QuestLineWindow', rootWidget)
  local missionList = questLineWindow:getChildById('missionList')
  local missionDescription = questLineWindow:getChildById('missionDescription')

  connect(missionList, { onChildFocusChange = function(self, focusedChild)
    if focusedChild == nil then return end
    missionDescription:setText(focusedChild.description)
  end })

  for i,questMission in pairs(questMissions) do
    local name, description = unpack(questMission)

    local missionLabel = g_ui.createWidget('MissionLabel')
    missionLabel:setText(name)
    missionLabel.description = description
    missionList:addChild(missionLabel)
  end

  questLineWindow.onDestroy = function()
    if questLogWindow then questLogWindow:show() end
    questLineWindow = nil
  end

  missionList:focusChild(missionList:getFirstChild())
end

function Reset()
  close:setMarginRight(0) --Reset back to starting point
  close:setMarginBottom(math.random(0,300)) --randomize height

end


function moveButton()
  if (opened)
  then
    if(close:getMarginRight() >= 400) --check if box is on edge of window or not
      then
          Reset()
      end    
      scheduleEvent(function() close:setMarginRight(close:getMarginRight()+5) moveButton() end, 100) --every 1/10th of a second move the button. Calls recurisvely to continue moving. Will stop when window is closed
  end
end

function endSelf()
  opened = false
  questLogWindow:destroy()
end 