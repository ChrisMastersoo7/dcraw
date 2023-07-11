cmake_minimum_required(VERSION 3.10)

# set the project name
project(DCraw VERSION 9.28)

string(TIMESTAMP DEFAULT_BUILD "%Y%m%d")
set(BUILD ${DEFAULT_BUILD} CACHE STRING "Build string (default: ${DEFAULT_BUILD})")

message(STATUS "VERSION = ${PROJECT_VERSION}, BUILD = ${BUILD}")

if(WIN32)
	SET(ENV{CMAKE_GENERATOR} "Visual Studio 15 2017 Win64")
endif()

if(NOT CMAKE_BUILD_TYPE)
  set(CMAKE_BUILD_TYPE Release)
endif()

message(STATUS "CMAKE_BUILD_TYPE = ${CMAKE_BUILD_TYPE}")

option(BUILD_WITH_EXTERNAL_LIBS "Build DCRaw with all external libraries to have full functionality" ON)

# you can set the path also from cmd with cmake for example: cmake .. -DLIB<Name of library>_IDIR=../path_to_your_repo or define it as environment variables
if(BUILD_WITH_EXTERNAL_LIBS)
	message(STATUS "Building with external libs support")
	if (NOT WIN32)
		find_library(MATH_LIB m)
		if(NOT MATH_LIB)
  			message(FATAL_ERROR "math library not found")
		endif()
	endif()
	find_library(JASPER_LIB NAMES jasper HINTS "${LIBJASPER_IDIR}/jasper-version-4.0.0/bin/src/libjasper")
	if(NOT JASPER_LIB)
		#TODO find_path build from source...add_subdirectory
  		message(FATAL_ERROR "Jasper library not found")
	endif()
	find_library(JPEG_LIB NAMES jpeg HINTS "${LIBJPEG_IDIR}/libjpeg-turbo-3.0.0/build/Release")
	if(NOT JPEG_LIB)
  		message(FATAL_ERROR "JPEG library not found")
	endif()
	if (NOT WIN32)
		find_library(LCMS2_LIB lcms2)
		if(NOT LCMS2_LIB)
			message(FATAL_ERROR "LittleCMS library not found")
		endif()
	endif()

else()
	message(STATUS "Building without external libs support")
	message(WARNING "Building with limited functionality!")
	add_definitions(-D_NODPS)
endif()

# add the executable
add_executable(dcraw dcraw.c)

# link math library on unix systems
if (NOT WIN32)
	target_link_libraries(dcraw m jasper jpeg lcms2)
endif()