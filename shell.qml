import Quickshell
import QtQuick

import qs.modules.interface.bar
import qs.modules.interface.launcher
import qs.modules.interface.notification

import qs.services


Scope {
  id: shell

  Bar {}

  Launcher {}

  IPC {}
}
