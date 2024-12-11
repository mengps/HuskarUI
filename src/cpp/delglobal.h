#ifndef DELGLOBAL_H
#define DELGLOBAL_H

#if !defined(BUILD_DELEGATEUI_STATIC_LIBRARY)
#  if defined(BUILD_DELEGATEUI_LIB)
#    define DELEGATEUI_EXPORT Q_DECL_EXPORT
#  else
#    define DELEGATEUI_EXPORT Q_DECL_IMPORT
#  endif
#else
#  define DELEGATEUI_EXPORT
#endif

#endif // DELGLOBAL_H
