# RedBrick Putty

Is a pretty cool guy.


## Redbrick Buttons Patch

ask atlas/phaxx

### rbputty-0.58 patch

	
	diff -Nru 0.58-orig/CONFIG.C 0.58-phaxx/CONFIG.C
	--- 0.58-orig/CONFIG.C	2005-04-05 20:37:51.000000000 +0100
	+++ 0.58-phaxx/CONFIG.C	2007-01-26 17:34:18.000000000 +0000
	@@ -277,7 +277,7 @@

	 struct sessionsaver_data {
	     union control *editbox, *listbox, *loadbutton, *savebutton, *delbutton;
	-    union control *okbutton, *cancelbutton;
	+    union control *okbutton, *cancelbutton, *redbrickbutton, *camacbutton;
	     struct sesslist *sesslist;
	     int midsession;
	 };
	@@ -321,6 +321,18 @@
	 	(struct sessionsaver_data *)ctrl->generic.context.p;
	     char *savedsession;

	+   if(event == EVENT_ACTION && (ctrl == ssd->redbrickbutton || ctrl == ssd->camacbutton))
	+   {
	+      strcpy(cfg->host, ( ctrl == ssd->redbrickbutton ? "login.redbrick.dcu.ie" : "camac.dcu.ie") );
	+      cfg->protocol = PROT_SSH;
	+      cfg->port = 22;
	+
	+      /* Close dialog as if we had clicked 'Open' */
	+      dlg_end(dlg, 1);
	+
	+      return;
	+   }
	+
	     /*

	      * The first time we're called in a new dialog, we must
	      * allocate space to store the current contents of the saved
	@@ -853,6 +865,12 @@
	 					sessionsaver_handler, P(ssd));
	     ssd->cancelbutton->button.iscancel = TRUE;
	     ssd->cancelbutton->generic.column = 4;
	+
	+    ssd->redbrickbutton = ctrl_pushbutton(s, "RedBrick!", 'b', HELPCTX(no_help), sessionsaver_handler, P(ssd));
	+    ssd->redbrickbutton->generic.column = 0;
	+    ssd->camacbutton = ctrl_pushbutton(s, "Camac", 'm', HELPCTX(no_help), sessionsaver_handler, P(ssd));
	+    ssd->camacbutton->generic.column = 1;
	+
	     /* We carefully don't close the 5-column part, so that platform-

	      * specific add-ons can put extra buttons alongside Open and Cancel. */

	diff -Nru 0.58-orig/VERSION.C 0.58-phaxx/VERSION.C
	--- 0.58-orig/VERSION.C	2005-04-05 20:37:51.000000000 +0100
	+++ 0.58-phaxx/VERSION.C	2007-01-26 17:25:00.000000000 +0000
	@@ -17,7 +17,7 @@

	 #else

	-char ver[] = "Unidentified build, " __DATE__ " " __TIME__;
	+char ver[] = "PuTTY 0.58-redbrick-phaxx, " __DATE__ " " __TIME__;
	 char sshver[] = "PuTTY-Local: " __DATE__ " " __TIME__;

	 #endif
	diff -Nru 0.58-orig/WINDOWS/WINCFG.C 0.58-phaxx/WINDOWS/WINCFG.C
	--- 0.58-orig/WINDOWS/WINCFG.C	2005-04-05 20:37:38.000000000 +0100
	+++ 0.58-phaxx/WINDOWS/WINCFG.C	2007-01-26 17:26:53.000000000 +0000
	@@ -44,12 +44,12 @@
	 	s = ctrl_getset(b, "", "", "");
	 	c = ctrl_pushbutton(s, "About", 'a', HELPCTX(no_help),
	 			    about_handler, P(hwndp));
	-	c->generic.column = 0;
	-	if (has_help) {
	+	c->generic.column = 2;
	+	/*if (has_help) {
	 	    c = ctrl_pushbutton(s, "Help", 'h', HELPCTX(no_help),
	 				help_handler, P(hwndp));
	 	    c->generic.column = 1;
	-	}
	+	}*/
	     }

	     /*
	diff -Nru 0.58-orig/WINDOWS/WINNET.C 0.58-phaxx/WINDOWS/WINNET.C
	--- 0.58-orig/WINDOWS/WINNET.C	2005-04-05 20:37:38.000000000 +0100
	+++ 0.58-phaxx/WINDOWS/WINNET.C	2007-01-26 17:39:29.000000000 +0000
	@@ -13,6 +13,7 @@
	 #include "putty.h"
	 #include "network.h"
	 #include "tree234.h"
	+#define NO_IPV6

	 #include `<ws2tcpip.h>`


## UTF-8 Patch

I worked on this a while ago. It worked on my computer, but atlas claimed it didn't work for him :(

The change i was working on was to remove the switch statement from winucs.c where it tries to set the default encoding option based on your windows locale, and have it just always set UTF-8.

I tried messing about with the ordering in the menu and stuff, but that didn't work. The change we want is definatly here.


	winucs.c:1008

	int decode_codepage(char *cp_name)
	{
	    char *s, *d;
	    const struct cp_list_item *cpi;
	    int codepage = -1;
	    CPINFO cpinfo;

	    if (!*cp_name) {
	    /*

	     * Here we select a plausible default code page based on
	     * the locale the user is in. We wish to select an ISO code
	     * page or appropriate local default _rather_ than go with
	     * the Win125* series, because it's more important to have
	     * CSI and friends enabled by default than the ghastly
	     * Windows extra quote characters, and because it's more
	     * likely the user is connecting to a remote server that
	     * does something Unixy or VMSy and hence standards-
	     * compliant than that they're connecting back to a Windows
	     * box using horrible nonstandard charsets.
	     *
	     * Accordingly, Robert de Bath suggests a method for
	     * picking a default character set that runs as follows:
	     * first call GetACP to get the system's ANSI code page
	     * identifier, and translate as follows:
	     *
	     * 1250 -> ISO 8859-2
	     * 1251 -> KOI8-U
	     * 1252 -> ISO 8859-1
	     * 1253 -> ISO 8859-7
	     * 1254 -> ISO 8859-9
	     * 1255 -> ISO 8859-8
	     * 1256 -> ISO 8859-6
	     * 1257 -> ISO 8859-13 (changed from 8859-4 on advice of a Lithuanian)
	     *
	     * and for anything else, choose direct-to-font.
	     */
	    int cp = GetACP();
	    /*switch (cp) {
	      case 1250: cp_name = "ISO-8859-2"; break;
	      case 1251: cp_name = "KOI8-U"; break;
	      case 1252: cp_name = "ISO-8859-1"; break;
	      case 1253: cp_name = "ISO-8859-7"; break;
	      case 1254: cp_name = "ISO-8859-9"; break;
	      case 1255: cp_name = "ISO-8859-8"; break;
	      case 1256: cp_name = "ISO-8859-6"; break;
	      case 1257: cp_name = "ISO-8859-13"; break;
	        default: leave it blank, which will select -1, direct->font
	    }*/

	    cp_name = "UTF-8";

	    }

	    if (cp_name && *cp_name)
	    for (cpi = cp_list; cpi->name; cpi++) {
	        s = cp_name;
	        d = cpi->name;
	        for (;;) {
	        while (*s && !isalnum(*s) && *s != ':')
	            s++;
	        while (*d && !isalnum(*d) && *d != ':')
	            d++;
	        if (*s == 0) {
	            codepage = cpi->codepage;
	            if (codepage == CP_UTF8)
	            goto break_break;
	            if (codepage == -1)
	            return codepage;
	            if (codepage == 0) {
	            codepage = 65536 + (cpi - cp_list);
	            goto break_break;
	            }

	            if (GetCPInfo(codepage, &cpinfo) != 0)
	            goto break_break;
	        }
	        if (tolower(*s++) != tolower(*d++))
	            break;
	        }
	    }

	    if (cp_name && *cp_name) {
	    d = cp_name;
	    if (tolower(d[0]) == 'c' && tolower(d[1]) == 'p')
	        d += 2;
	    if (tolower(d[0]) == 'i' && tolower(d[1]) == 'b'
	        && tolower(d[1]) == 'm')
	        d += 3;
	    for (s = d; *s >= '0' && *s <= '9'; s++);
	    if (*s == 0 && s != d)
	        codepage = atoi(d);        /* CP999 or IBM999 */

	    if (codepage == CP_ACP)
	        codepage = GetACP();
	    if (codepage == CP_OEMCP)
	        codepage = GetOEMCP();
	    if (codepage > 65535)
	        codepage = -2;
	    }

	  break_break:;
	    if (codepage != -1) {
	    if (codepage != CP_UTF8 && codepage < 65536) {
	        if (GetCPInfo(codepage, &cpinfo) == 0) {
	        codepage = -2;
	        } else if (cpinfo.MaxCharSize > 1)
	        codepage = -3;
	    }
	    }
	    if (codepage == -1 && *cp_name)
	    codepage = -2;
	    return codepage;
	}
