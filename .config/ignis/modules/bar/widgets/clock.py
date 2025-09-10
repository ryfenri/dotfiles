import datetime
from ignis import widgets, utils


class Clock(widgets.Label):
    def __init__(self, format: str = "%I\n%M\n%p", style: str | None = None):
        self.format = format

        super().__init__(label="", css_classes=["clock"], style=style if style is not None else "")
        utils.Poll(1000, lambda x: self.update_time())

    def update_time(self):
        text = datetime.datetime.now().strftime(self.format)
        self.set_label(text)
