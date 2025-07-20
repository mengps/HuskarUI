#[[
    Get all files in the directory that match the filter.

    hus_get_dir_sources(
        [FILTER         filter]
        [OUTPUT         outputvar]
    )
]] #

function(hus_get_dir_sources)
    set(oneValueArgs OUTPUT)
    set(multiValueArgs FILTER)
    cmake_parse_arguments(PARAM "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    file(GLOB_RECURSE PATHS ${PARAM_FILTER})
    set(TEMP_OUTPUT "")
    foreach (filepath ${PATHS})
        string(REPLACE "${CMAKE_CURRENT_SOURCE_DIR}/" "" filename ${filepath})
        list(APPEND TEMP_OUTPUT ${filename})
    endforeach (filepath)
    set(${PARAM_OUTPUT} ${TEMP_OUTPUT} PARENT_SCOPE)
endfunction()

#[[
    Attach windows RC file to a target.

    hus_add_win_rc(<target>
        [COMMENTS       comments]
        [NAME           name]
        [VERSION        version]
        [COMPANY        company]
        [DESCRIPTION    desc]
        [COPYRIGHT      copyright]
        [TRADEMARK      trademark]
        [ICONS          icons]
        [OUTPUT_FILE    file]
    )
]] #

function(hus_add_win_rc _target)
    if(NOT WIN32)
        return()
    endif()

    set(options)
    set(oneValueArgs COMMENTS NAME VERSION COMPANY DESCRIPTION COPYRIGHT TRADEMARK OUTPUT_FILE)
    set(multiValueArgs ICONS)
    cmake_parse_arguments(PARAM "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})

    set(_comments ${PARAM_COMMENTS})
    set(_name ${PARAM_NAME})
    set(_version ${PARAM_VERSION})
    set(_company ${PARAM_COMPANY})
    set(_desc ${PARAM_DESCRIPTION})
    set(_copyright ${PARAM_COPYRIGHT})
    set(_trademark ${PARAM_TRADEMARK})
    set(_out_file ${PARAM_OUTPUT_FILE})

    #Parse version string
    string(REPLACE "." ";" _version_list ${_version})
    list(LENGTH _version_list _version_count)
    list(PREPEND _version_list 0) # Add placeholder
    foreach(_i RANGE 1 4)
        if(_i LESS_EQUAL _version_count)
            list(GET _version_list ${_i} _item)
        else()
            set(_item 0)
        endif()

        set(_ver_${_i} ${_item})
    endforeach()
    set(RC_VERSION ${_ver_1},${_ver_2},${_ver_3},${_ver_4})
    set(RC_VERSION_STRING ${_ver_1}.${_ver_2}.${_ver_3}.${_ver_4})

    #Parse file type
    GET_FILENAME_COMPONENT(_file_ext ${_name} EXT)
    if (_file_ext STREQUAL ".exe")
        set(RC_FILE_TYPE VFT_APP)
    elseif (_file_ext STREQUAL ".dll")
        set(RC_FILE_TYPE VFT_DLL)
    elseif (_file_ext STREQUAL ".lib")
        set(RC_FILE_TYPE VFT_STATIC_LIB)
    else()
        set(RC_FILE_TYPE VFT_UNKNOWN)
    endif()

    set(RC_COMMENTS ${_comments})
    set(RC_COMPANY ${_company})
    set(RC_DESCRIPTION ${_desc})
    set(RC_COPYRIGHT ${_copyright})
    set(RC_TRADEMARK ${_trademark})
    set(RC_FILENAME ${_name})
    set(RC_PROJECT_NAME ${_target})

    set(_icons)

    if(PARAM_ICONS)
        set(_index 1)

        foreach(_icon IN LISTS PARAM_ICONS)
            get_filename_component(_icon_path ${_icon} ABSOLUTE)
            string(APPEND _icons "IDI_ICON${_index}    ICON    \"${_icon_path}\"\n")
            math(EXPR _index "${_index} +1")
        endforeach()
    endif()

    set(RC_ICONS ${_icons})

    configure_file("${CMAKE_CURRENT_FUNCTION_LIST_DIR}/WinResource.rc.in" ${_out_file})

    foreach(_icon IN LISTS PARAM_ICONS)
        if(${_icon} IS_NEWER_THAN ${_out_file})
            file(TOUCH_NOCREATE ${_out_file})
            break()
        endif()
    endforeach()
endfunction()
