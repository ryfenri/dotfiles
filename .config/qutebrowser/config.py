import json
from pathlib import Path

c = c
config = config


def get_colors_file():
    colors_file = Path.home() / ".config/qutebrowser/colors.json"

    with open(colors_file, "r") as file:
        colors = json.load(file)

    return colors["colors"]


def get_color(color: str, file: str):
    return file[color]["default"]


config.load_autoconfig()
c.auto_save.session = True

system_colors = get_colors_file()

config.set("scrolling.smooth", True)

c.colors.statusbar.command.fg = get_color("primary", system_colors)
c.colors.statusbar.normal.fg = get_color("primary", system_colors)
c.colors.statusbar.passthrough.fg = get_color("primary", system_colors)
c.colors.statusbar.url.fg = get_color("secondary", system_colors)
c.colors.statusbar.url.success.https.fg = get_color("secondary", system_colors)
c.colors.statusbar.url.hover.fg = get_color("on_primary", system_colors)

c.colors.tabs.even.bg = get_color("background", system_colors)
c.colors.tabs.odd.bg = get_color("background", system_colors)
c.colors.tabs.bar.bg = get_color("background", system_colors)
c.colors.tabs.even.fg = get_color("surface_tint", system_colors)
c.colors.tabs.odd.fg = get_color("surface_tint", system_colors)

c.colors.tabs.selected.even.bg = get_color("primary", system_colors)
c.colors.tabs.selected.odd.bg = get_color("primary", system_colors)
c.colors.tabs.selected.even.fg = get_color("background", system_colors)
c.colors.tabs.selected.odd.fg = get_color("background", system_colors)
c.colors.hints.bg = get_color("background", system_colors)
c.colors.hints.fg = get_color("primary_fixed", system_colors)
c.tabs.show = "multiple"

c.colors.completion.item.selected.match.fg = get_color("inverse_primary", system_colors)
c.colors.completion.match.fg = get_color("inverse_primary", system_colors)

c.colors.completion.odd.bg = get_color("background", system_colors)
c.colors.completion.even.bg = get_color("background", system_colors)
c.colors.completion.fg = get_color("primary_fixed", system_colors)
c.colors.completion.category.bg = get_color("background", system_colors)
c.colors.completion.category.fg = get_color("primary_fixed", system_colors)
c.colors.completion.item.selected.bg = get_color("background", system_colors)
c.colors.completion.item.selected.fg = get_color("primary_fixed", system_colors)

c.colors.messages.info.bg = get_color("background", system_colors)
c.colors.messages.info.fg = get_color("primary_fixed", system_colors)
c.colors.messages.error.bg = get_color("background", system_colors)
c.colors.messages.error.fg = get_color("primary_fixed", system_colors)
c.colors.downloads.error.bg = get_color("background", system_colors)
c.colors.downloads.error.fg = get_color("primary_fixed", system_colors)

c.colors.downloads.bar.bg = get_color("background", system_colors)
c.colors.downloads.start.bg = get_color("primary", system_colors) 
c.colors.downloads.start.fg = get_color("primary_fixed", system_colors)
c.colors.downloads.stop.bg = get_color("inverse_primary", system_colors)
c.colors.downloads.stop.fg = get_color("primary_fixed", system_colors)

c.colors.tooltip.bg = get_color("background", system_colors)
c.colors.webpage.bg = get_color("background", system_colors)
c.hints.border = get_color("primary_fixed", system_colors)

c.url.searchengines = {
    "DEFAULT": "https://www.qwant.com/?q={}",
    "!gh": "https://github.com/search?o=desc&q={}&s=stars",
    "!yt": "https://www.youtube.com/results?search_query={}",
    "!p": "https://pinterest.com/search/pins/?q={}",
    "!cg": "https://chatgpt.com/?prompt={}",
}

c.colors.webpage.darkmode.enabled = True
c.colors.webpage.darkmode.algorithm = "lightness-cielab"
c.colors.webpage.darkmode.policy.images = "never"
config.set("colors.webpage.darkmode.enabled", False, "file://*")

config.bind("=", "cmd-set-text -s :open")
config.bind("h", "history")
config.bind("cs", "cmd-set-text -s :config-source")
config.bind("tH", "config-cycle tabs.show multiple never")
config.bind("sH", "config-cycle statusbar.show always never")
config.bind("T", "hint links tab")
config.bind("pP", "open -- {primary}")
config.bind("pp", "open -- {clipboard}")
config.bind("pt", "open -t -- {clipboard}")
config.bind("qm", "macro-record")
config.bind("tT", "config-cycle tabs.position top left")
config.bind("gJ", "tab-move +")
config.bind("gK", "tab-move -")
config.bind("gm", "tab-move")

c.tabs.padding = {"top": 5, "bottom": 5, "left": 9, "right": 9}
c.tabs.indicator.width = 0 # no tab indicators
c.tabs.width = "10%"
c.tabs.position = "left"

c.fonts.default_family = ["JetBrainsMono Nerd Font"]
c.fonts.default_size = "11pt"
c.fonts.web.family.fixed = "JetBrainsMono Nerd Font"
c.fonts.web.family.sans_serif = "Roboto"
c.fonts.web.family.serif = "Roboto"

# privacy
config.set("content.webgl", False, "*")
config.set("content.canvas_reading", False)
config.set("content.geolocation", False)
config.set("content.webrtc_ip_handling_policy", "default-public-interface-only")
config.set("content.cookies.accept", "all")
config.set("content.cookies.store", True)

c.content.blocking.enabled = True
