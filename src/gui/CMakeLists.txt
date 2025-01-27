project(gui)
find_package(Qt5 REQUIRED COMPONENTS Widgets Svg Qml Quick QuickControls2 Xml Network)

if(QUICK_COMPILER)
        find_package(Qt5QuickCompiler)
        set_package_properties(Qt5QuickCompiler PROPERTIES
                DESCRIPTION "Compile QML at build time"
                TYPE REQUIRED
        )
endif()

if (NOT TARGET Qt5::GuiPrivate)
    message(FATAL_ERROR "Could not find GuiPrivate component of Qt5. It might be shipped as a separate package, please check that.")
endif()

if(CMAKE_BUILD_TYPE MATCHES Debug)
    add_definitions(-DQT_QML_DEBUG)
endif()

IF(BUILD_UPDATER)
    add_subdirectory(updater)
endif()

configure_file(${CMAKE_SOURCE_DIR}/theme.qrc.in ${CMAKE_SOURCE_DIR}/theme.qrc)
set(theme_dir ${CMAKE_SOURCE_DIR}/theme)
set(admin_osx_dir ${CMAKE_SOURCE_DIR}/admin/osx)
set(admin_win_dir ${CMAKE_SOURCE_DIR}/admin/win)

set(client_UI_SRCS
    accountsettings.ui
    conflictdialog.ui
    invalidfilenamedialog.ui
    foldercreationdialog.ui
    folderwizardsourcepage.ui
    folderwizardtargetpage.ui
    generalsettings.ui
    legalnotice.ui
    ignorelisteditor.ui
    ignorelisttablewidget.ui
    networksettings.ui
    settingsdialog.ui
    sharedialog.ui
    sharelinkwidget.ui
    shareusergroupwidget.ui
    shareuserline.ui
    sslerrordialog.ui
    addcertificatedialog.ui
    passwordinputdialog.ui
    proxyauthdialog.ui
    mnemonicdialog.ui
    wizard/flow2authwidget.ui
    wizard/owncloudadvancedsetuppage.ui
    wizard/owncloudconnectionmethoddialog.ui
    wizard/owncloudhttpcredspage.ui
    wizard/owncloudoauthcredspage.ui
    wizard/owncloudsetupnocredspage.ui
    wizard/webview.ui
    wizard/welcomepage.ui
)

if(QUICK_COMPILER)
    qtquick_compiler_add_resources(client_UI_SRCS ../../resources.qrc ${CMAKE_SOURCE_DIR}/theme.qrc)
else()
    qt_add_resources(client_UI_SRCS ../../resources.qrc ${CMAKE_SOURCE_DIR}/theme.qrc)
endif()

set(client_SRCS
    accountmanager.cpp
    accountsettings.cpp
    application.cpp
    invalidfilenamedialog.cpp
    conflictdialog.cpp
    conflictsolver.cpp
    connectionvalidator.cpp
    folder.cpp
    foldercreationdialog.cpp
    folderman.cpp
    folderstatusmodel.cpp
    folderstatusdelegate.cpp
    folderstatusview.cpp
    folderwatcher.cpp
    folderwizard.cpp
    generalsettings.cpp
    legalnotice.cpp
    ignorelisteditor.cpp
    ignorelisttablewidget.cpp
    lockwatcher.cpp
    logbrowser.cpp
    navigationpanehelper.cpp
    networksettings.cpp
    ocsnavigationappsjob.cpp
    ocsjob.cpp
    ocssharejob.cpp
    ocsshareejob.cpp
    openfilemanager.cpp
    owncloudgui.cpp
    owncloudsetupwizard.cpp
    passwordinputdialog.cpp
    selectivesyncdialog.cpp
    settingsdialog.cpp
    sharedialog.cpp
    sharelinkwidget.cpp
    sharemanager.cpp
    shareusergroupwidget.cpp
    profilepagewidget.cpp
    sharee.cpp
    sslbutton.cpp
    sslerrordialog.cpp
    syncrunfilelog.cpp
    systray.cpp
    thumbnailjob.cpp
    userinfo.cpp
    accountstate.cpp
    addcertificatedialog.cpp
    authenticationdialog.cpp
    proxyauthhandler.cpp
    proxyauthdialog.cpp
    tooltipupdater.cpp
    notificationconfirmjob.cpp
    guiutility.cpp
    elidedlabel.cpp
    headerbanner.cpp
    iconutils.cpp
    remotewipe.cpp
    userstatusselectormodel.cpp
    emojimodel.cpp
    fileactivitylistmodel.cpp
    tray/svgimageprovider.cpp
    tray/syncstatussummary.cpp
    tray/activitydata.cpp
    tray/activitylistmodel.cpp
    tray/unifiedsearchresult.cpp
    tray/unifiedsearchresultimageprovider.cpp
    tray/unifiedsearchresultslistmodel.cpp
    tray/usermodel.cpp
    tray/notificationhandler.cpp
    tray/notificationcache.cpp
    creds/credentialsfactory.cpp
    creds/httpcredentialsgui.cpp
    creds/oauth.cpp
    creds/flow2auth.cpp
    creds/webflowcredentials.cpp
    creds/webflowcredentialsdialog.cpp
    wizard/postfixlineedit.cpp
    wizard/abstractcredswizardpage.cpp
    wizard/owncloudadvancedsetuppage.cpp
    wizard/owncloudconnectionmethoddialog.cpp
    wizard/owncloudhttpcredspage.cpp
    wizard/owncloudoauthcredspage.cpp
    wizard/flow2authcredspage.cpp
    wizard/flow2authwidget.cpp
    wizard/owncloudsetuppage.cpp
    wizard/owncloudwizardcommon.cpp
    wizard/owncloudwizard.cpp
    wizard/slideshow.cpp
    wizard/welcomepage.cpp
    wizard/linklabel.cpp
    )

