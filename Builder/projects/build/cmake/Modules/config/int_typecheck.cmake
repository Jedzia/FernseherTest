CMAKE_MINIMUM_REQUIRED(VERSION 2.6.3 FATAL_ERROR)

INCLUDE(CheckCSourceCompiles)
INCLUDE(CheckCSourceRuns)
#INCLUDE(CheckFileOffsetBits)
#INCLUDE(CheckFuncs)
INCLUDE(CheckFunctionExists)
#INCLUDE(CheckHeaderDirent)
INCLUDE(CheckIncludeFile)
INCLUDE(CheckIncludeFiles)
INCLUDE(CheckLibraryExists)
#INCLUDE(CheckStructMember)
INCLUDE(CheckSymbolExists)
#INCLUDE(CheckTypeExists)
INCLUDE(CheckTypeSize)

# Missing stuff in cmake-2158a9b.tar.gz

#
# Check for integer types
#
# XXX There must be a way to make this simpler <sigh> XXXX
#
CHECK_TYPE_SIZE("long long int"            LONG_LONG_INT)
CHECK_TYPE_SIZE("unsigned long long"       UNSIGNED_LONG_LONG)
CHECK_TYPE_SIZE("unsigned long long int"   UNSIGNED_LONG_LONG_INT)

#
CHECK_TYPE_SIZE(dev_t       DEV_T)
IF(NOT HAVE_DEV_T)
  SET(dev_t "unsigned int")
ENDIF(NOT HAVE_DEV_T)
#
CHECK_TYPE_SIZE(gid_t       GID_T)
IF(NOT HAVE_GID_T)
  IF(WIN32)
    SET(gid_t "short")
  ELSE(WIN32)
    SET(gid_t "unsigned int")
  ENDIF(WIN32)
ENDIF(NOT HAVE_GID_T)
#
CHECK_TYPE_SIZE(id_t        ID_T)
IF(NOT HAVE_ID_T)
  IF(WIN32)
    SET(id_t "short")
  ELSE(WIN32)
    SET(id_t "unsigned int")
  ENDIF(WIN32)
ENDIF(NOT HAVE_ID_T)
#
CHECK_TYPE_SIZE(int64_t     INT64_T)
IF(NOT HAVE_INT64_T)
  IF(WIN32)
    SET(int64_t "__int64")
  ELSE(WIN32)
    SET(int64_t "long long")
  ENDIF(WIN32)
ENDIF(NOT HAVE_INT64_T)
#
CHECK_TYPE_SIZE(intmax_t    INTMAX_T)
IF(NOT HAVE_INTMAX_T)
  SET(intmax_t "int64_t")
ENDIF(NOT HAVE_INTMAX_T)
#
CHECK_TYPE_SIZE(mode_t      MODE_T)
IF(NOT HAVE_MODE_T)
  IF(WIN32)
    SET(mode_t "unsigned short")
  ELSE(WIN32)
    SET(mode_t "int")
  ENDIF(WIN32)
ENDIF(NOT HAVE_MODE_T)
#
CHECK_TYPE_SIZE(off_t       OFF_T)
IF(NOT HAVE_OFF_T)
  SET(off_t "__int64")
ENDIF(NOT HAVE_OFF_T)
#
CHECK_TYPE_SIZE(size_t      SIZE_T)
IF(NOT HAVE_SIZE_T)
  IF("${CMAKE_SIZEOF_VOID_P}" EQUAL 8)
    SET(size_t "uint64_t")
  ELSE("${CMAKE_SIZEOF_VOID_P}" EQUAL 8)
    SET(size_t   "uint32_t")
  ENDIF("${CMAKE_SIZEOF_VOID_P}" EQUAL 8)
ENDIF(NOT HAVE_SIZE_T)
#
CHECK_TYPE_SIZE(ssize_t     SSIZE_T)
IF(NOT HAVE_SSIZE_T)
  IF("${CMAKE_SIZEOF_VOID_P}" EQUAL 8)
    SET(ssize_t "int64_t")
  ELSE("${CMAKE_SIZEOF_VOID_P}" EQUAL 8)
    SET(ssize_t "long")
  ENDIF("${CMAKE_SIZEOF_VOID_P}" EQUAL 8)
ENDIF(NOT HAVE_SSIZE_T)
#
CHECK_TYPE_SIZE(uid_t       UID_T)
IF(NOT HAVE_UID_T)
  IF(WIN32)
    SET(uid_t "short")
  ELSE(WIN32)
    SET(uid_t "unsigned int")
  ENDIF(WIN32)
ENDIF(NOT HAVE_UID_T)
#
CHECK_TYPE_SIZE(uint16_t    UINT16_T)
IF(NOT HAVE_UINT16_T)
  SET(uint16_t "unsigned short")
ENDIF(NOT HAVE_UINT16_T)
#
CHECK_TYPE_SIZE(uint32_t    UINT32_T)
IF(NOT HAVE_UINT32_T)
  SET(uint32_t "unsigned int")
ENDIF(NOT HAVE_UINT32_T)
CHECK_TYPE_SIZE(int32_t    INT32_T)
IF(NOT HAVE_INT32_T)
  SET(int32_t "int")
ENDIF(NOT HAVE_INT32_T)
#
CHECK_TYPE_SIZE(uint64_t    UINT64_T)
IF(NOT HAVE_UINT64_T)
  IF(WIN32)
    SET(uint64_t "unsigned __int64")
  ELSE(WIN32)
    SET(uint64_t "unsigned long long")
  ENDIF(WIN32)
ENDIF(NOT HAVE_UINT64_T)
#
CHECK_TYPE_SIZE(uintmax_t   UINTMAX_T)
IF(NOT HAVE_UINTMAX_T)
  SET(uintmax_t "uint64_t")
ENDIF(NOT HAVE_UINTMAX_T)
#
CHECK_TYPE_SIZE(intptr_t   INTPTR_T)
IF(NOT HAVE_INTPTR_T)
  IF("${CMAKE_SIZEOF_VOID_P}" EQUAL 8)
    SET(intptr_t "int64_t")
  ELSE()
    SET(intptr_t "int32_t")
  ENDIF()
ENDIF(NOT HAVE_INTPTR_T)
#
CHECK_TYPE_SIZE(uintptr_t   UINTPTR_T)
IF(NOT HAVE_UINTPTR_T)
  IF("${CMAKE_SIZEOF_VOID_P}" EQUAL 8)
    SET(uintptr_t "uint64_t")
  ELSE()
    SET(uintptr_t "uint32_t")
  ENDIF()
ENDIF(NOT HAVE_UINTPTR_T)
#
CHECK_TYPE_SIZE(wchar_t     SIZEOF_WCHAR_T)
IF(HAVE_SIZEOF_WCHAR_T)
  SET(HAVE_WCHAR_T 1)
ENDIF(HAVE_SIZEOF_WCHAR_T)
#
# Check if _FILE_OFFSET_BITS macro needed for large files
#
#CHECK_FILE_OFFSET_BITS()
