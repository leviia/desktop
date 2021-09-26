set( APPLICATION_NAME           "Leviia" )
set( APPLICATION_SHORTNAME      "Leviia" )
set( APPLICATION_EXECUTABLE     "leviia" )
set( APPLICATION_DOMAIN         "leviia.com" )
set( APPLICATION_VENDOR         "Leviia" )
set( APPLICATION_UPDATE_URL     "https://update.leviia.com" )
set( APPLICATION_HELP_URL       "https://wiki.leviia.com" )
set( APPLICATION_REGISTER_URL   "https://leviia.com" )
set( APPLICATION_CLOUD_URL      "https://cloud.leviia.com" )
set( APPLICATION_ICON_NAME      "Leviia" )
set( APPLICATION_ICON_SET       "SVG" )
set( APPLICATION_SERVER_URL     "" )
set( APPLICATION_SERVER_URL_ENFORCE ON ) # If set and APPLICATION_SERVER_URL is defined, the server can only connect to the pre-defined URL
set( APPLICATION_REV_DOMAIN     "com.leviia.desktopclient" )
set( APPLICATION_VIRTUALFILE_SUFFIX "leviia" )

set( LINUX_PACKAGE_SHORTNAME "leviia" )

set( NEXTCLOUD_BACKGROUND_COLOR "#00bc73" )

message("Branding: ${BRANDING_VALUE}")
string(COMPARE NOTEQUAL "${BRANDING_VALUE}" "default" __cmp)
if(__cmp)
    message("Custom branding")
    include(${CMAKE_SOURCE_DIR}/brandings/${BRANDING_VALUE}.cmake)
    set( APPLICATION_ICON_NAME "${APPLICATION_SHORTNAME}" )
    set( APPLICATION_EXECUTABLE "${APPLICATION_SHORTNAME}" )
    set( APPLICATION_VIRTUALFILE_SUFFIX "${APPLICATION_SHORTNAME}" )
    set( LINUX_PACKAGE_SHORTNAME "${APPLICATION_SHORTNAME}" )

    configure_file(${CMAKE_SOURCE_DIR}/theme/leviia.VisualElementsManifest.xml.in ${CMAKE_SOURCE_DIR}/theme/${APPLICATION_EXECUTABLE}.VisualElementsManifest.xml)
    configure_file(${CMAKE_SOURCE_DIR}/brandings/${BRANDING_VALUE}/Leviia-icon.svg ${CMAKE_SOURCE_DIR}/theme/colored/${APPLICATION_ICON_NAME}-icon.svg)
    configure_file(${CMAKE_SOURCE_DIR}/brandings/${BRANDING_VALUE}/Leviia-sidebar.svg ${CMAKE_SOURCE_DIR}/theme/colored/${APPLICATION_ICON_NAME}-sidebar.svg)
    configure_file(${CMAKE_SOURCE_DIR}/brandings/${BRANDING_VALUE}/Leviia-w10startmenu.svg ${CMAKE_SOURCE_DIR}/theme/colored/${APPLICATION_ICON_NAME}-w10startmenu.svg)
else()
    set(BRANDING_VALUE "default")
endif()

set( LINUX_APPLICATION_ID "${APPLICATION_REV_DOMAIN}.${LINUX_PACKAGE_SHORTNAME}")

file(COPY ${CMAKE_SOURCE_DIR}/brandings/${BRANDING_VALUE}/banner.bmp DESTINATION ${CMAKE_SOURCE_DIR}/admin/win/msi/gui/)
file(COPY ${CMAKE_SOURCE_DIR}/brandings/${BRANDING_VALUE}/dialog.bmp DESTINATION ${CMAKE_SOURCE_DIR}/admin/win/msi/gui/)
file(COPY ${CMAKE_SOURCE_DIR}/brandings/${BRANDING_VALUE}/installer-background.svg DESTINATION ${CMAKE_SOURCE_DIR}/admin/osx/)
configure_file(${CMAKE_SOURCE_DIR}/brandings/${BRANDING_VALUE}/state-offline.svg ${CMAKE_SOURCE_DIR}/theme/colored/state-offline.svg)
configure_file(${CMAKE_SOURCE_DIR}/brandings/${BRANDING_VALUE}/wizard_logo.svg ${CMAKE_SOURCE_DIR}/theme/colored/wizard_logo.svg)
configure_file(${CMAKE_SOURCE_DIR}/brandings/${BRANDING_VALUE}/wizard-nextcloud.svg ${CMAKE_SOURCE_DIR}/theme/colored/wizard-nextcloud.svg)
configure_file(${CMAKE_SOURCE_DIR}/brandings/${BRANDING_VALUE}/Leviia-icon-win-folder.svg ${CMAKE_SOURCE_DIR}/theme/colored/icons/${APPLICATION_ICON_NAME}-icon-win-folder.svg)