if (Qt5WebEngine_FOUND AND Qt5WebEngineWidgets_FOUND)
  list(APPEND client_SRCS
    wizard/webviewpage.cpp
    wizard/webview.cpp
  )
endif()

IF(BUILD_UPDATER)
    set(updater_SRCS
        updater/ocupdater.cpp
        updater/updateinfo.cpp
        updater/updater.cpp
    )
endif()

IF( APPLE )
    list(APPEND client_SRCS cocoainitializer_mac.mm)
    list(APPEND client_SRCS systray.mm)

    if(SPARKLE_FOUND AND BUILD_UPDATER)
        # Define this, we need to check in updater.cpp
        add_definitions(-DHAVE_SPARKLE)
        list(APPEND updater_SRCS updater/sparkleupdater_mac.mm updater/sparkleupdater.h)
        list(APPEND updater_DEPS ${SPARKLE_LIBRARY})

        # Sparkle.framework is installed from here because macdeployqt's CopyFramework breaks on this bundle
        # as its logic is tightly tailored around Qt5 frameworks
        install(DIRECTORY "${SPARKLE_LIBRARY}"
                DESTINATION "${OWNCLOUD_OSX_BUNDLE}/Contents/Frameworks" USE_SOURCE_PERMISSIONS)

   endif()
ENDIF()

IF( NOT WIN32 AND NOT APPLE )
set(client_SRCS ${client_SRCS} folderwatcher_linux.cpp)
ENDIF()
IF( WIN32 )
set(client_SRCS ${client_SRCS} folderwatcher_win.cpp)
ENDIF()
IF( APPLE )
list(APPEND client_SRCS folderwatcher_mac.cpp)
ENDIF()

set(3rdparty_SRC
    ../3rdparty/QProgressIndicator/QProgressIndicator.cpp
    ../3rdparty/qtlockedfile/qtlockedfile.cpp
    ../3rdparty/qtsingleapplication/qtlocalpeer.cpp
    ../3rdparty/qtsingleapplication/qtsingleapplication.cpp
    ../3rdparty/qtsingleapplication/qtsinglecoreapplication.cpp
    ../3rdparty/kmessagewidget/kmessagewidget.cpp
    ../3rdparty/kirigami/wheelhandler.cpp
   )

if(NOT WIN32)
   list(APPEND 3rdparty_SRC ../3rdparty/qtlockedfile/qtlockedfile_unix.cpp)
else()
   list(APPEND 3rdparty_SRC ../3rdparty/qtlockedfile/qtlockedfile_win.cpp )
endif()

find_package(Qt5LinguistTools)
if(Qt5LinguistTools_FOUND)
    qt5_add_translation(client_I18N ${TRANSLATIONS})
endif()

IF( WIN32 )
    configure_file(
      ${CMAKE_CURRENT_SOURCE_DIR}/version.rc.in
      ${CMAKE_CURRENT_BINARY_DIR}/version.rc
      @ONLY)
    set(client_version ${CMAKE_CURRENT_BINARY_DIR}/version.rc)
    IF(NOT MSVC)
        set(client_manifest ${CMAKE_CURRENT_SOURCE_DIR}/manifest-mingw.rc)
    ENDIF()
