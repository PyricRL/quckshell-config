import Quickshell
import QtQuick

import "Modules" as Modules
import "Widgets" as Widgets

import "Modules/Notifications" as Notifications

import "Services" as Services

Scope {
  id: shell

  Modules.Bar {}

  Widgets.PowerMenu {}

  Widgets.NotificationMenu {}

  Notifications.NotificationPopup {}

  Services.IPCService {}
}
