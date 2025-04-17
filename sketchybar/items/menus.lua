local constants = require("constants")
local settings = require("config.settings")

local maxItems <const> = 15
local menuItems = {}
local isShowingMenu = true

local frontAppWatcher = sbar.add("item", {
  drawing = false,
  updates = true,
})

local swapWatcher = sbar.add("item", {
  drawing = false,
  updates = true,
})

local function createPlaceholders()
  for index = 1, maxItems, 1 do
    local menu = sbar.add("item", constants.items.MENU .. "." .. index, {
      drawing = false,
      icon = { drawing = false },
      width = "dynamic",
      label = {
        padding_left = settings.dimens.padding.menuItem,
        padding_right = settings.dimens.padding.menuItem,
        font = {
          style = index == 1 and settings.fonts.styles.bold or settings.fonts.styles.regular,
          size = settings.dimens.text.menu,
        },
      },
      click_script = "$CONFIG_DIR/bridge/menus/bin/menus -s " .. index,
    })
    menuItems[index] = menu
  end

  sbar.add("bracket", { "/" .. constants.items.MENU .. "\\..*/" }, {
    background = {
      color = settings.colors.bg1,
      padding_left = settings.dimens.padding.item,
      padding_right = settings.dimens.padding.item,
    },
  })
end

local function updateMenus()
  sbar.exec("$CONFIG_DIR/bridge/menus/bin/menus -l", function(menus)
    local newMenus = {}
    local count = 0
    for menu in string.gmatch(menus, '[^\r\n]+') do
      count = count + 1
      if count < maxItems then
        newMenus[count] = menu
      else
        break
      end
    end

    for index = 1, maxItems do
      local menuItem = menuItems[index]
      if menuItem then
        local newLabel = newMenus[index]
        if newLabel and isShowingMenu then
          menuItem:set({
            label = newLabel,
            drawing = true
          })
        else
          menuItem:set({ drawing = false })
        end
      end
    end
  end)

  sbar.set(constants.items.MENU .. ".padding", { drawing = isShowingMenu })
end

frontAppWatcher:subscribe(constants.events.FRONT_APP_SWITCHED, updateMenus)

swapWatcher:subscribe(constants.events.SWAP_MENU_AND_SPACES, function(env)
  isShowingMenu = env.isShowingMenu == "on"
  updateMenus()
end)

createPlaceholders()
