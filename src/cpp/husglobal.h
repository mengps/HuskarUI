#ifndef HUSGLOBAL_H
#define HUSGLOBAL_H

#if !defined(BUILD_HUSKARUI_STATIC_LIBRARY)
#  if defined(BUILD_HUSKARUI_LIB)
#    define HUSKARUI_EXPORT Q_DECL_EXPORT
#  else
#    define HUSKARUI_EXPORT Q_DECL_IMPORT
#  endif
#else
#  define HUSKARUI_EXPORT
#endif

#endif // HUSGLOBAL_H
