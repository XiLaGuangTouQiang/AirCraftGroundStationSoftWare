#include "SLicense.h"

SLicense::SLicense() : QObject()
{
#ifndef _DEBUG
    map<LCC_EVENT_TYPE, string> stringByEventType;
    stringByEventType[LICENSE_OK] = "OK ";
    stringByEventType[LICENSE_FILE_NOT_FOUND] = "license file not found ";
    stringByEventType[LICENSE_SERVER_NOT_FOUND] = "license server can't be contacted ";
    stringByEventType[ENVIRONMENT_VARIABLE_NOT_DEFINED] = "environment variable not defined ";
    stringByEventType[FILE_FORMAT_NOT_RECOGNIZED] = "license file has invalid format (not .ini file) ";
    stringByEventType[LICENSE_MALFORMED] = "some mandatory field are missing, or data can't be fully read. ";
    stringByEventType[PRODUCT_NOT_LICENSED] = "this product was not licensed ";
    stringByEventType[PRODUCT_EXPIRED] = "license expired ";
    stringByEventType[LICENSE_CORRUPTED] = "license signature didn't match with current license ";
    stringByEventType[IDENTIFIERS_MISMATCH] = "Calculated identifier and the one provided in license didn't match";

    LicenseInfo licenseInfo;
    size_t pc_id_sz = LCC_API_PC_IDENTIFIER_SIZE + 1;
    char pc_identifier[LCC_API_PC_IDENTIFIER_SIZE + 1];

    LCC_EVENT_TYPE result = acquire_license(nullptr, nullptr, &licenseInfo);
#else
    LCC_EVENT_TYPE result = LICENSE_OK;
#endif
    if (result == LICENSE_OK) {
        cout << "license OK" << endl;
        m_licenseFlag = false;
        //memset(&m_title,0,sizeof(m_title));
#ifndef _DEBUG
        if (!licenseInfo.linked_to_pc) {
            cout << "No hardware signature in license file. This is a 'demo' license that works on every pc." << endl
                 << "To generate a 'single pc' license call 'issue license' with option -s " << endl
                 << "and the hardware identifier obtained before." << endl
                 << endl;
        }
#endif
    }

#ifndef _DEBUG
    if (result != LICENSE_OK) {
        cout << "license ERROR :" << endl;
        m_licenseFlag = true;
        cout << "    " << stringByEventType[result].c_str() << endl;
        if (identify_pc(STRATEGY_DEFAULT, pc_identifier, &pc_id_sz, nullptr)) {
            cout << "hardware id is :" << endl;
            cout << "    " << pc_identifier << endl;
            m_title = pc_identifier;
            //memcpy(m_title,pc_identifier,sizeof(pc_identifier));
        } else {
            cerr << "errors in identify_pc" << endl;
        }
    }
#endif
}

SLicense::~SLicense(){}

QString SLicense::title()
{
    return  m_title;
}

bool SLicense::licenseFlag()
{
    return  m_licenseFlag;
}

void SLicense::setTitle(QString strTitle)
{
    //m_title = strTitle;
    emit titleChanged();
}

void SLicense::setlicenseFlag(bool blicenseFlag)
{
    //m_title = strTitle;
    emit licenseFlagChanged();
}
