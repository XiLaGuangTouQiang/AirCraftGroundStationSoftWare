/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQml.Models 2.12

import QGroundControl           1.0
import QGroundControl.Controls  1.0

import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

//import com.private 1.0

ToolStripActionList {
    id: _root

    signal displayPreFlightChecklist

    model: [
        ToolStripAction {
            text:                   qsTr("FMCP")
            enabled:                rb3.checked
            visible:                true
            iconSource:             "/qmlimages/Joystick.png"
            dropPanelComponent:     fmcpPanel
        },
        ToolStripAction {
            text:           qsTr("航点规划")
            iconSource:     "/qmlimages/Plan.svg"
            onTriggered:    mainWindow.showPlanView()
        },

/*        ToolStripAction {
            text:           qsTr("PFD")
            iconSource:     "/qmlimages/Gps.svg"
            objectName:    "PFDClose";
            //onTriggered:    flyview.showContainView()
            //checkable:       true
            dropPanelComponent:     syncDropPanelPFD
        },*/


        PreFlightCheckListShowAction { onTriggered: displayPreFlightChecklist() },
        GuidedActionTakeoff { },
        GuidedActionLand { },
        GuidedActionRTL { },
        GuidedActionPause { },

        GuidedActionActionList { }
    ]

/*
    Component {
        id: syncDropPanelPFD

        ColumnLayout {
            id:         columnHolder
            spacing:    _margin

            WidgetContainer {
                id: container
                objectName: "myWidget"
                anchors.fill: parent
                //anchors.margins: 0
                anchors.margins:  _toolsMargin
                anchors.left:           parent.left
                anchors.bottom:         parent.bottom
            }

        }

    }
    */
}

/*
WidgetContainer {
    id: container
    objectName: "myWidget"
    anchors.fill: parent
    anchors.margins: 50
}
*/

/*
Component {
    id: syncDropPanelPFD

}
*/
