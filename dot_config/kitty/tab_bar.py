import platform
from datetime import datetime

from kitty.boss import get_boss
from kitty.fast_data_types import Screen, add_timer
from kitty.rgb import to_color
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    Formatter,
    TabBarData,
    as_rgb,
    draw_attributed_string,
    draw_tab_with_powerline,
)

RIGHT_HALF_TRIANGLE = ""
LEFT_HALF_TRIANGLE = ""
UNPLUGGED_ICONS = {
    10: "󰂃",
    20: "󰁻",
    30: "󰁼",
    40: "󰁽",
    50: "󰁾",
    60: "󰁿",
    70: "󰂀",
    80: "󰂁",
    90: "󰂂",
    100: "󱟢",
}
CHARGING_ICON = "󰚥"
CALENDAR_ICON = "󰃰"
TERMINAL_ICON = ""
HOST_ICON = "󰒋"
REFRESH_TIME = 1
MAX_PROCESS_NAME_LENGTH = 15
COLORS = {
    "process": "#a8e4a4",
    "datetime": "#90b4fc",
    "battery": "#f9e2af",
    "cpu": "#ff9e64",
    "memory": "#bb9af7",
    "hostname": "#7dcfff",
}


def _get_active_process_name() -> dict:
    """Get the active process name for the current window."""
    cell = {"icon": TERMINAL_ICON, "icon_bg_color": COLORS["process"], "text": ""}
    boss = get_boss()

    if not boss or not boss.active_window or not boss.active_window.child:
        cell["text"] = "terminal"
        return cell

    foreground_processes = boss.active_window.child.foreground_processes
    if not foreground_processes or not foreground_processes[0]["cmdline"]:
        cell["text"] = "terminal"
        return cell

    process_name = foreground_processes[0]["cmdline"][0].rsplit("/", 1)[-1]
    # Truncate long process names
    if len(process_name) > MAX_PROCESS_NAME_LENGTH:
        process_name = process_name[: MAX_PROCESS_NAME_LENGTH - 1] + "…"
    cell["text"] = process_name

    return cell


def _get_datetime() -> dict:
    """Get the current date and time."""
    now = datetime.now().strftime("%d.%m.%Y")
    return {"icon": CALENDAR_ICON, "icon_bg_color": COLORS["datetime"], "text": now}


def _get_hostname() -> dict:
    """Get system hostname."""
    hostname = platform.node()
    return {"icon": HOST_ICON, "icon_bg_color": COLORS["hostname"], "text": hostname}


def _get_battery() -> dict | None:
    cell = {"icon": "", "icon_bg_color": "#f9e2af", "text": ""}

    try:
        with open("/sys/class/power_supply/BAT0/status", "r") as f:
            status = f.read()
        with open("/sys/class/power_supply/BAT0/capacity", "r") as f:
            percent = int(f.read())

        if status == "Charging\n":
            cell["icon"] = CHARGING_ICON
        else:
            cell["icon"] = UNPLUGGED_ICONS[
                min(UNPLUGGED_ICONS.keys(), key=lambda x: abs(percent - x))
            ]
        cell["text"] = str(percent) + "%"

    except FileNotFoundError:
        return None

    return cell


def _create_cells() -> list[dict]:
    """Create all information cells for the tab bar."""
    cells = [_get_active_process_name()]

    # Add system info
    cells.append(_get_hostname())

    # Add battery info if available
    battery = _get_battery()
    if battery:
        cells.append(battery)

    # Add datetime
    cells.append(_get_datetime())

    return cells


def _draw_right_status(screen: Screen, is_last: bool, draw_data: DrawData) -> int:
    """Draw the right status area of the tab bar."""
    if not is_last:
        return 0
    draw_attributed_string(Formatter.reset, screen)

    cells = _create_cells()
    right_status_length = 0
    for c in cells:
        rendered_str = f"{RIGHT_HALF_TRIANGLE} {c['icon']} 󰇙 {c['text']} "
        cell_length = len(rendered_str)
        right_status_length += cell_length

    screen.cursor.x = screen.columns - right_status_length

    default_bg = as_rgb(int(draw_data.default_bg))
    # tab_fg = as_rgb(int(draw_data.inactive_fg))
    screen.cursor.bg = default_bg

    for c in cells:
        icon_bg_color = as_rgb(int(to_color(c["icon_bg_color"])))
        screen.cursor.fg = icon_bg_color
        screen.draw(RIGHT_HALF_TRIANGLE)

        screen.cursor.bg = icon_bg_color
        screen.cursor.fg = 1
        screen.draw(f" {c['icon']} 󰇙 {c['text']} ")

    return screen.cursor.x


def _redraw_tab_bar(_) -> None:
    """Force redrawing of the tab bar."""
    tm = get_boss().active_tab_manager
    if tm is not None:
        tm.mark_tab_bar_dirty()


timer_id = None


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    """Main draw function called by Kitty's tab bar implementation."""
    global timer_id
    if timer_id is None:
        timer_id = add_timer(_redraw_tab_bar, REFRESH_TIME, True)
    draw_tab_with_powerline(
        draw_data, screen, tab, before, max_title_length, index, is_last, extra_data
    )
    _draw_right_status(screen, is_last, draw_data)
    return screen.cursor.x
