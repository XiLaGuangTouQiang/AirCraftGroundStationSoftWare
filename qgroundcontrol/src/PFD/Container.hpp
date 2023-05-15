#pragma once

#include <QQuickPaintedItem>
#include <QRasterWindow>
#include <QWidget>

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
    //QGraphicsOpacityEffect* opacityEffect;

  private:
    QWidget *renderer = nullptr;
    QWidget *contentItem = nullptr;
    uint32_t t_flag;

public slots :
    void p_turn();
    void pfdHasColor();
    void pfdNoColor();
    //void p_hide();
};
