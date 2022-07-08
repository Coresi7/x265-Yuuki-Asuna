include(FindPackageHandleStandardArgs)

if(WIN32)
    GET_FILENAME_COMPONENT(AVIS_FOLDER "[HKEY_LOCAL_MACHINE\\SOFTWARE\\AviSynth]" ABSOLUTE CACHE)
    SET(AVIS_INCLUDE_DIR "${AVIS_FOLDER}/FilterSDK/include")
else()
    find_path(AVIS_FOLDER NAMES avisynth PATHS usr PATH_SUFFIXES include)
endif()

if(AVIS_FOLDER)
    SET(ENABLE_AVISYNTH ON)
else()
    SET(ENABLE_AVISYNTH OFF)
endif()

# Provide standardized success/failure messages
find_package_handle_standard_args(AVISYNTH
    REQUIRED_VARS AVIS_INCLUDE_DIR ENABLE_AVISYNTH)