ENDIF()

set( final_src
    ${client_SRCS}
    ${client_UI_SRCS}
    ${guiMoc}
    ${client_I18N}
    ${3rdparty_SRC}
    ${3rdparty_MOC}
)

if(Qt5Keychain_FOUND)
    list(APPEND libsync_LINK_TARGETS qt5keychain)
endif()

# add executable icon on windows and osx

# UPSTREAM our ECMAddAppIcon.cmake then require that version here
# find_package(ECM 1.7.0 REQUIRED NO_MODULE)
# list(APPEND CMAKE_MODULE_PATH ${ECM_MODULE_PATH})
include(ECMAddAppIcon)

# For historical reasons we can not use the application_shortname
# for ownCloud but must rather set it manually.
if (NOT DEFINED APPLICATION_ICON_NAME)
    set(APPLICATION_ICON_NAME ${APPLICATION_SHORTNAME})
endif()

if(NOT DEFINED APPLICATION_FOLDER_ICON_INDEX)
    set(APPLICATION_FOLDER_ICON_INDEX 0)
endif()

# Generate png icons from svg
find_program(SVG_CONVERTER
  NAMES inkscape inkscape.exe rsvg-convert
  REQUIRED
  HINTS "C:\\Program Files\\Inkscape\\bin" "/usr/bin" ENV SVG_CONVERTER_DIR)
# REQUIRED keyword is only supported on CMake 3.18 and above
if (NOT SVG_CONVERTER)
  message(FATAL_ERROR "Could not find a suitable svg converter. Set SVG_CONVERTER_DIR to the path of either the inkscape or rsvg-convert executable.")
endif()

