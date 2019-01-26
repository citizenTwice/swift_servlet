# Adjust the below as needed

INSTALLDIR := /Users/Shared/templib/
LIBNAME := libswiftservlet.jnilib
JAVAINC := /System/Library/Frameworks/JavaVM.framework/Versions/Current/Headers/
LINKLIBDIR := /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/lib/swift_static/macosx/

LINKDEPS := -lstdc++ -lswiftCore -lswiftAppKit -lswiftCoreLocation -lswiftCoreGraphics -framework Foundation


$(LIBNAME): jnihelper.c servlet.swift swiftservlet1-Bridging-Header.h
	clang -c -I$(JAVAINC) jnihelper.c 
	swiftc -c -import-objc-header swiftservlet1-Bridging-Header.h -I$(JAVAINC) servlet.swift 
	clang -dynamiclib -o $(LIBNAME) jnihelper.o servlet.o -L$(LINKLIBDIR) $(LINKDEPS) -XLinker -w

lib: $(LIBNAME)

install: $(LIBNAME) 
	mkdir -p 2>&1 >/dev/null $(INSTALLDIR)
	rm $(INSTALLDIR)/$(LIBNAME)
	cp $(LIBNAME) $(INSTALLDIR)
	echo JNI lib installed in
	ls -l  $(INSTALLDIR)/$(LIBNAME)
	