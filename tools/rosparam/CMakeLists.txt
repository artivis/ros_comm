cmake_minimum_required(VERSION 2.8.3)
project(rosparam)
find_package(catkin REQUIRED)
catkin_package(CFG_EXTRAS rosparam-extras.cmake)

catkin_python_setup()

# required for old rosbuild macro to be under PKGNAME/scripts
catkin_install_python(PROGRAMS scripts/rosparam-check
  DESTINATION ${CATKIN_PACKAGE_SHARE_DESTINATION}/scripts)
