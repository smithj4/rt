dnl
dnl @synopsis RT_LAYOUT(configlayout, layoutname)
dnl
dnl This macro reads an Apache-style layout file (specified as the
dnl configlayout parameter), and searches for a specific layout
dnl (named using the layoutname parameter).
dnl
dnl The entries for a given layout are then inserted into the
dnl environment such that they become available as substitution
dnl variables. In addition, the rt_layout_name variable is set
dnl (but not exported) if the layout is valid.
dnl
dnl This code is heavily borrowed *cough* from the Apache 2 codebase.
dnl

AC_DEFUN([RT_LAYOUT],[
	if test ! -f $srcdir/config.layout; then
		AC_MSG_WARN([Layout file $srcdir/config.layout not found])
		rt_layout_name=no
	else
		pldconf=./config.pld
		changequote({,})
		sed -e "1,/[  ]*<[lL]ayout[   ]*$2[   ]*>[    ]*/d" \
		    -e '/[    ]*<\/Layout>[   ]*/,$d' \
		    -e "s/^[  ]*//g" \
		    -e "s/:[  ]*/=\'/g" \
		    -e "s/[   ]*$/'/g" \
		    $1 > $pldconf
		changequote([,])
		if test -s $pldconf; then
			rt_layout_name=$2
			. $pldconf
			changequote({,})
			for var in prefix exec_prefix bindir sbindir \
				 sysconfdir mandir libdir datadir htmldir \
				 localstatedir logfiledir masonstatedir \
				 sessionstatedir customdir customhtmldir \
				 customlexdir; do
				eval "val=\"\$$var\""
				case $val in
				*+)
					val=`echo $val | sed -e 's;\+$;;'`
					eval "$var=\"\$val\""
					autosuffix=yes
					;;
				*)
					autosuffix=no
					;;
				esac
				val=`echo $val | sed -e 's:\(.\)/*$:\1:'`
				val=`echo $val | 
					sed -e 's:[\$]\([a-z_]*\):${\1}:g'`
				if test "$autosuffix" = "yes"; then
					if echo $val | grep rt3 >/dev/null; then
						addtarget=no
					else
						addtarget=yes
					fi
					if test "$addtarget" = "yes"; then
						val="$val/rt3"
					fi
				fi
				eval "$var='$val'"
			done
			changequote([,])
		else
			rt_layout_name=no
		fi
		rm $pldconf
	fi
	RT_SUBST_EXPANDED_ARG(prefix)
	RT_SUBST_EXPANDED_ARG(exec_prefix)
	RT_SUBST_EXPANDED_ARG(bindir)
	RT_SUBST_EXPANDED_ARG(sbindir)
	RT_SUBST_EXPANDED_ARG(sysconfdir)
	RT_SUBST_EXPANDED_ARG(mandir)
	RT_SUBST_EXPANDED_ARG(libdir)
	RT_SUBST_EXPANDED_ARG(datadir)
	RT_SUBST_EXPANDED_ARG(htmldir)
	RT_SUBST_EXPANDED_ARG(localstatedir)
	RT_SUBST_EXPANDED_ARG(logfiledir)
	RT_SUBST_EXPANDED_ARG(masonstatedir)
	RT_SUBST_EXPANDED_ARG(sessionstatedir)
	RT_SUBST_EXPANDED_ARG(customdir)
	RT_SUBST_EXPANDED_ARG(customhtmldir)
	RT_SUBST_EXPANDED_ARG(customlexdir)
])dnl