function(generate_sized_png_from_svg icon_path size)
  set(options)
  set(oneValueArgs OUTPUT_ICON_NAME OUTPUT_ICON_PATH)
  set(multiValueArgs)

  cmake_parse_arguments(ARG "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

  get_filename_component(icon_name_dir ${icon_path} DIRECTORY)
  get_filename_component(icon_name_wle ${icon_path} NAME_WLE)

  if (ARG_OUTPUT_ICON_NAME)
    set(icon_name_wle ${ARG_OUTPUT_ICON_NAME})
  endif ()

  if (ARG_OUTPUT_ICON_PATH)
    set(icon_name_dir ${ARG_OUTPUT_ICON_PATH})
  endif ()

  if (EXISTS "${icon_name_dir}/${size}-${icon_name_wle}.png")
    return()
  endif()

  set(icon_output_name "${size}-${icon_name_wle}.png")
  message(STATUS "Generate ${icon_output_name}")
  execute_process(COMMAND
    "${SVG_CONVERTER}" -w ${size} -h ${size} "${icon_path}" -o "${icon_output_name}"
    WORKING_DIRECTORY "${icon_name_dir}"
    RESULT_VARIABLE
    SVG_CONVERTER_SIDEBAR_ERROR
    OUTPUT_QUIET
    ERROR_QUIET)

  if (SVG_CONVERTER_SIDEBAR_ERROR)
    message(FATAL_ERROR
      "${SVG_CONVERTER} could not generate icon: ${SVG_CONVERTER_SIDEBAR_ERROR}")
  else()
  endif()
endfunction()

function(generate_sized_png_from_svg_v2 icon_path size)
  get_filename_component(icon_name_dir ${icon_path} DIRECTORY)
  get_filename_component(icon_name_wle ${icon_path} NAME_WLE)

  set(icon_output_name "${icon_name_wle}-${size}.png")
  message(STATUS "Generate ${icon_output_name}")
  execute_process(COMMAND
    "${SVG_CONVERTER}" -w ${size} -h ${size} "${icon_path}" -o "${icon_output_name}"
    WORKING_DIRECTORY "${icon_name_dir}"
    RESULT_VARIABLE
    SVG_CONVERTER_SIDEBAR_ERROR
    OUTPUT_QUIET
    ERROR_QUIET)

  if (SVG_CONVERTER_SIDEBAR_ERROR)
    message(FATAL_ERROR
      "${SVG_CONVERTER} could not generate icon: ${SVG_CONVERTER_SIDEBAR_ERROR}")
  else()
  endif()
endfunction()

function(generate_sized_png_from_svg_x icon_path w h factor)
  get_filename_component(icon_name_dir ${icon_path} DIRECTORY)
  get_filename_component(icon_name_wle ${icon_path} NAME_WLE)

  if(factor EQUAL 1)
    set(icon_output_name "${icon_name_wle}.png")
  else()
    set(icon_output_name "${icon_name_wle}_${factor}x.png")
  endif()

  math(EXPR WIDTH "${w}*${factor}")
  math(EXPR HEIGHT "${h}*${factor}")

  execute_process(COMMAND
    "${SVG_CONVERTER}" -w ${WIDTH} -h ${HEIGHT} "${icon_path}" -o "${icon_output_name}"
    WORKING_DIRECTORY "${icon_name_dir}"
    RESULT_VARIABLE
    SVG_CONVERTER_SIDEBAR_ERROR
    OUTPUT_QUIET
    ERROR_QUIET)

  if (SVG_CONVERTER_SIDEBAR_ERROR)
    message(FATAL_ERROR
      "${SVG_CONVERTER} could not generate icon: ${SVG_CONVERTER_SIDEBAR_ERROR}")
  else()
  endif()
endfunction()

function(generate_sized_png_from_svg_at_x icon_path w h factor)
  get_filename_component(icon_name_dir ${icon_path} DIRECTORY)
  get_filename_component(icon_name_wle ${icon_path} NAME_WLE)

  if(factor EQUAL 1)
    set(icon_output_name "${icon_name_wle}.png")
  else()
    set(icon_output_name "${icon_name_wle}@${factor}x.png")
  endif()

  math(EXPR WIDTH "${w}*${factor}")
  math(EXPR HEIGHT "${h}*${factor}")

  execute_process(COMMAND
    "${SVG_CONVERTER}" -w ${WIDTH} -h ${HEIGHT} "${icon_path}" -o "${icon_output_name}"
    WORKING_DIRECTORY "${icon_name_dir}"
    RESULT_VARIABLE
    SVG_CONVERTER_SIDEBAR_ERROR
    OUTPUT_QUIET
    ERROR_QUIET)

  if (SVG_CONVERTER_SIDEBAR_ERROR)
    message(FATAL_ERROR
      "${SVG_CONVERTER} could not generate icon: ${SVG_CONVERTER_SIDEBAR_ERROR}")
  else()
  endif()
endfunction()

if ((APPLICATION_ICON_SET MATCHES "PNG")
    AND
    (NOT EXISTS "${theme_dir}/colored/${APPLICATION_ICON_NAME}-icon.svg"))
  # We may have no svg application icon in when customers use PNG
  # icons in brander, but theme.qrc expects a svg icon.
  file(TOUCH "${theme_dir}/colored/${APPLICATION_ICON_NAME}-icon.svg")
endif()

if(APPLE)
  set(MACOS_SIDEBAR_ICON_SVG "${theme_dir}/colored/${APPLICATION_ICON_NAME}-sidebar.svg")
  generate_sized_png_from_svg(${MACOS_SIDEBAR_ICON_SVG} 16)
  generate_sized_png_from_svg(${MACOS_SIDEBAR_ICON_SVG} 32)
  generate_sized_png_from_svg(${MACOS_SIDEBAR_ICON_SVG} 64)
  generate_sized_png_from_svg(${MACOS_SIDEBAR_ICON_SVG} 128)
  generate_sized_png_from_svg(${MACOS_SIDEBAR_ICON_SVG} 256)
endif()

if(WIN32)
  set(STARTMENU_ICON_SVG "${theme_dir}/colored/${APPLICATION_ICON_NAME}-w10startmenu.svg")
  generate_sized_png_from_svg(${STARTMENU_ICON_SVG} 70)
  generate_sized_png_from_svg(${STARTMENU_ICON_SVG} 150)
endif()

set(APP_ICON_SVG "${theme_dir}/colored/${APPLICATION_ICON_NAME}-icon.svg")

# generate secondary icon if available (currently for Windows only)--------------------------------------
set(APP_SECONDARY_ICONS "${theme_dir}/colored/icons")
set(APP_ICON_WIN_FOLDER_SVG "${APP_SECONDARY_ICONS}/${APPLICATION_ICON_NAME}-icon-win-folder.svg")

set(RC_DEPENDENCIES "")

if(WIN32)
    if (EXISTS ${APP_ICON_WIN_FOLDER_SVG})
        get_filename_component(output_icon_name_win ${APP_ICON_WIN_FOLDER_SVG} NAME_WLE)
        # Product icon (for smallest size)
        foreach(size IN ITEMS 16;20)
            generate_sized_png_from_svg(${APP_ICON_SVG} ${size} OUTPUT_ICON_NAME ${output_icon_name_win} OUTPUT_ICON_PATH "${APP_SECONDARY_ICONS}/")
        endforeach()

        # Product icon with Windows folder (for sizes larger than 20)
        foreach(size IN ITEMS 24;32;40;48;64;128;256;512;1024)
            generate_sized_png_from_svg(${APP_ICON_WIN_FOLDER_SVG} ${size} OUTPUT_ICON_NAME ${output_icon_name_win} OUTPUT_ICON_PATH "${APP_SECONDARY_ICONS}/")
        endforeach()

        file(GLOB_RECURSE OWNCLOUD_ICONS_WIN_FOLDER "${APP_SECONDARY_ICONS}/*-${APPLICATION_ICON_NAME}-icon*")
        set(APP_ICON_WIN_FOLDER_ICO_NAME "${APPLICATION_ICON_NAME}-win-folder")
        set(RC_DEPENDENCIES "${RC_DEPENDENCIES} ${APP_ICON_WIN_FOLDER_ICO_NAME}.ico")
        ecm_add_app_icon(APP_ICON_WIN_FOLDER ICONS "${OWNCLOUD_ICONS_WIN_FOLDER}" SIDEBAR_ICONS "${OWNCLOUD_SIDEBAR_ICONS}" OUTFILE_BASENAME "${APP_ICON_WIN_FOLDER_ICO_NAME}" ICON_INDEX 2)
    endif()
endif()
# --------------------------------------

if (NOT ${RC_DEPENDENCIES} STREQUAL "")
    string(STRIP ${RC_DEPENDENCIES} RC_DEPENDENCIES)
endif()

# generate primary icon from SVG (due to Win .ico vs .rc dependency issues, primary icon must always be generated last)--------------------------------------
if(WIN32)
    foreach(size IN ITEMS 16;20;24;32;40;48;64;128;256;512;1024)
        generate_sized_png_from_svg(${APP_ICON_SVG} ${size})
    endforeach()
else()
    foreach(size IN ITEMS 16;24;32;48;64;128;256;512;1024)
        generate_sized_png_from_svg(${APP_ICON_SVG} ${size})
    endforeach()
endif()

list(APPEND V2_SVG_LIST
"${theme_dir}/colored/state-offline.svg"
)
foreach(V2_SVG IN LISTS V2_SVG_LIST)
generate_sized_png_from_svg_v2(${V2_SVG} 16)
generate_sized_png_from_svg_v2(${V2_SVG} 32)
generate_sized_png_from_svg_v2(${V2_SVG} 64)
generate_sized_png_from_svg_v2(${V2_SVG} 128)
generate_sized_png_from_svg_v2(${V2_SVG} 256)
endforeach()

list(APPEND X_SVG_LIST
"${theme_dir}/colored/external.svg"
"${theme_dir}/colored/folder.svg"
"${theme_dir}/colored/wizard_logo.svg"
"${theme_dir}/colored/wizard-files.svg"
"${theme_dir}/colored/wizard-groupware.svg"
"${theme_dir}/colored/wizard-nextcloud.svg"
"${theme_dir}/colored/wizard-talk.svg"
)
foreach(X_SVG IN LISTS X_SVG_LIST)
generate_sized_png_from_svg_at_x(${X_SVG} 100 100 1)
generate_sized_png_from_svg_at_x(${X_SVG} 100 100 2)
endforeach()

set(X_SVG "${admin_osx_dir}/installer-background.svg")
generate_sized_png_from_svg_x(${X_SVG} 320 200 1)
generate_sized_png_from_svg_x(${X_SVG} 320 200 2)

file(GLOB_RECURSE OWNCLOUD_ICONS "${theme_dir}/colored/*-${APPLICATION_ICON_NAME}-icon*")

if(APPLE)
    file(GLOB_RECURSE OWNCLOUD_SIDEBAR_ICONS "${theme_dir}/colored/*-${APPLICATION_ICON_NAME}-sidebar*")
    MESSAGE(STATUS "OWNCLOUD_SIDEBAR_ICONS: ${APPLICATION_ICON_NAME}: ${OWNCLOUD_SIDEBAR_ICONS}")
endif()

ecm_add_app_icon(APP_ICON RC_DEPENDENCIES ${RC_DEPENDENCIES} ICONS "${OWNCLOUD_ICONS}" SIDEBAR_ICONS "${OWNCLOUD_SIDEBAR_ICONS}" OUTFILE_BASENAME "${APPLICATION_ICON_NAME}" ICON_INDEX 1)
# --------------------------------------

if(WIN32)
# merge *.rc.in files for Windows (multiple ICON resources must be placed in a single file, otherwise, this won't work de to a bug in Windows compiler https://developercommunity.visualstudio.com/t/visual-studio-2017-prof-1557-cvt1100-duplicate-res/363156)
    function(merge_files IN_FILE OUT_FILE)
        file(READ ${IN_FILE} CONTENTS)
        message("Merging ${IN_FILE} into ${OUT_FILE}")
        file(APPEND ${OUT_FILE} "${CONTENTS}")
    endfunction()
    message("APP_ICON is: ${APP_ICON}")
    if(APP_ICON)
        get_filename_component(RC_IN_FOLDER ${APP_ICON}} DIRECTORY)

        file(GLOB_RECURSE RC_IN_FILES "${RC_IN_FOLDER}/*rc.in")

        foreach(rc_in_file IN ITEMS ${RC_IN_FILES})
          get_filename_component(rc_in_file_name ${rc_in_file} NAME)
          get_filename_component(app_icon_name "${APP_ICON}.in" NAME)
          if(NOT "${rc_in_file_name}" STREQUAL "${app_icon_name}")
              merge_files(${rc_in_file} "${APP_ICON}.in")
              if (DEFINED APPLICATION_FOLDER_ICON_INDEX)
                  MATH(EXPR APPLICATION_FOLDER_ICON_INDEX "${APPLICATION_FOLDER_ICON_INDEX}+1")
                  message("APPLICATION_FOLDER_ICON_INDEX is now set to: ${APPLICATION_FOLDER_ICON_INDEX}")
              endif()
          endif()
        endforeach()
    endif()
