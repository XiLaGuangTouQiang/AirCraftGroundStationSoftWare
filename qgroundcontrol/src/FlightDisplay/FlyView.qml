/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick                  2.12
import QtQuick.Controls         2.4
import QtQuick.Dialogs          1.3
import QtQuick.Layouts          1.12

import QtLocation               5.3
import QtPositioning            5.3
import QtQuick.Window           2.2
import QtQml.Models             2.1

import QGroundControl               1.0
import QGroundControl.Airspace      1.0
import QGroundControl.Airmap        1.0
import QGroundControl.Controllers   1.0
import QGroundControl.Controls      1.0
import QGroundControl.FactSystem    1.0
import QGroundControl.FlightDisplay 1.0
import QGroundControl.FlightMap     1.0
import QGroundControl.Palette       1.0
import QGroundControl.ScreenTools   1.0
import QGroundControl.Vehicle       1.0

Item {
    id: _root

    // These should only be used by MainRootWindow
    property var planController:    _planController
    property var guidedController:  _guidedController

    PlanMasterController {
        id:                     _planController
        flyView:                true
        Component.onCompleted:  start()
    }

    property bool   _mainWindowIsMap:       mapControl.pipState.state === mapControl.pipState.fullState
    property bool   _isFullWindowItemDark:  _mainWindowIsMap ? mapControl.isSatelliteMap : true
    property var    _activeVehicle:         QGroundControl.multiVehicleManager.activeVehicle
    property var    _missionController:     _planController.missionController
    property var    _geoFenceController:    _planController.geoFenceController
    property var    _rallyPointController:  _planController.rallyPointController
    property real   _margins:               ScreenTools.defaultFontPixelWidth / 2
    property var    _guidedController:      guidedActionsController
    property var    _guidedActionList:      guidedActionList
    property var    _guidedValueSlider:       guidedValueSlider
    property real   _toolsMargin:           ScreenTools.defaultFontPixelWidth * 0.75
    property rect   _centerViewport:        Qt.rect(0, 0, width, height)
    property real   _rightPanelWidth:       ScreenTools.defaultFontPixelWidth * 30
    property var    _mapControl:            mapControl

    property real   _fullItemZorder:    0
    property real   _pipItemZorder:     QGroundControl.zOrderWidgets

    function _calcCenterViewPort() {
        var newToolInset = Qt.rect(0, 0, width, height)
        toolstrip.adjustToolInset(newToolInset)
        if (QGroundControl.corePlugin.options.instrumentWidget) {
            flightDisplayViewWidgets.adjustToolInset(newToolInset)
        }
    }

    QGCToolInsets {
        id:                     _toolInsets
        leftEdgeBottomInset:    _pipOverlay.visible ? _pipOverlay.x + _pipOverlay.width : 0
        bottomEdgeLeftInset:    _pipOverlay.visible ? parent.height - _pipOverlay.y : 0
    }

    FlyViewWidgetLayer {
        id:                     widgetLayer
        anchors.top:            parent.top
        anchors.bottom:         parent.bottom
        anchors.left:           parent.left
        anchors.right:          guidedValueSlider.visible ? guidedValueSlider.left : parent.right
        z:                      _fullItemZorder + 1
        parentToolInsets:       _toolInsets
        mapControl:             _mapControl
        visible:                !QGroundControl.videoManager.fullScreen
    }

    FlyViewCustomLayer {
        id:                 customOverlay
        anchors.fill:       widgetLayer
        z:                  _fullItemZorder + 2
        parentToolInsets:   widgetLayer.totalToolInsets
        mapControl:         _mapControl
        visible:            !QGroundControl.videoManager.fullScreen
    }

    GuidedActionsController {
        id:                 guidedActionsController
        missionController:  _missionController
        actionList:         _guidedActionList
        guidedValueSlider:     _guidedValueSlider
    }

    /*GuidedActionConfirm {
        id:                         guidedActionConfirm
        anchors.margins:            _margins
        anchors.bottom:             parent.bottom
        anchors.horizontalCenter:   parent.horizontalCenter
        z:                          QGroundControl.zOrderTopMost
        guidedController:           _guidedController
        guidedValueSlider:             _guidedValueSlider
    }*/

    GuidedActionList {
        id:                         guidedActionList
        anchors.margins:            _margins
        anchors.bottom:             parent.bottom
        anchors.horizontalCenter:   parent.horizontalCenter
        z:                          QGroundControl.zOrderTopMost
        guidedController:           _guidedController
    }

    //-- Guided value slider (e.g. altitude)
    GuidedValueSlider {
        id:                 guidedValueSlider
        anchors.margins:    _toolsMargin
        anchors.right:      parent.right
        anchors.top:        parent.top
        anchors.bottom:     parent.bottom
        z:                  QGroundControl.zOrderTopMost
        radius:             ScreenTools.defaultFontPixelWidth / 2
        width:              ScreenTools.defaultFontPixelWidth * 10
        color:              qgcPal.window
        visible:            false
    }

    FlyViewMap {
        id:                     mapControl
        planMasterController:   _planController
        rightPanelWidth:        ScreenTools.defaultFontPixelHeight * 9
        pipMode:                !_mainWindowIsMap
        toolInsets:             customOverlay.totalToolInsets
        mapName:                "FlightDisplayView"
    }

    FlyViewVideo {
        id: videoControl
    }

    QGCPipOverlay {
        id:                     _pipOverlay
        anchors.left:           parent.left
        anchors.bottom:         parent.bottom
        //anchors.right:           parent.right  //shiwei 20230428 add
        //anchors.top:             parent.top    //shiwei 20230428 add
        anchors.margins:        _toolsMargin
        item1IsFullSettingsKey: "MainFlyWindowIsMap"
        item1:                  mapControl
        item2:                  QGroundControl.videoManager.hasVideo ? videoControl : null
        fullZOrder:             _fullItemZorder
        pipZOrder:              _pipItemZorder
        show:                   !QGroundControl.videoManager.fullScreen &&
                                    (videoControl.pipState.state === videoControl.pipState.pipState || mapControl.pipState.state === mapControl.pipState.pipState)
    }


    WidgetContainer {
        id: container
        objectName: "myWidget"
        //anchors.fill: parent
        //anchors.margins: 0
        //anchors.margins:  120
        //anchors.left:           parent.left
        //anchors.bottom:         parent.bottom
        //anchors.right:      parent.right
        //anchors.horizontalCenterOffset : 879
        //anchors.verticalCenterOffset :69
    }

    Button{
           id:closePFD
           anchors.right: parent.right
           //x:1500  //设置按钮的横坐标
           anchors.bottom:parent.bottom
           //y:800  //设置纵坐标
           text:"PFD"   //按钮标题

           objectName: "PFDClose";
           //icon.source: "qrc:/qmlimages/Gps.svg"
           //icon.color: "transparent"
           display: AbstractButton.TextUnderIcon
           width: 100
           height: 100
           //Image{
           //            anchors.fill: parent
           //            source: "qrc:/qmlimages/Gps.svg"
           //       }
           contentItem: Text {
                   text: closePFD.text
                   font: closePFD.font
                   color: "white"
                   opacity: enabled ? 1.0 : 0.3
                   horizontalAlignment: Text.AlignHCenter
                   verticalAlignment: Text.AlignVCenter
                   elide: Text.ElideRight
               }

           //设置按钮背景颜色
                   background: Rectangle {
                          color: Qt.rgba(0/255,0/255,0/255,1)
                          }

       }

 /*   Component{
        id:syncDropPanelPFD
        WidgetContainer {
            id: container
            objectName: "myWidget"
        }
    }
    */
    Component {
        id: fmcpPanel
        ColumnLayout {
            spacing:    10
            RowLayout{
                spacing:    180
                QGCLabel {
                    Layout.alignment:   Qt.AlignCenter
                    //Layout.fillWidth:   true
                    text:               qsTr("SPEED")
                    visible:            true
                }
                QGCLabel {
                    Layout.alignment:   Qt.AlignCenter
                    //Layout.fillWidth:   true
                    text:               qsTr("HDG/TRK")
                    visible:            true
                }
                QGCLabel {
                    Layout.alignment:   Qt.AlignCenter
                    //Layout.fillWidth:   true
                    text:               qsTr("ASEL")
                    visible:            true
                }
                QGCLabel {
                    Layout.alignment:   Qt.AlignCenter
                    //Layout.fillWidth:   true
                    text:               qsTr("VS/FPA")
                    visible:            true
                }
            }

            RowLayout {
                QGCLabel {
                    id:speed
                    Layout.alignment:   Qt.AlignCenter
                    //Layout.fillWidth:   true
                    text:               qsTr("IAS")
                    visible:            true
                }
                QGCTextField {
                    //anchors.centerIn:   parent
                    Layout.alignment:   Qt.AlignCenter
                    //Layout.fillWidth:   true
                    visible:            true
                    text:               qsTr(Math.round(control.value).toString())

                }
                QGCLabel {
                    id:hdg_trk
                    Layout.alignment:   Qt.AlignCenter
                    //Layout.fillWidth:   true
                    text:               qsTr("HDG")
                    visible:            true
                }
                QGCTextField {
                    Layout.alignment:   Qt.AlignCenter
                    //Layout.fillWidth:   true
                    visible:            true
                    text:               qsTr(Math.round(control1.value).toString())
                }
                QGCTextField {
                    Layout.alignment:   Qt.AlignCenter
                    //Layout.fillWidth:   true
                    visible:            true
                    text:               qsTr(Math.round(control2.value).toString())
                }
                QGCLabel {
                    id:fpa_vs
                    Layout.alignment:   Qt.AlignCenter
                    //Layout.fillWidth:   true
                    text:               qsTr("FPA")
                    visible:            true
                }
                QGCTextField {
                    Layout.alignment:   Qt.AlignCenter
                    //Layout.fillWidth:   true
                    visible:            true
                    text:               qsTr(Math.round(control3.value).toString())
                    }

            }
            RowLayout{
                id:dial_col
                //Layout.fillWidth:   true
                //spacing:            50
                visible:            true
                Dial {
                        id: control
                        wrap:true
                        width:0
                        height:0
                        from:-15
                        to:15
                        stepSize:1
                        background: Rectangle {
                            x: control.width / 2 - width / 2
                            y: control.height / 2 - height / 2
                            width: Math.max(25, Math.min(control.width, control.height))
                            height: width
                            color: "transparent"
                            radius: width / 2
                            border.color: control.pressed ? "white" : "gray"
                            opacity: control.enabled ? 1 : 0.3
                        }

                        handle: Rectangle {
                            id: handleItem
                            x: control.background.x + control.background.width / 2 - width / 2
                            y: control.background.y + control.background.height / 2 - height / 2
                            width: 16
                            height: 16
                            color: control.pressed ? "white" : "gray"
                            radius: 8
                            antialiasing: true
                            opacity: control.enabled ? 1 : 0.3
                            transform: [
                                Translate {
                                    y: -Math.min(control.background.width, control.background.height) * 0.4 + handleItem.height / 2
                                },
                                Rotation {
                                    angle: control.angle
                                    origin.x: handleItem.width / 2
                                    origin.y: handleItem.height / 2
                                }
                            ]
                        }
                    }
                Dial {
                        id: control1
                        width:0
                        height:0
                        wrap:true
                        from:-15
                        to:15
                        stepSize:1
                        background: Rectangle {
                            x: control1.width / 2 - width / 2
                            y: control1.height / 2 - height / 2
                            width: Math.max(25, Math.min(control1.width, control1.height))
                            height: width
                            color: "transparent"
                            radius: width / 2
                            border.color: control1.pressed ? "white" : "gray"
                            opacity: control1.enabled ? 1 : 0.3
                        }

                        handle: Rectangle {
                            id: handleItem1
                            x: control1.background.x + control1.background.width / 2 - width / 2
                            y: control1.background.y + control1.background.height / 2 - height / 2
                            width: 16
                            height: 16
                            color: control1.pressed ? "white" : "gray"
                            radius: 8
                            antialiasing: true
                            opacity: control1.enabled ? 1 : 0.3
                            transform: [
                                Translate {
                                    y: -Math.min(control1.background.width, control1.background.height) * 0.4 + handleItem1.height / 2
                                },
                                Rotation {
                                    angle: control1.angle
                                    origin.x: handleItem1.width / 2
                                    origin.y: handleItem1.height / 2
                                }
                            ]
                        }
                    }
                Dial {
                        id: control2
                        width:0
                        height:0
                        wrap:true
                        from:-15
                        to:15
                        stepSize:1
                        background: Rectangle {
                            x: control2.width / 2 - width / 2
                            y: control2.height / 2 - height / 2
                            width: Math.max(25, Math.min(control2.width, control2.height))
                            height: width
                            color: "transparent"
                            radius: width / 2
                            border.color: control2.pressed ? "white" : "gray"
                            opacity: control2.enabled ? 1 : 0.3
                        }

                        handle: Rectangle {
                            id: handleItem2
                            x: control2.background.x + control2.background.width / 2 - width / 2
                            y: control2.background.y + control2.background.height / 2 - height / 2
                            width: 16
                            height: 16
                            color: control2.pressed ? "white" : "gray"
                            radius: 8
                            antialiasing: true
                            opacity: control2.enabled ? 1 : 0.3
                            transform: [
                                Translate {
                                    y: -Math.min(control2.background.width, control2.background.height) * 0.4 + handleItem2.height / 2
                                },
                                Rotation {
                                    angle: control2.angle
                                    origin.x: handleItem2.width / 2
                                    origin.y: handleItem2.height / 2
                                }
                            ]
                        }
                    }
                Dial {
                        id: control3
                        width:0
                        height:0
                        wrap:true
                        from:-15
                        to:15
                        stepSize:1
                        background: Rectangle {
                            x: control3.width / 2 - width / 2
                            y: control3.height / 2 - height / 2
                            width: Math.max(25, Math.min(control3.width, control3.height))
                            height: width
                            color: "transparent"
                            radius: width / 2
                            border.color: control3.pressed ? "white" : "gray"
                            opacity: control3.enabled ? 1 : 0.3
                        }

                        handle: Rectangle {
                            id: handleItem3
                            x: control3.background.x + control3.background.width / 2 - width / 2
                            y: control3.background.y + control3.background.height / 2 - height / 2
                            width: 16
                            height: 16
                            color: control3.pressed ? "white" : "gray"
                            radius: 8
                            antialiasing: true
                            opacity: control3.enabled ? 1 : 0.3
                            transform: [
                                Translate {
                                    y: -Math.min(control3.background.width, control3.background.height) * 0.4 + handleItem3.height / 2
                                },
                                Rotation {
                                    angle: control3.angle
                                    origin.x: handleItem3.width / 2
                                    origin.y: handleItem3.height / 2
                                }
                            ]
                        }
                    }
            }
            RowLayout{
                id:switch_col
                Layout.fillWidth:   true
                //spacing:            50
                visible:            true
                Switch{
                        id : switch1
                        Layout.fillWidth:   true
                        //text: qsTr("spd_src")
                        Text {
                            id :switchT1
                            text: qsTr("MAN")
                            color:"white"
                        }
                        onCheckedChanged: {
                            switchT1.text = switch1.checked ? qsTr("FMS") : qsTr("MAN")
                        }
                    }
                Switch{
                        id : switch2
                        Layout.fillWidth:   true
                        //text: qsTr("spd_typ")
                        Text {
                            id :switchT2
                            text: qsTr("IAS")
                            color:"white"
                        }
                        onCheckedChanged: {
                            switchT2.text = switch2.checked ? qsTr("MACH") : qsTr("IAS")
                            speed.text = switch2.checked ? qsTr("MACH") : qsTr("IAS")
                        }
                    }
                Switch{
                        id : switch3
                        Layout.fillWidth:   true
                        //text: qsTr("asel_resolution")
                        Text {
                            id :switchT3
                            text: qsTr("100")
                            color:"white"
                        }
                        onCheckedChanged: {
                            switchT3.text = switch3.checked ? qsTr("1000") : qsTr("100")
                        }
                    }
                Switch{
                        id : switch4
                        Layout.fillWidth:   true
                        //text: qsTr("mode")
                        Text {
                            id :switchT4
                            text: qsTr("HDG-VS")
                            color:"white"
                        }
                        onCheckedChanged: {
                            switchT4.text = switch4.checked ? qsTr("TRK-FPA") : qsTr("HDG-VS")
                            hdg_trk.text = switch4.checked ? qsTr("TRK") : qsTr("HDG")
                            fpa_vs.text = switch4.checked ? qsTr("FPA") : qsTr("VS")
                        }
                }
            }
            RowLayout {
                id:second_last_col
                Layout.fillWidth:   true
                //spacing:            50
                visible:            true
                QGCButton {
                    id:at
                    text:               qsTr("A/THR")
                    Layout.fillWidth:   true
                    enabled:            true
                    visible:            true
                    onClicked: {
                    }
                }
                QGCButton {
                    id:loc
                    text:               qsTr("LOC")
                    Layout.fillWidth:   true
                    enabled:            true
                    visible:            true
                    onClicked: {
                    }
                }
                QGCButton {
                    id:appr
                    text:               qsTr("APPR")
                    Layout.fillWidth:   true
                    enabled:            true
                    visible:            true
                    onClicked: {
                    }
                }
                QGCButton {
                    id:lnav
                    text:               qsTr("LNAV")
                    Layout.fillWidth:   true
                    enabled:            true
                    visible:            true
                    onClicked: {
                    }
                }
                QGCButton {
                    id:ap
                    text:               qsTr("AP")
                    Layout.fillWidth:   true
                    enabled:            true
                    visible:            true
                    onClicked: {
                    }
                }
                QGCButton {
                    id:vnav
                    text:               qsTr("VNAV")
                    Layout.fillWidth:   true
                    enabled:            true
                    visible:            true
                    onClicked: {
                    }
                }
            }
            RowLayout {
                id:last_col
                Layout.fillWidth:   true
                //spacing:            50
                visible:            true
                QGCButton {
                    id:fd_left
                    text:               qsTr("FD")
                    Layout.fillWidth:   true
                    enabled:            true
                    visible:            true
                    onClicked: {
                    }
                }
                QGCButton {
                    id:flch
                    text:               qsTr("FLCH")
                    Layout.fillWidth:   true
                    enabled:            true
                    visible:            true
                    onClicked: {
                    }
                }
                QGCButton {
                    id:hdg_trk_pb
                    text:               qsTr("HDG/TRK")
                    Layout.fillWidth:   true
                    enabled:            true
                    visible:            true
                    onClicked: {
                    }
                }
                QGCButton {
                    id:alt
                    text:               qsTr("ALT")
                    Layout.fillWidth:   true
                    enabled:            true
                    visible:            true
                    onClicked: {
                    }
                }
                QGCButton {
                    id:vs
                    text:               qsTr("VS")
                    Layout.fillWidth:   true
                    enabled:            true
                    visible:            true
                    onClicked: {
                    }
                }
                QGCButton {
                    id:fd_right
                    text:               qsTr("FD")
                    Layout.fillWidth:   true
                    enabled:            true
                    visible:            true
                    onClicked: {
                    }
                }
            }
        }
    }
}
