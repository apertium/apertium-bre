AC_PREREQ(2.52)

AC_INIT([apertium-bre], [0.1.0], [francis.tyers@gmail.com])
AM_INIT_AUTOMAKE([apertium-bre], [0.1.0], no-define)
AC_PROG_LN_S
AC_PROG_AWK

dnl HFST support
AH_TEMPLATE(HAVE_HFSTOSPELL, [Have HFSTOSPELL])
AC_ARG_ENABLE(ospell, AC_HELP_STRING([--enable-ospell],
        [enable HFST spellchecking backend]),
        [hfstospell=${enableval}], [hfstospell=no])
dnl must be AS_IF for some aclocals to pick PKG_CHECK_MODULES somehow.
dnl AC_PROVIDE_IFELSE doesn't work on mac?
AS_IF([test x$hfstospell = xyes], [
      PKG_CHECK_MODULES([HFSTOSPELL], [hfstospell >= 0.2])
          AC_DEFINE(HAVE_HFSTOSPELL, 1)
          CXXFLAGS="$CXXFLAGS $HFSTOSPELL_CFLAGS"
        ])
AM_CONDITIONAL([HAVE_HFSTOSPELL], [test x$hfstospell = xyes])

PKG_CHECK_MODULES(APERTIUM, apertium >= 3.6.1)
PKG_CHECK_MODULES(HFST, hfst >= 3.15.1)
PKG_CHECK_MODULES(CG3, cg3 >= 1.3.1)

PKG_CHECK_MODULES(REGTEST, apertium-regtest >= 0.0.1, [],
                  [AC_MSG_WARN([Running tests requires apertium-regtest])])

AP_MKINCLUDE


AC_OUTPUT([Makefile apertium-bre.pc])
