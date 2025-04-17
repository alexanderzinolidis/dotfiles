local padding <const> = {
  background = 0,
  icon = 8,
  label = 8,
  bar = 0,
  left = 12,
  right = 12,
  item = 4,
  menuItem = 8,
  popup = 16,
}

local graphics <const> = {
  bar = {
    height = 36,
    offset = 4,
  },
  background = {
    height = 26,
    corner_radius = 8,
  },
  slider = {
    height = 20,
  },
  popup = {
    width = 200,
    large_width = 300,
  },
  blur_radius = 300,
}

local text <const> = {
  icon = 16.0,
  label = 14.0,
  menu = 12.0,
}

return {
  padding = padding,
  graphics = graphics,
  text = text,
}