endif()
# --------------------------------------

if(UNIX AND NOT APPLE)
  set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -fPIE")
  set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -fPIE")
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -pie")
endif()

if(CMAKE_SYSTEM_NAME STREQUAL "FreeBSD")
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} -L/usr/local/lib")
endif()

add_library(nextcloudCore STATIC ${final_src})

target_link_libraries(nextcloudCore
  PUBLIC
  Qt5::Widgets
  Qt5::GuiPrivate
  Qt5::Svg
  Qt5::Network
  Qt5::Xml
  Qt5::Qml
  Qt5::Quick
  Qt5::QuickControls2
  ${synclib_NAME}
  )

add_subdirectory(socketapi)

if(Qt5WebEngine_FOUND AND Qt5WebEngineWidgets_FOUND)
  target_link_libraries(nextcloudCore PUBLIC Qt5::WebEngineWidgets)
endif()

set_target_properties(nextcloudCore
  PROPERTIES
  AUTOUIC ON
  AUTOMOC ON
)

target_include_directories(nextcloudCore
  PUBLIC
  ${CMAKE_SOURCE_DIR}/src/3rdparty/QProgressIndicator
  ${CMAKE_SOURCE_DIR}/src/3rdparty/qtlockedfile
  ${CMAKE_SOURCE_DIR}/src/3rdparty/kirigami
  ${CMAKE_SOURCE_DIR}/src/3rdparty/qtsingleapplication
  ${CMAKE_SOURCE_DIR}/src/3rdparty/kmessagewidget
  ${CMAKE_CURRENT_BINARY_DIR}
  ${CMAKE_CURRENT_SOURCE_DIR}
)

