pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Services.Notifications as QuickshellNotifs
import QtQuick

Singleton {
    id: root

    readonly property ListModel popups: ListModel {}
    readonly property ListModel history: ListModel {}

    function dismissPopup(index) {
        if (index >= 0 && index < popups.count) {
            popups.remove(index);
        }
    }

    QuickshellNotifs.NotificationServer {
        id: server

        keepOnReload: false
        actionsSupported: false
        bodyHyperlinksSupported: true
        bodyImagesSupported: false
        bodyMarkupSupported: true
        imageSupported: true

        onNotification: notification => {
            notification.tracked = true;

            const itemData = {
                summary: notification.summary,
                body: notification.body,
                appName: notification.appName,
                appIcon: notification.appIcon,
                image: notification.image,
                urgency: notification.urgency,
                expireTimeout: notification.expireTimeout > 0 ? notification.expireTimeout : 5000,
                timeDate: (new Date()).toLocaleTimeString(Qt.locale(), "hh:mm A")
            };

            popups.append(itemData);
            history.append(itemData);
        }
    }
}
