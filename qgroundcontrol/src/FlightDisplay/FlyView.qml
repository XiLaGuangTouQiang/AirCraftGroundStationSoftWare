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
    Rectangle{
        anchors.right: parent.right
        anchors.top:parent.top
        //anchors.left:           parent.left
        //anchors.bottom:             parent.bottom
        height:childrenRect.height
        width:childrenRect.width
        color:"black"
        ColumnLayout{
            QGCLabel{
                text:"控制模式"
                anchors.centerIn:parent.Center
                Layout.alignment:   Qt.AlignCenter
            }
            RowLayout{

                QGCRadioButton{
                    id:rb1
                    text:"人工"
                }
                QGCRadioButton{
                    id:rb2
                    text:"增稳"
                }
                QGCRadioButton{
                    id:rb3
                    text:"自主"
                }
            }
        }

    }

    Button{
           id:closePFD
           anchors.right: parent.right
           //x:1500  //设置按钮的横坐标
           anchors.bottom:parent.bottom
           //y:800  //设置纵坐标
           text:"PFD"   //按钮标题
           property bool   click:        false
           onClicked:{
               closePFD.click=!closePFD.click
               if(closePFD.click === false)
               {
                   container.p_turnoff();
               }
               else
               {
                   container.p_turnon();
               }
           }

           QGCCheckBox {
                       id:             pfdcheckBox
                       text:           ""
                       //property int pfdColorFlag: 0;
                       checked : false
                       onCheckedChanged:      {
                           if(pfdcheckBox.checked === false)
                           {
                               container.pfdNoColor();
                               //pfdColorFlag = 1;
                           }
                           else
                           {
                               container.pfdHasColor();
                               //pfdColorFlag = 0;
                           }
                       }
                       anchors.right:   parent.right
                       anchors.top:    parent.top
                       //anchors.verticalCenter: parent.verticalCenter
                       }
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
            RowLayout{
                ColumnLayout{
                    QGCLabel {
                        Layout.alignment:   Qt.AlignCenter
                        //Layout.fillWidth:   true
                        text:               qsTr("SPEED")
                        visible:            true
                        }
                    RowLayout{
                        ColumnLayout{
                            QGCLabel {
                                Layout.alignment:   Qt.AlignCenter
                                //Layout.fillWidth:   true
                                text:               !switch2.checked ? qsTr("IAS"):qsTr("")
                                visible:            true
                                //scale:0.5
                            }
                            QGCLabel {
                                   Layout.alignment:   Qt.AlignCenter
                                   //Layout.fillWidth:   true
                                   text:               switch2.checked ? qsTr("MACH"):qsTr("")
                                   visible:            true
                                   //scale:0.5
                               }
                            }
                        QGCTextField {
                            Layout.alignment:   Qt.AlignCenter
                            //Layout.fillWidth:   true
                            visible:            true
                            text:               qsTr(Math.round(control1.value).toString())
                        }
                    }
                }
                ColumnLayout{
                        QGCLabel {
                            Layout.alignment:   Qt.AlignCenter
                            //Layout.fillWidth:   true
                            text:               qsTr("HDG/TRK")
                            visible:            true
                        }
                        RowLayout{
                           ColumnLayout{
                               QGCLabel {
                                   Layout.alignment:   Qt.AlignCenter
                                   //Layout.fillWidth:   true
                                   text:               !switch4.checked ? qsTr("HDG"):qsTr("")
                                   visible:            true
                                   //scale:0.5
                               }
                               QGCLabel {
                                   Layout.alignment:   Qt.AlignCenter
                                   //Layout.fillWidth:   true
                                   text:               switch4.checked ? qsTr("TRK"):qsTr("")
                                   visible:            true
                                   //scale:0.5
                               }
                            }
                           QGCTextField {
                               Layout.alignment:   Qt.AlignCenter
                               //Layout.fillWidth:   true
                               visible:            true
                               text:               qsTr(Math.round(control1.value).toString())
                           }
                        }
                    }
                ColumnLayout{
                        QGCLabel {
                            Layout.alignment:   Qt.AlignCenter
                            //Layout.fillWidth:   true
                            text:               qsTr("ASEL")
                            visible:            true
                        }
                        RowLayout{
                           ColumnLayout{
                               QGCLabel {
                                   Layout.alignment:   Qt.AlignCenter
                                   //Layout.fillWidth:   true
                                   text:               qsTr("   ")
                                   visible:            true
                                   //scale:0.5
                               }
                               QGCLabel {
                                   Layout.alignment:   Qt.AlignCenter
                                   //Layout.fillWidth:   true
                                   text:               qsTr("   ")
                                   visible:            true
                                   //scale:0.5
                               }
                            }
                           QGCTextField {
                               Layout.alignment:   Qt.AlignCenter
                               //Layout.fillWidth:   true
                               visible:            true
                               text:               qsTr(Math.round(control1.value).toString())
                           }
                        }
                    }
                ColumnLayout{
                        QGCLabel {
                            Layout.alignment:   Qt.AlignCenter
                            //Layout.fillWidth:   true
                            text:               qsTr("VS/FPA")
                            visible:            true
                        }
                        RowLayout{
                           ColumnLayout{
                               QGCLabel {
                                   Layout.alignment:   Qt.AlignCenter
                                   //Layout.fillWidth:   true
                                   text:               !switch4.checked ? qsTr("VS"):qsTr("")
                                   visible:            true
                                   //scale:0.5
                               }
                               QGCLabel {
                                   Layout.alignment:   Qt.AlignCenter
                                   //Layout.fillWidth:   true
                                   text:               switch4.checked ? qsTr("FPA"):qsTr("")
                                   visible:            true
                                   //scale:0.5
                               }
                            }
                           QGCTextField {
                               Layout.alignment:   Qt.AlignCenter
                               //Layout.fillWidth:   true
                               visible:            true
                               text:               qsTr(Math.round(control1.value).toString())
                           }
                        }
                        /*Dial {
                            id: control
                            width:16
                            height:16
                            scale:0.5
                            background: Rectangle {
                                x: control.width / 2 - width / 2
                                y: control.height / 2 - height / 2
                                width: Math.max(16, Math.min(control.width, control.height))
                                height: width
                                color: "transparent"
                                radius: width / 2
                                border.color: control.pressed ? "#17a81a" : "#21be2b"
                                opacity: control.enabled ? 1 : 0.3
                                //visible:false
                            }

                            handle: Rectangle {
                                id: handleItem
                                x: control.background.x + control.background.width / 2 - width / 2
                                y: control.background.y + control.background.height / 2 - height / 2
                                width: 8
                                height: 8
                                color: control.pressed ? "#17a81a" : "#21be2b"
                                radius: 4
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
                        }*/
                    }
            }
            RowLayout{
                    ColumnLayout{
                    id:switch_col
                    spacing:            0
                    visible:            true
                    RowLayout{
                        Switch{
                                id : switch1
                                onCheckedChanged: {
                                    switchT1.text =switch1.checked ? qsTr("MAN") : qsTr("FMS")
                                }
                            }
                        QGCLabel{
                            id :switchT1
                            Layout.alignment:   Qt.AlignCenter
                            text: qsTr("FMS")
                            color:"white"
                        }
                    }
                    RowLayout{
                        Switch{
                                id : switch2
                                onCheckedChanged: {
                                    switchT2.text = switch2.checked ? qsTr("MACH") : qsTr("IAS")
                                }
                            }
                        QGCLabel{
                            id :switchT2
                            Layout.alignment:   Qt.AlignCenter
                            text: qsTr("IAS")
                            color:"white"
                        }
                    }
                    /*RowLayout{
                        Switch{
                                id : switch3
                                onCheckedChanged: {
                                    switchT3.text = switch3.checked ? qsTr("1000") : qsTr("100")
                                }
                            }
                        QGCLabel{
                            id :switchT3
                            Layout.alignment:   Qt.AlignCenter
                            text: qsTr("100")
                            color:"white"
                        }
                    }*/
                    RowLayout{
                        Switch{
                                id : switch4
                                onCheckedChanged: {
                                    switchT4.text = switch4.checked ? qsTr("TRK-FPA") : qsTr("HDG-VS")
                                }
                            }
                        QGCLabel{
                            id :switchT4
                            Layout.alignment:   Qt.AlignCenter
                            text: qsTr("HDG-VS")
                            color:"white"
                        }
                    }

                }
                    GridLayout {
                    id:second_last_col
                    rows: 2 //行数
                    columns: 6 //列数
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
                        property bool   click:        false
                        background:Rectangle{
                            color:lnav.click?"#626270":"green"
                        }
                        onClicked: {click=!click;
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
                        property bool   click:        false
                        background:Rectangle{
                            color:vnav.click?"#626270":"green"
                        }
                        onClicked: {click=!click;
                        }
                   }
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
}
