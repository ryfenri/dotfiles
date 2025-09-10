from ignis import widgets


class Settings(widgets.RegularWindow):
    def __init__(self):
        main_box = widgets.Box(
            hexpand=True,
            vexpand=True
        )

        self._list_box = widgets.ListBox(
            rows=[
                widgets.Label(label="Appearence")
            ]
        )

        side_bar = widgets.Box(
            vertical=True,
            child=[
                widgets.Label(
                    label="Settings",
                    halign="start"
                ),
                self._list_box
            ]
        )

        super().__init__(
            namespace="rybelika_SETTINGS",
            default_width=900,
            default_height=600,
            resizable=False,
            visible=False,
            child=widgets.Box(
               child=[side_bar, main_box]
            )
        )
