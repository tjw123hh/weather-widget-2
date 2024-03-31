/*
 * Copyright 2015  Martin Kotelnik <clearmartin@seznam.cz>
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTIAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http: //www.gnu.org/licenses/>.
 */
import QtQuick
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import Qt5Compat.GraphicalEffects
import org.kde.kirigami as Kirigami


Item {
    id: compactRepresentation

    anchors.fill: parent

    property int defaultWidgetSize: -1
    property int layoutType: main.layoutType

    CompactItem {
        id: compactItem
    }
    // Rectangle {
    //     id: red
    //     anchors.fill: parent
    //     opacity: 0.5
    //     color: "red"
    // }

    Layout.preferredWidth: ((layoutType === 0) && (! main.vertical) && (! main.onDesktop)) ? defaultWidgetSize * 1.6 : defaultWidgetSize
    Layout.preferredHeight: ((layoutType === 1) && (main.vertical) && (! main.onDesktop)) ? defaultWidgetSize * 1.6 : defaultWidgetSize

    PlasmaComponents.Label {
        id: lastReloadedNotifier

        anchors.left: parent.left
        anchors.bottom: parent.bottom
        anchors.bottomMargin: - defaultWidgetSize * 0.05
        verticalAlignment: Text.AlignBottom
        width: parent.width
        fontSizeMode: Text.Fit
        font.pointSize: -1
        color: Kirigami.Theme.highlightColor
        text: lastReloadedText
        wrapMode: Text.WordWrap
        visible: false
    }

    DropShadow {
        anchors.fill: lastReloadedNotifier
        radius: 3
        samples: 16
        spread: 0.8
        fast: true
        color: Kirigami.Theme.backgroundColor
        source: lastReloadedNotifier
        visible: (lastReloadedText.visible === true)
    }


    MouseArea {
        anchors.fill: parent

        acceptedButtons: Qt.LeftButton | Qt.MiddleButton

        hoverEnabled: true

        onEntered: {
            lastReloadedNotifier.visible = !plasmoid.expanded
        }

        onExited: {
            lastReloadedNotifier.visible = false
        }

        onClicked: (mouse)=> {
                       if (mouse.button === Qt.MiddleButton) {
                           loadingData.failedAttemptCount = 0
                           main.loadDataFromInternet()
                       } else {
                           main.expanded = !main.expanded
                           lastReloadedNotifier.visible = !main.expanded
                       }
                   }

        PlasmaCore.ToolTipArea {
            id: toolTipArea
            anchors.fill: parent
            active: !plasmoid.expanded
            interactive: true
            mainText: main.currentPlace.alias
            subText:  main.toolTipSubText
            textFormat: Text.RichText
            icon: Qt.resolvedUrl('../images/weather-widget.svg')
        }

    }
    Component.onCompleted: {
         if ((defaultWidgetSize === -1) && ( compactRepresentation.width > 0 ||  compactRepresentation.height)) {
            defaultWidgetSize = Math.min(compactRepresentation.width, compactRepresentation.height)
         }
    }
}
