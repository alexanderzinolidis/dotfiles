local constants = require("constants")
local settings = require("config.settings")

local spaces = {}

local swapWatcher = sbar.add("item", {
  drawing = false,
  updates = true,
})

local currentWorkspaceWatcher = sbar.add("item", {
  drawing = false,
  updates = true,
})

-- Modify this file with Visual Studio Code - at least vim does have problems with the icons
-- copy "Icons" from the nerd fonts cheat sheet and replace icon and name accordingly below
-- https://www.nerdfonts.com/cheat-sheet

local spaceConfigs <const> = {
  ["1"] = { icon = "󰖟", name = "Browser" },
  ["2"] = { icon = "󰨞", name = "Code" },
  ["3"] = { icon = "", name = "Terminal" },
  ["4"] = { icon = "", name = "Slack" },
  ["5"] = { icon = "󰊻", name = "Teams" },
  ["6"] = { icon = "", name = "Mail" },
  ["7"] = { icon = "", name = "Calendar" },
  ["8"] = { icon = "", name = "Notes" },
}

local function selectCurrentWorkspace(focusedWorkspaceName)
  for sid, item in pairs(spaces) do
    if item ~= nil then
      local isSelected = sid == constants.items.SPACES .. "." .. focusedWorkspaceName
      item:set({
        icon = { color = isSelected and settings.colors.bg1 or settings.colors.white },
        label = { color = isSelected and settings.colors.bg1 or settings.colors.white },
        background = { color = isSelected and settings.colors.white or settings.colors.bg1 },
      })
    end
  end

  sbar.trigger(constants.events.UPDATE_WINDOWS)
end

local function findAndSelectCurrentWorkspace()
  sbar.exec(constants.aerospace.GET_CURRENT_WORKSPACE, function(focusedWorkspaceOutput)
    local focusedWorkspaceName = focusedWorkspaceOutput:match("[^\r\n]+")
    selectCurrentWorkspace(focusedWorkspaceName)
  end)
end

local function addWorkspaceItem(workspaceName)
  local spaceName = constants.items.SPACES .. "." .. workspaceName
  local spaceConfig = spaceConfigs[workspaceName]

  local icon = (spaceConfig and spaceConfig.icon) or settings.icons.apps["default"]
  local label = (spaceConfig and spaceConfig.name) or workspaceName

  spaces[spaceName] = sbar.add("item", spaceName, {
    position = "right",
    padding_left = settings.dimens.padding.item,
    padding_right = settings.dimens.padding.item,
    label = {
      width = 0,
      padding_left = 0,
      string = label,
    },
    icon = {
      string = icon,
      color = settings.colors.white,
    },
    background = {
      color = settings.colors.bg1,
    },
    click_script = "aerospace workspace " .. workspaceName,
  })

  spaces[spaceName]:subscribe("mouse.entered", function(env)
    sbar.animate("tanh", 10, function()
      spaces[spaceName]:set({ label = { width = "dynamic" } })
    end)
  end)

  spaces[spaceName]:subscribe("mouse.exited", function(env)
    sbar.animate("tanh", 10, function()
      spaces[spaceName]:set({ label = { width = 0 } })
    end)
  end)

  sbar.add("item", spaceName .. ".padding", {
    width = settings.dimens.padding.label
  })
end

local function createWorkspaces()
  sbar.exec(constants.aerospace.LIST_ALL_WORKSPACES, function(workspacesOutput)
    local workspaceNames = {}
    for workspaceName in workspacesOutput:gmatch("[^\r\n]+") do
      if spaceConfigs[workspaceName] then
        table.insert(workspaceNames, workspaceName)
      end
    end

    for i = #workspaceNames, 1, -1 do
      addWorkspaceItem(workspaceNames[i])
    end

    findAndSelectCurrentWorkspace()
  end)
end

-- swapWatcher:subscribe(constants.events.SWAP_MENU_AND_SPACES, function(env)
--   local isShowingSpaces = env.isShowingMenu == "off" and true or false
--   sbar.set("/" .. constants.items.SPACES .. "\\..*/", { drawing = isShowingSpaces })
-- end)

currentWorkspaceWatcher:subscribe(constants.events.AEROSPACE_WORKSPACE_CHANGED, function(env)
  selectCurrentWorkspace(env.FOCUSED_WORKSPACE)
  sbar.trigger(constants.events.UPDATE_WINDOWS)
end)

findAndSelectCurrentWorkspace()
createWorkspaces()
