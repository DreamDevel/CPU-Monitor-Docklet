
project (cpuinfo)
cmake_minimum_required (VERSION 2.6)
list (APPEND CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake)

set(GETTEXT_PACKAGE ${CMAKE_PROJECT_NAME})
add_definitions("-DGETTEXT_PACKAGE=\"${GETTEXT_PACKAGE}\"")
add_definitions("-w")

set (HOMEDIR $ENV{HOME})
set (HOME_DATADIR ${HOMEDIR}/.local/share/cpuinfo)
set (DATADIR "${CMAKE_INSTALL_PREFIX}/share")
set (PKGDATADIR "${DATADIR}/cpuinfo")
set (PKG_DATADIR ${PKGDATADIR})

set (EXEC_NAME "cpuinfo")
set (RELEASE_NAME "CPUInfo")
set (VERSION "1.0")

set (CONFIG_FILE ${CMAKE_CURRENT_SOURCE_DIR}/src/config.vala)
set (CONFIG_FILE_REL src/config.vala)
configure_file (${CMAKE_CURRENT_SOURCE_DIR}/src/config.vala.cmake ${CONFIG_FILE})

#include (GSettings)
#add_schema ("schemas/org.dreamdev.cpuinfo.gschema.xml")

find_package(PkgConfig)

set (PROJECT_DEPS
    gtk+-3.0
    granite
    unity
)

pkg_check_modules(DEPS REQUIRED ${PROJECT_DEPS})

add_definitions(${DEPS_CFLAGS})
link_libraries(${DEPS_LIBRARIES} sensors gtop-2.0)
link_directories(${DEPS_LIBRARY_DIRS})
include_directories(/usr/include/libgtop-2.0)

find_package(Vala REQUIRED)
include(ValaVersion)
ensure_vala_version("0.24" MINIMUM)
include(ValaPrecompile)

vala_precompile(VALA_C ${EXEC_NAME}
    ${CONFIG_FILE_REL}
    src/main.vala
#    src/app.vala

    src/Models/CPU.vala

    src/Core/SensorsEngine.vala

#    src/Core/Settings.vala

#    src/Core/WidgetManager.vala

#    src/UserInterface/Menus/ApplicationMenu.vala

#    src/UserInterface/Widgets/HeaderBar.vala

#    src/UserInterface/Windows/MainWindow.vala
CUSTOM_VAPIS
    vapis/libgtop-2.0.vapi
    vapis/sensors.vapi
PACKAGES
    ${PROJECT_DEPS}
    posix
OPTIONS
--enable-experimental
)

add_subdirectory (po)

add_executable(${EXEC_NAME} ${VALA_C})
install (TARGETS ${EXEC_NAME} RUNTIME DESTINATION bin)
install (FILES ${CMAKE_CURRENT_SOURCE_DIR}/data/CPUInfo.desktop DESTINATION ${DATADIR}/applications/)

set(SYSTEM_DEFAULT_THEME ${CMAKE_INSTALL_PREFIX}/share/icons/hicolor)
#install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/images/notify.png DESTINATION ${PKGDATADIR})
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/images/icons/16x16/apps/cpuinfo.png DESTINATION ${SYSTEM_DEFAULT_THEME}/16x16/apps)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/images/icons/24x24/apps/cpuinfo.png DESTINATION ${SYSTEM_DEFAULT_THEME}/24x24/apps)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/images/icons/32x32/apps/cpuinfo.png DESTINATION ${SYSTEM_DEFAULT_THEME}/32x32/apps)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/images/icons/48x48/apps/cpuinfo.png DESTINATION ${SYSTEM_DEFAULT_THEME}/48x48/apps)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/images/icons/128x128/apps/cpuinfo.png DESTINATION ${SYSTEM_DEFAULT_THEME}/128x128/apps)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/images/icons/256x256/apps/cpuinfo.png DESTINATION ${SYSTEM_DEFAULT_THEME}/256x256/apps)
install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/images/icons/512x512/apps/cpuinfo.png DESTINATION ${SYSTEM_DEFAULT_THEME}/512x512/apps)

install(CODE "execute_process(COMMAND \"gtk-update-icon-cache\" \"-f\" \"/usr/share/icons/hicolor/\")")
