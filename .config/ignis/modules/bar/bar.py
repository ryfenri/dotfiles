import datetime
import os
import asyncio

from ignis import widgets, utils
from ignis.window_manager import WindowManager

from modules import PowermenuLauncher
from .widgets import Workspaces, border, Clock
from services import Audio, Tray, Network

window_manager = WindowManager.get_default()


class Bar(widgets.Window):
    def __init__(self, monitor: int):
        super().__init__(
            namespace=f"rybalika_BAR_{monitor}",
            monitor=monitor,
            anchor=["left", "top", "bottom"],
            css_classes=["unset"],
            exclusivity="exclusive",
            child=widgets.CenterBox(
                vertical=True,
                css_classes=["bar", "unset"],
                start_widget=widgets.Box(
                    valign="center",
                    halign="center",
                    vertical=True,
                    spacing=15,
                    child=[
                        widgets.EventBox(
                            child=[
                                widgets.Icon(
                                    image="os-icon-symbolic",
                                    pixel_size=16,
                                    css_classes=["os-icon"]
                                ),
                            ],
                            on_click=lambda *_: asyncio.create_task(utils.exec_sh_async(os.path.expanduser("~/.config/hypr/scripts/rofi_launcher.sh -d"))),
                        ),
                        Tray()
                    ]
                ),
                center_widget=widgets.Box(
                    valign="center",
                    halign="center",
                    spacing=8,
                    child=[Workspaces()]
                ),
                end_widget=widgets.Box(
                    css_classes=["module-right"],
                    vertical=True,
                    valign="center",
                    halign="center",
                    spacing=8,
                    child=[
                        Network(),
                        Audio(),
                        Clock(),
                        PowermenuLauncher()
                    ]
                ),
            ),
        )
