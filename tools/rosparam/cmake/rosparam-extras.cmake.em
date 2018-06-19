# generated from ros_comm/tools/rosparam/cmake/rosparam-extras.cmake.em

@[if DEVELSPACE]@
# set path to roslaunch-check.py in develspace
set(rosparam_check_script @(CMAKE_CURRENT_SOURCE_DIR)/scripts/rosparam-check)
@[else]@
# set path to roslaunch-check.py installspace
set(rosparam_check_script @(CMAKE_INSTALL_PREFIX)/${CATKIN_PACKAGE_SHARE_DESTINATION}/scripts/rosparam-check)
@[end if]@

#
# Check ROS yaml files for validity as part of the unit tests.
#
# :param path: the path to a yaml file or a directory containing yaml files
#   either relative to th current CMakeLists file or absolute
# :type url: string
#
# :param ARGV: arbitrary arguments in the form 'key=value'
#   which will be set as environment variables
# :type ARGV: string
#
function(rosparam_add_file_check path)
  cmake_parse_arguments(_rosparam "USE_TEST_DEPENDENCIES" "" "DEPENDENCIES" ${ARGN})
  if(IS_ABSOLUTE ${path})
    set(abspath ${path})
  else()
    set(abspath "${CMAKE_CURRENT_SOURCE_DIR}/${path}")
  endif()
  if(NOT EXISTS ${abspath})
    message(FATAL_ERROR "rosparam_add_file_check() path '${abspath}' was not found")
  endif()

  # to support registering the same test with different ARGS
  # append the args to the test name
  if(_rosparam_UNPARSED_ARGUMENTS)
    get_filename_component(_ext ${testname} EXT)
    get_filename_component(testname ${testname} NAME_WE)
    foreach(arg ${_rosparam_UNPARSED_ARGUMENTS})
      string(REPLACE ":=" "_" arg_string "${arg}")
      string(REPLACE "=" "_" arg_string "${arg_string}")
      set(testname "${testname}__${arg_string}")
    endforeach()
    set(testname "${testname}${_ext}")
  endif()

  string(REPLACE "/" "_" testname ${path})
  set(output_path ${CATKIN_TEST_RESULTS_DIR}/${PROJECT_NAME})
  set(cmd "${CMAKE_COMMAND} -E make_directory ${output_path}")
  set(output_file_name "rosparam-check_${testname}.xml")
  string(REPLACE ";" " " _rosparam_UNPARSED_ARGUMENTS "${_rosparam_UNPARSED_ARGUMENTS}")
  set(cmd ${cmd} "${rosparam_check_script} -o '${output_path}/${output_file_name}' '${abspath}' ${_rosparam_UNPARSED_ARGUMENTS}")
  catkin_run_tests_target("rosparam-check" ${testname} "${output_file_name}" COMMAND ${cmd})
endfunction()
