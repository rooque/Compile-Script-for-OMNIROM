Compile Script for OMNIROM
==========================

Copy compile.sh to android(OMNI) root dir.

Usage: 
======

```
bash compile.sh [-d <device>] [-b <clean|installclean|continue> ] [-t] [-u] [-c] [-p]
```


-u : Upload Log File to OMNI Paste  <br>
-p : Use pre-built chromium   <br>
-t : Use timestamp  <br>
-c : Use CCACHE  <br>

Example:
========

Compiling(installclean) for Galaxy S with CCACHE and pre-built chromium:

```
bash compile.sh -d galaxysmtd -b installclean -c -p
```

Compiling(clean) for Galaxy S(B) with CCACHE , pre-built chromium , timestamp and then upload log to Paste OMNI:

```
bash compile.sh -d galaxysbmtd -b clean -tucp
```