message("NEXTCLOUD_BACKGROUND_COLOR")
message("${NEXTCLOUD_BACKGROUND_COLOR}")
configure_file(${CMAKE_SOURCE_DIR}/theme/colored/external.svg.in ${CMAKE_SOURCE_DIR}/theme/colored/external.svg)
configure_file(${CMAKE_SOURCE_DIR}/theme/colored/folder.svg.in ${CMAKE_SOURCE_DIR}/theme/colored/folder.svg)
configure_file(${CMAKE_SOURCE_DIR}/theme/colored/wizard-files.svg.in ${CMAKE_SOURCE_DIR}/theme/colored/wizard-files.svg)
configure_file(${CMAKE_SOURCE_DIR}/theme/colored/wizard-groupware.svg.in ${CMAKE_SOURCE_DIR}/theme/colored/wizard-groupware.svg)
configure_file(${CMAKE_SOURCE_DIR}/theme/colored/wizard-talk.svg.in ${CMAKE_SOURCE_DIR}/theme/colored/wizard-talk.svg)

set( THEME_CLASS            "NextcloudTheme" )
set( WIN_SETUP_BITMAP_PATH  "${CMAKE_SOURCE_DIR}/admin/win/nsi" )

set( MAC_INSTALLER_BACKGROUND_FILE "${CMAKE_SOURCE_DIR}/admin/osx/installer-background.png" CACHE STRING "The MacOSX installer background image")

# set( THEME_INCLUDE          "${OEM_THEME_DIR}/mytheme.h" )
# set( APPLICATION_LICENSE    "${OEM_THEME_DIR}/license.txt )

option( WITH_CRASHREPORTER "Build crashreporter" OFF )
#set( CRASHREPORTER_SUBMIT_URL "https://crash-reports.owncloud.com/submit" CACHE STRING "URL for crash reporter" )
#set( CRASHREPORTER_ICON ":/owncloud-icon.png" )

## Updater options
option( BUILD_UPDATER "Build updater" ON )

option( WITH_PROVIDERS "Build with providers list" ON )


## Theming options
set( APPLICATION_WIZARD_HEADER_BACKGROUND_COLOR ${NEXTCLOUD_BACKGROUND_COLOR} )
set( APPLICATION_WIZARD_HEADER_TITLE_COLOR "#ffffff" )
option( APPLICATION_WIZARD_USE_CUSTOM_LOGO "Use the logo from ':/client/theme/colored/wizard_logo.(png|svg)' else the default application icon is used" ON )


#
## Windows Shell Extensions & MSI - IMPORTANT: Generate new GUIDs for custom builds with "guidgen" or "uuidgen"
#
if(WIN32)
    # Context Menu
    set( WIN_SHELLEXT_CONTEXT_MENU_GUID      "{BC6988AB-ACE2-4B81-84DC-DC34F9B24401}" )

    # Overlays
    set( WIN_SHELLEXT_OVERLAY_GUID_ERROR     "{E0342B74-7593-4C70-9D61-22F294AAFE05}" )
    set( WIN_SHELLEXT_OVERLAY_GUID_OK        "{E1094E94-BE93-4EA2-9639-8475C68F3886}" )
    set( WIN_SHELLEXT_OVERLAY_GUID_OK_SHARED "{E243AD85-F71B-496B-B17E-B8091CBE93D2}" )
    set( WIN_SHELLEXT_OVERLAY_GUID_SYNC      "{E3D6DB20-1D83-4829-B5C9-941B31C0C35A}" )
    set( WIN_SHELLEXT_OVERLAY_GUID_WARNING   "{E4977F33-F93A-4A0A-9D3C-83DEA0EE8483}" )

    # MSI Upgrade Code (without brackets)
    set( WIN_MSI_UPGRADE_CODE                "FD2FCCA9-BB8F-4485-8F70-A0621B84A7F4" )

    # Windows build options
    option( BUILD_WIN_MSI "Build MSI scripts and helper DLL" OFF )
    option( BUILD_WIN_TOOLS "Build Win32 migration tools" OFF )
endif()
