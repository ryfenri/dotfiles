import os

from ignis import utils
from ignis.css_manager import CssManager, CssInfoPath
from ignis.icon_manager import IconManager

from modules import Powermenu, Bar, NotificationPopup, AudioSlider, LockScreen, Settings
from services import Wallpaper


icon_manager = IconManager.get_default()
icon_manager.add_icons(os.path.join(utils.get_current_dir(), "icons"))

css_manager = CssManager.get_default()
css_manager.widgets_style_priority = "user"
css_manager.apply_css(
    CssInfoPath(
        name="main",
        path=os.path.join(utils.get_current_dir(), "style/style.scss"),
        compiler_function=lambda path: utils.sass_compile(path=path),
    )
)

for monitor in range(utils.get_n_monitors()):
    Bar(monitor)

# for monitor in range(utils.get_n_monitors()):
#    NotificationPopup(monitor)

Powermenu()
Wallpaper()
AudioSlider()
LockScreen()
Settings()
