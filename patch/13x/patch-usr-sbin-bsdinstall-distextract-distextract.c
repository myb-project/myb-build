--- distextract.c.orig	2021-10-18 04:39:18.328851000 +0300
+++ distextract.c	2021-10-18 15:16:01.683143000 +0300
@@ -71,7 +71,7 @@
 	size_t span;
 	struct dpv_config *config;
 	struct dpv_file_node *dist = dists;
-	static char backtitle[] = "FreeBSD Installer";
+	static char backtitle[] = "MyBee Installer";
 	static char title[] = "Archive Extraction";
 	static char aprompt[] = "\n  Overall Progress:";
 	static char pprompt[] = "Extracting distribution files...\n";