if(NOT BUILD_OWNCLOUD_OSX_BUNDLE)
    if(NOT WIN32)
        file(GLOB _icons "${theme_dir}/colored/*-${APPLICATION_ICON_NAME}-icon.png")
        foreach(_file ${_icons})
            string(REPLACE "${theme_dir}/colored/" "" _res ${_file})
            string(REPLACE "-${APPLICATION_ICON_NAME}-icon.png" "" _res ${_res})
            install(FILES ${_file} RENAME ${APPLICATION_ICON_NAME}.png DESTINATION ${CMAKE_INSTALL_DATADIR}/icons/hicolor/${_res}x${_res}/apps)
        endforeach(_file)
        install(FILES ${client_I18N} DESTINATION ${CMAKE_INSTALL_DATADIR}/${APPLICATION_EXECUTABLE}/i18n)
    else()
        file(GLOB_RECURSE VISUAL_ELEMENTS "${theme_dir}/colored/*-${APPLICATION_ICON_NAME}-w10startmenu*")
        install(FILES ${VISUAL_ELEMENTS} DESTINATION bin/visualelements)
        install(FILES "${theme_dir}/${APPLICATION_EXECUTABLE}.VisualElementsManifest.xml" DESTINATION bin)
        install(FILES ${client_I18N} DESTINATION i18n)
    endif()

    # we may not add MACOSX_BUNDLE here, if not building one
    add_executable(${APPLICATION_EXECUTABLE} WIN32 main.cpp ${client_version} ${client_manifest} ${APP_ICON})
