import Quickshell
import QtQuick

import Quickshell.Services.Pipewire

import qs.Items
import qs.Items.Styled

StyledButton {
  PwObjectTracker {
    objects: [Pipewire.defaultAudioSource]
  }

  text: {
    const source = Pipewire.defaultAudioSource

    if (!source || !source.ready || !source.audio) {
      return " "
    }

    if (source.audio.muted || source.audio.volume === 0) {
      return "  "
    }

    return "  "
  }

  small: true
  accentBg: false
  accentText: true

  onClicked: function () {
    if (Visibilities.currentActiveModule === "informationmenu") {
      Visibilities.setActiveModule("");
    } else {
      Visibilities.setActiveModule("informationmenu")
      Visibilities.setActiveTab("audio")
    }
  } 
}
