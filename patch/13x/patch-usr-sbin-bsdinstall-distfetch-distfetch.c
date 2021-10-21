--- distfetch.c.orig	2021-10-18 04:39:18.328967000 +0300
+++ distfetch.c	2021-10-18 15:17:16.421956000 +0300
@@ -69,7 +69,7 @@
 	}
 
 	init_dialog(stdin, stdout);
-	dialog_vars.backtitle = __DECONST(char *, "FreeBSD Installer");
+	dialog_vars.backtitle = __DECONST(char *, "MyBee Installer");
 	dlg_put_backtitle();
 
 	for (i = 0; i < ndists; i++) {
