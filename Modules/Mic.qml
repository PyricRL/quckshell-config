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
      return ""
    }

    const vol = source.audio.volume

    if (vol === 0) return ""
    return ""
  }

  small: true
  accentBg: false
  accentText: true

  onClicked: function() {
    if (Visibilities.currentActiveModule === "informationmenu") {
      Visibilities.setActiveModule("")
    } else {
      Visibilities.setActiveModule("informationmenu")
      Visibilities.setActiveTab("audio")
    }
  }

  onWheelEvent: function(event) {
    const source = Pipewire.defaultAudioSource

    if (!source || !source.ready || !source.audio) {
      return
    }

    const step = 0.05
    const currentVol = source.audio.volume

    if (event.angleDelta.y > 0) {
      source.audio.volume = Math.min(1.0, currentVol + step)
    } else if (event.angleDelta.y < 0) {
      source.audio.volume = Math.max(0.0, currentVol - step)
    }
  }
}