else()
    # set(CMAKE_INSTALL_PREFIX ".") # Examples use /Applications. hurmpf.
    set(MACOSX_BUNDLE_ICON_FILE "${APPLICATION_ICON_NAME}.icns")

    # we must add MACOSX_BUNDLE only if building a bundle
    add_executable(${APPLICATION_EXECUTABLE} WIN32 MACOSX_BUNDLE main.cpp ${APP_ICON})

    if (BUILD_OWNCLOUD_OSX_BUNDLE)
      set_target_properties(${APPLICATION_EXECUTABLE} PROPERTIES
        OUTPUT_NAME "${APPLICATION_NAME}")
    endif()

    set (QM_DIR ${OWNCLOUD_OSX_BUNDLE}/Contents/Resources/Translations)
    install(FILES ${client_I18N} DESTINATION ${QM_DIR})
    get_target_property(_qmake Qt5::qmake LOCATION)
    execute_process(COMMAND ${_qmake} -query QT_INSTALL_TRANSLATIONS
        OUTPUT_VARIABLE QT_TRANSLATIONS_DIR
        OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    file(GLOB qt_I18N ${QT_TRANSLATIONS_DIR}/qt_??.qm ${QT_TRANSLATIONS_DIR}/qt_??_??.qm)
    install(FILES ${qt_I18N} DESTINATION ${QM_DIR})
    file(GLOB qtbase_I18N ${QT_TRANSLATIONS_DIR}/qtbase_??.qm ${QT_TRANSLATIONS_DIR}/qt_??_??.qm)
    install(FILES ${qtbase_I18N} DESTINATION ${QM_DIR})
    file(GLOB qtkeychain_I18N ${QT_TRANSLATIONS_DIR}/qtkeychain*.qm)
    install(FILES ${qtkeychain_I18N} DESTINATION ${QM_DIR})
endif()

IF(BUILD_UPDATER)
    add_library(updater STATIC ${updater_SRCS})
    target_link_libraries(updater ${synclib_NAME} ${updater_DEPS} Qt5::Widgets Qt5::Svg Qt5::Network Qt5::Xml)
    target_include_directories(updater PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
    set_target_properties(updater PROPERTIES AUTOMOC ON)
endif()

set_target_properties( ${APPLICATION_EXECUTABLE} PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY  ${BIN_OUTPUT_DIRECTORY}
)

target_link_libraries(${APPLICATION_EXECUTABLE} nextcloudCore)

IF(BUILD_UPDATER)
  target_link_libraries(nextcloudCore PUBLIC updater)
endif()

if(TARGET PkgConfig::CLOUDPROVIDERS)
    message("Building with libcloudproviderssupport")
    target_sources(nextcloudCore PRIVATE cloudproviders/cloudprovidermanager.cpp cloudproviders/cloudproviderwrapper.cpp)

    string(TOLOWER "${APPLICATION_VENDOR}" DBUS_VENDOR)
    string(REGEX REPLACE "[^A-z0-9]" "" DBUS_VENDOR "${DBUS_VENDOR}")
    string(REGEX REPLACE "[^A-z0-9]" "" DBUS_APPLICATION_NAME "${APPLICATION_SHORTNAME}")
    if(NOT DBUS_PREFIX)
        set(DBUS_PREFIX "com")
    endif(NOT DBUS_PREFIX)
    set(LIBCLOUDPROVIDERS_DBUS_BUS_NAME "${DBUS_PREFIX}.${DBUS_VENDOR}.${DBUS_APPLICATION_NAME}")
    set(LIBCLOUDPROVIDERS_DBUS_OBJECT_PATH "/${DBUS_PREFIX}/${DBUS_VENDOR}/${DBUS_APPLICATION_NAME}")

    configure_file(${CMAKE_CURRENT_SOURCE_DIR}/cloudproviders/cloudproviderconfig.h.in ${CMAKE_CURRENT_BINARY_DIR}/cloudproviderconfig.h)
    target_compile_definitions(nextcloudCore PUBLIC -DWITH_LIBCLOUDPROVIDERS)
    target_link_libraries(nextcloudCore
      PRIVATE
      PkgConfig::CLOUDPROVIDERS
      PkgConfig::GLIB2
      PkgConfig::GIO
    )
endif()

## handle DBUS for Fdo notifications
if( UNIX AND NOT APPLE )
    find_package(Qt5 COMPONENTS DBus)
    target_link_libraries(nextcloudCore PUBLIC Qt5::DBus)
    target_compile_definitions(nextcloudCore PUBLIC "USE_FDO_NOTIFICATIONS")
endif()

if (APPLE)
    find_package(Qt5 COMPONENTS MacExtras)
    target_link_libraries(nextcloudCore PUBLIC Qt5::MacExtras)
endif()

if(WITH_CRASHREPORTER)
    target_link_libraries(nextcloudCore PUBLIC crashreporter-handler)

    if(UNIX AND NOT MAC)
        find_package(Threads REQUIRED)
        target_link_libraries(nextcloudCore PUBLIC Threads::Threads)
    endif()
endif()

# application.cpp still uses QDesktopServices::storageLocation
target_compile_definitions(nextcloudCore PRIVATE "QT_DISABLE_DEPRECATED_BEFORE=0")


install(TARGETS ${APPLICATION_EXECUTABLE}
        RUNTIME DESTINATION bin
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
        BUNDLE  DESTINATION "."
 )


# FIXME: The following lines are dup in src/gui and src/cmd because it needs to be done after both are installed
#FIXME: find a nice solution to make the second if(BUILD_OWNCLOUD_OSX_BUNDLE) unnecessary
# currently it needs to be done because the code right above needs to be executed no matter
# if building a bundle or not and the install_qt4_executable needs to be called afterwards
#
# OSX: Run macdeployqt for src/gui and for src/cmd using the -executable option
if(BUILD_OWNCLOUD_OSX_BUNDLE AND NOT BUILD_LIBRARIES_ONLY)
    get_target_property (QT_QMAKE_EXECUTABLE Qt5::qmake IMPORTED_LOCATION)
    get_filename_component(QT_BIN_DIR "${QT_QMAKE_EXECUTABLE}" DIRECTORY)
    find_program(MACDEPLOYQT_EXECUTABLE macdeployqt HINTS "${QT_BIN_DIR}")

    set(cmd_NAME ${APPLICATION_EXECUTABLE}cmd)

    if(CMAKE_BUILD_TYPE MATCHES Debug)
        set(NO_STRIP "-no-strip")
    else()
        set(NO_STRIP "")
    endif()

    add_custom_command(TARGET ${APPLICATION_EXECUTABLE} POST_BUILD
        COMMAND "${MACDEPLOYQT_EXECUTABLE}"
        "$<TARGET_FILE_DIR:${APPLICATION_EXECUTABLE}>/../.."
        -qmldir=${CMAKE_SOURCE_DIR}/src/gui
        -always-overwrite
        -executable="$<TARGET_FILE_DIR:${APPLICATION_EXECUTABLE}>/${cmd_NAME}"
        ${NO_STRIP}
        COMMAND "${CMAKE_COMMAND}"
        -E rm -rf "${BIN_OUTPUT_DIRECTORY}/${OWNCLOUD_OSX_BUNDLE}/Contents/PlugIns/bearer"
        COMMENT "Running macdeployqt..."
    )
endif()

if(NOT BUILD_OWNCLOUD_OSX_BUNDLE AND NOT WIN32)
    configure_file(${CMAKE_SOURCE_DIR}/mirall.desktop.in
                   ${CMAKE_CURRENT_BINARY_DIR}/${LINUX_APPLICATION_ID}.desktop)
    install(FILES  ${CMAKE_CURRENT_BINARY_DIR}/${LINUX_APPLICATION_ID}.desktop DESTINATION ${CMAKE_INSTALL_DATADIR}/applications )

    configure_file(owncloud.xml.in ${APPLICATION_EXECUTABLE}.xml)
    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/${APPLICATION_EXECUTABLE}.xml DESTINATION ${CMAKE_INSTALL_DATADIR}/mime/packages )

    find_package(SharedMimeInfo)
    if(SharedMimeInfo_FOUND)
        update_xdg_mimetypes( ${CMAKE_INSTALL_DATADIR}/mime/packages )
    endif(SharedMimeInfo_FOUND)
endif()

configure_file(configgui.h.in ${CMAKE_CURRENT_BINARY_DIR}/configgui.h)
