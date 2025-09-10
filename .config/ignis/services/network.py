from ignis import widgets
from ignis.utils import exec_sh_async
from ignis.services.network import NetworkService
import asyncio


class Network(widgets.Box):
    def __init__(self):
        self.network_service = NetworkService()
        self.wifi = self.network_service.wifi

        self.icon = widgets.Icon(
            css_classes=["network-icon"],
            image=self.wifi.icon_name,
            pixel_size=16,
        )
        self.ap_list = widgets.ListBox()

        super().__init__(
            css_classes=["unset", "network-container"], child=[self.icon, self.ap_list]
        )

    def _load_access_points(self):
        rows = []

        for device in self.wifi.devices:
            for ap in device.access_points:
                label = widgets.Label(
                    label=f"{ap.ssid or 'Desconhecido'} ({ap.strength}%)"
                )

                row = widgets.ListBoxRow(
                    child=label,
                    on_activate=lambda _, ap=ap: asyncio.create_task(
                        exec_sh_async(self._connect_to_ap(ap))
                    ),
                )

                rows.append(row)

        self.ap_list.set_rows(rows)

    async def _connect_to_ap(self, ap):
        if ap.security:
            await ap.connect_to_graphical()
        else:
            await ap.connect_to()
        self._update_ui()
