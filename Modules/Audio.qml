import Quickshell
import QtQuick

import Quickshell.Services.Pipewire

import qs.Items
import qs.Items.Styled

StyledButton {
  PwObjectTracker {
    id: sinkTracker
    objects: [Pipewire.defaultAudioSink]
  }

  text: {
    const sink = Pipewire.defaultAudioSink
    if (sink && sink.bound && sink.audio) {
      return ""
    }

    const vol = sink.audio.volume
    if (vol === 0) return ""
    if (vol < 0.5) return ""
    return ""
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

  onWheelEvent: function(event) {
    const sink = Pipewire.defaultAudioSink

    if (!sink || !sink.ready || !sink.audio) {
      return
    }

    const step = 0.05
    const currentVol = sink.audio.volume
    let newVol = currentVol

    if (event.angleDelta.y > 0) {
      newVol = Math.min(1.0, currentVol + step)
    } else if (event.angleDelta.y < 0) {
      newVol = Math.max(0.0, currentVol - step)
    }

    sink.audio.volume = newVol
  }
}
