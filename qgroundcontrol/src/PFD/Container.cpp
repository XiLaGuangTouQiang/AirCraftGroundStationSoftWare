#include "Container.hpp"

#include <QGridLayout>
#include <QPainter>
#include <QQuickWindow>
#include <QTimer>
#include <iostream>
#include <tuple>
#include "specific.h"

using namespace std::chrono_literals;
QGraphicsOpacityEffect *opacityEffect;

QQuickWidgetContainer::RenderW::RenderW(QQuickWidgetContainer *parent)
{
    _parent = parent;
    setLayout(new QGridLayout);
    layout()->setSpacing(0);
    layout()->addWidget(parent->contentItem);
    layout()->setContentsMargins(0, 0, 0, 0);
    this->setWindowFlags(Qt::FramelessWindowHint);
    opacityEffect = new QGraphicsOpacityEffect;
    this->setGraphicsEffect(opacityEffect);
    opacityEffect->setOpacity(0.8);
    QTimer::singleShot(100ms, this, qOverload<>(&RenderW::update));
}

void QQuickWidgetContainer::RenderW::paintEvent(QPaintEvent *)
{
    QPainter painter{ this };
    const auto position = mapFromParent(pos());
    const auto rx= position.x();
    const auto ry= position.y();
    _parent->setFocus(false);
    //const auto &[rx, ry] = std::tuple(position.x(), position.y());
    painter.drawImage(rx, ry, _parent->window()->grabWindow(), x(), y(), width() - rx, height() - ry);
    painter.end();
}

bool QQuickWidgetContainer::RenderW::event(QEvent *event)
{

    const auto events = { QEvent::MouseButtonRelease, QEvent::MouseButtonPress, QEvent::MouseButtonDblClick,
                          QEvent::MouseMove,          QEvent::UpdateRequest,    QEvent::KeyPress,
                          QEvent::KeyRelease,         QEvent::FocusIn,          QEvent::FocusOut
                        };
    if (std::find(events.begin(), events.end(), event->type()) != events.end())
        update();
    return QWidget::event(event);

}

QQuickWidgetContainer::QQuickWidgetContainer(QQuickItem *parent) : QQuickItem(parent)
{
    //setAcceptedMouseButtons(Qt::AllButtons);
    //setAcceptHoverEvents(Qt::AllButtons);
    //setAcceptTouchEvents(true);
    //setFocus(true);
    t_flag = 0;
}

QQuickWidgetContainer::~QQuickWidgetContainer()
{
    delete renderer;
}

void QQuickWidgetContainer::setupWidget(QWidget *widget)
{
    contentItem = widget;
    renderer = new RenderW(this);
    renderer->setContentsMargins(0, 0, 0, 0);

    renderer->winId();
    //renderer->internalWinId();
    //renderer->windowHandle()->setParent(qobject_cast<QWindow*>(pWidget));
    renderer->windowHandle()->setParent(window());
    renderer->show();

    const auto resizeToParent = [this]()
    {
        const auto dw = width() == 0 ? renderer->minimumSizeHint().width() : width();
        const auto dh = height() == 0 ? renderer->minimumSizeHint().height() : height();
        const auto dx = parentItem()->x() + x();
        const auto dy = parentItem()->y() + y();
        //renderer->setGeometry(dx, dy, dw, dh);

        //renderer->setGeometry(10, 1000, 900, 500);
        renderer->setGeometry(1500, 150, 1065, 645);
        //renderer->setAutoFillBackground(true);
        renderer->setAutoFillBackground(true);
        renderer->update();
    };

    connect(this, &QQuickWidgetContainer::widthChanged, this, resizeToParent);
    connect(this, &QQuickWidgetContainer::heightChanged, this, resizeToParent);
    connect(this, &QQuickWidgetContainer::xChanged, this, resizeToParent);
    connect(this, &QQuickWidgetContainer::yChanged, this, resizeToParent);
    resizeToParent();
    renderer->setFixedSize(0, 0);
}

/*slots void QQuickWidgetContainer::p_turn()
{
    //renderer->setVisible(0);
    if(QQuickWidgetContainer::t_flag==0)
    {
        renderer->setFixedSize(0, 0);
        QQuickWidgetContainer::t_flag = 1;
    }
    else
    {
        QQuickWidgetContainer::t_flag = 0;
        //renderer->setFixedSize(this->width(), this->height());
        renderer->setFixedSize(1045, 645);
    }
}*/
slots void QQuickWidgetContainer::p_turnoff()
{
    renderer->setFixedSize(0, 0);
}
slots void QQuickWidgetContainer::p_turnon()
{
    renderer->setFixedSize(1045, 645);
}

#if 0
slots void QQuickWidgetContainer::p_show()
{
    renderer->setFixedSize(this->width(), this->height());
}
#endif
slots void QQuickWidgetContainer::pfdHasColor()
{
    CTX_PFD_Controller.inputs_ctx.IO_Input.ipBkg_Land_vis_Status= 1;
    CTX_PFD_Controller.inputs_ctx.IO_Input.ipBkg_Sky_vis_Status = 1;

    CTX_PFD_Controller.inputs_ctx.IO_Input.ipBkg_Land_Color = 18;  //18
    CTX_PFD_Controller.inputs_ctx.IO_Input.ipBkg_Sky_Color = 9;  //9
    opacityEffect->setOpacity(1.0);
    CTX_PFD_Controller.inputs_ctx.IO_Input.ipBkg_Land_Opacity = 170;
    CTX_PFD_Controller.inputs_ctx.IO_Input.ipBkg_Sky_Opacity = 170;
}

slots void QQuickWidgetContainer::pfdNoColor()
{
    CTX_PFD_Controller.inputs_ctx.IO_Input.ipBkg_Land_vis_Status= 0;
    CTX_PFD_Controller.inputs_ctx.IO_Input.ipBkg_Sky_vis_Status = 0;

    CTX_PFD_Controller.inputs_ctx.IO_Input.ipBkg_Land_Color = 0;  //18
    CTX_PFD_Controller.inputs_ctx.IO_Input.ipBkg_Sky_Color = 0;  //9
    opacityEffect->setOpacity(0.8);
    CTX_PFD_Controller.inputs_ctx.IO_Input.ipBkg_Land_Opacity = 0;
    CTX_PFD_Controller.inputs_ctx.IO_Input.ipBkg_Sky_Opacity = 0;
}


