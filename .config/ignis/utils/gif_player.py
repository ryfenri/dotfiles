from ignis import widgets
from ignis.utils.pixbuf import scale_pixbuf

from PIL import Image, ImageSequence
from gi.repository import GLib, GdkPixbuf


class Gif(widgets.Box):
    def __init__(self, gif: str, width: int, height: int):
        self.width = width
        self.height = height
        self.gif = gif

        self.gif_widget = widgets.Picture(
            width=self.width,
            height=self.height,
            css_classes=["gif"],
            content_fit="contain",
        )

        super().__init__(
            css_classes=["gif-container", "unset"],
            child=[self.gif_widget],
            halign="center",
        )

        pil_image = Image.open(self.gif)
        self.frames = []
        self.durations = []

        for frame in ImageSequence.Iterator(pil_image):
            rgba_frame = frame.convert("RGBA")
            w, h = rgba_frame.size
            data = rgba_frame.tobytes()

            pixbuf = GdkPixbuf.Pixbuf.new_from_data(
                data,
                GdkPixbuf.Colorspace.RGB,
                True,
                8,
                w,
                h,
                w * 4,
                None,
                None,
            )
            pixbuf = scale_pixbuf(pixbuf, self.width, self.height)

            self.frames.append(pixbuf)
            self.durations.append(frame.info.get("duration", 100))

        self.frame_index = 0
        self._update_frame()

    def _update_frame(self):
        self.gif_widget.set_image(self.frames[self.frame_index])
        self.frame_index = (self.frame_index + 1) % len(self.frames)

        GLib.timeout_add(self.durations[self.frame_index], self._update_frame)
