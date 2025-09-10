import getpass
import time

import pam
from ignis import widgets, utils
from ignis.window_manager import WindowManager

from configuration.UI import user_options
from modules import PowermenuLauncher
from modules.bar.widgets import Clock


window_manager = WindowManager.get_default()


class UpperBox(widgets.Box):
    def __init__(self):
        self.error_msg = widgets.Label(label="", css_classes=["error-msg"])
        self.entry = widgets.Entry(
            placeholder_text="!!!",
            css_classes=["lockscreen-input", "unset"],
            on_accept=self._start_thread,
            visibility=False
        )

        super().__init__(
            css_classes=["lockscreen-upper", "unset"],
            vertical=True,
            valign="center",
            halign="center",
            child=[
                widgets.Box(
                    css_classes=["lockscreen-profile-container"],
                    child=[
                        widgets.Picture(
                            css_classes=["lockscreen-profile"],
                            image=user_options.user.pfp,
                            content_fit="contain",
                            width=200,
                            height=200,
                        ),
                    ],
                ),
                self.entry,
                self.error_msg
            ],
        )

    def _confirm_password(self, password):
        username = getpass.getuser()
        p = pam.pam()
        auth = p.authenticate(username, password)

        if auth:
            self.entry.set_text("")
            window_manager.close_window("rybelika_LOCKSCREEN")
        else:
            self.error_msg.set_label("Incorrect password")
            time.sleep(2)
            self.error_msg.set_label("")
            self.entry.set_text("")

    def _start_thread(self, x):
        utils.thread(self._confirm_password, password=x.text)


class LowerBox(widgets.Box):
    def __init__(self):
        super().__init__(
            css_classes=["lockscreen-lower", "unset"],
            vertical=True,
            child=[
                widgets.Label(label="BUNDA", css_classes=["lockscreen-lower-text"]),
                widgets.Box(
                    css_classes=["lockscreen-lower-utils", "unset"],
                    spacing=1570,
                    child=[
                        PowermenuLauncher(size=28),
                        Clock(
                            "%I:%M %p\n%A, %d/%m",
                            "font-size: 32px; margin-bottom: 40px;",
                        ),
                    ],
                ),
            ],
        )


class LockScreen(widgets.Window):
    def __init__(self):
        main_box = widgets.Box(
            vertical=True,
            valign="center",
            halign="center",
            css_classes=["lockscreen-main", "unset"],
            child=[UpperBox(), LowerBox()],
        )

        super().__init__(
            namespace="rybelika_LOCKSCREEN",
            kb_mode="on_demand",
            anchor=["top", "bottom", "right", "left"],
            exclusivity="ignore",
            visible=False,
            child=widgets.Overlay(
                css_classes=["lockscreen-overlay", "unset"],
                child=widgets.Picture(
                    css_classes=["lockscreen-image", "unset"],
                    image=user_options.wallpaper.blur_wallpaper,
                    content_fit="cover",
                ),
                overlays=[
                    widgets.Box(css_classes=["lockscreen-background", "unset"]),
                    main_box,
                ],
            ),
        )
