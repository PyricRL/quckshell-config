import Quickshell
import QtQuick

import qs.modules.interface.bar
import qs.modules.interface.launcher

import qs.services

import qs.modules.widgets

Scope {
  id: shell

  Bar {}

  Launcher {}

  IPC {}
}
