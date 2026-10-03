import Quickshell
import QtQuick

import qs.modules.interface.bar
import qs.modules.interface.launcher
import qs.modules.interface.notification
import qs.modules.interface.rightpanel

import qs.services


Scope {
  id: shell

  Bar {}

  Launcher {}

  Notification {}

  RightPanel {}

  IPC {}
}
