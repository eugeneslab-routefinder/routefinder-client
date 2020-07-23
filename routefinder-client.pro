QT += quick network svg core xml
#QTPLUGIN += qsvg qsvgicon

CONFIG += c++11

# The following define makes your compiler emit warnings if you use
# any Qt feature that has been marked deprecated (the exact warnings
# depend on your compiler). Refer to the documentation for the
# deprecated API to know how to port your code away from it.
DEFINES += QT_DEPRECATED_WARNINGS

# You can also make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
# You can also select to disable deprecated APIs only up to a certain version of Qt.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \
        RFHttpHandler.cpp \
        RFLocationsModel.cpp \
        RFResponseInterface.cpp \
        RFRouteModel.cpp \
        RFUserHandler.cpp \
        main.cpp

RESOURCES += \
    qml.qrc

TARGET = Routefinder

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Additional import path used to resolve QML modules just for Qt Quick Designer
QML_DESIGNER_IMPORT_PATH =

VER_MAJ = 0
VER_MIN = 6
VER_PAT = 0

DEFINES += "VERSION_MAJOR=$$VER_MAJ"\
       "VERSION_MINOR=$$VER_MIN"

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

HEADERS += \
    RFCommonData.h \
    RFHttpHandler.h \
    RFLocationsModel.h \
    RFResponseInterface.h \
    RFRouteModel.h \
    RFUserHandler.h


lupdate_only {
    SOURCES += \
            $$PWD/qml/*.qml \
            $$PWD/qml/components/*.qml
}

TRANSLATIONS += \
            $$PWD/translations/routefinder_ru_RU.ts \
            $$PWD/translations/routefinder_cz_CZ.ts

win32: {

    MOC_DIR = ./moc
    OBJECTS_DIR = ./obj
    RCC_DIR = ./rcc
    QML_DIR = ./qml
    DESTDIR = ./out

    RC_ICONS = $$PWD/res/icon/ic_logo.ico
    CONFIG(release, debug|release) {
        QMAKE_POST_LINK += d:/Application/Qt/5.15.0/mingw81_32/bin/windeployqt $$OUT_PWD/$$DESTDIR --qmldir $$PWD
    }
}

#android {
#    assets.files = res/icon/*.*
#    assets.path = /assets/res/icon/
#    INSTALLS += assets
#}

DISTFILES += \
    android/AndroidManifest.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew \
    android/gradlew.bat \
    android/res/values/libs.xml

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
