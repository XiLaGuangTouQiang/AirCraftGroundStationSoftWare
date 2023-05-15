
#ifndef S_LICENSE_H
#define S_LICENSE_H

#include <QObject>

#include <iostream>
#include <map>
#include <licensecc/licensecc.h>

using namespace std;
class SLicense:public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged);
    Q_PROPERTY(bool licenseFlag READ licenseFlag WRITE setlicenseFlag NOTIFY licenseFlagChanged);
public:
    SLicense();
    ~SLicense();

    QString title();
    void setTitle(QString strTitle);
    void setlicenseFlag(bool licenseFlag);

    bool licenseFlag();

signals:
    void titleChanged();
    void licenseFlagChanged();

public slots:

private:
    QString     m_title;
    bool        m_licenseFlag;
};
#endif // S_LICENSE_H
