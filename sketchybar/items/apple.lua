local settings = require("config.settings")

local apple = sbar.add("item", "apple", {
  y_offset = 1,
  padding_right = 6,
  icon = { string = settings.icons.text.apple, font = { size = 19 } },
  label = { drawing = false },
  click_script = "$CONFIG_DIR/items/menus/bin/menus -s 0"
})
