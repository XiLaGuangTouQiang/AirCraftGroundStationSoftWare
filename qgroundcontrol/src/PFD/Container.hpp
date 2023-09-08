#pragma once

#include <QQuickPaintedItem>
#include <QRasterWindow>
#include <QWidget>
#include "MAVLinkProtocol.h"
#include "Vehicle.h"

class QQuickWidgetContainer : public QQuickItem
{
    Q_OBJECT
    //Q_PROPERTY(QString okText READ getOkText WRITE setOkText NOTIFY stringChange);

    class RenderW : public QWidget
    {
      public:
        explicit RenderW(QQuickWidgetContainer *parent);
        virtual ~RenderW(){};

      protected:
        virtual void paintEvent(QPaintEvent *e) override;
        virtual bool event(QEvent *event) override;

      private:
        QQuickWidgetContainer *_parent;
    };

public:
    explicit QQuickWidgetContainer(QQuickItem *parent = nullptr);
    ~QQuickWidgetContainer();
    void setupWidget(QWidget *widget);

  private:
    QWidget *renderer = nullptr;
    QWidget *contentItem = nullptr;
    uint32_t t_flag;
    void connectSet();

public slots :
    void p_turnon();
    void p_turnoff();
    void pfdHasColor();
    void pfdNoColor();
    void pfdAttitudeSet(mavlink_attitude_t pfdAttitude);
    void pfdGpsRawSet(mavlink_vfr_hud_t PFDgpsRawInt);
    //void p_hide();

private:
    Vehicle*        vehicle;
};
