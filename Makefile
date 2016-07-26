PREFIX = /usr

all: build

check-name-unique:
	@echo "Check unique icon name..."
	find deepin -name "*.svg" | xargs -n1 basename | sort | uniq -d | xargs -I '{}' find -name '{}'
check-same-icon:
	@echo "Check icons with same hashsum..."  
	find deepin -type f | xargs md5sum | sort | uniq --check-chars=32 -d
check-build-tools:
	@echo "Check build tools..."
	@if [ -x /usr/bin/svgexport ];then echo " ... /usr/bin/svgexport found";else echo "/usr/bin/svgexport not found! Installing it first ..."; sudo apt-get install node-svgexport; fi
	@if [ -x /usr/bin/optipng ];then echo " ... /usr/bin/optipng found";else echo "/usr/bin/optipng not found! PNG file optimize disabled."; fi

prepare:check-build-tools check-name-unique check-same-icon 
	@mkdir -p build

build: prepare convert debian/links

convert:
	mkdir -p build
	python tools/convert.py deepin build

clean:
	rm -rf build

install: install-icons install-cursors 

install-icons:
	mkdir -p $(DESTDIR)$(PREFIX)/share/icons/deepin
	cp -r build/deepin/* $(DESTDIR)$(PREFIX)/share/icons/deepin

install-cursors:
	mkdir -p $(DESTDIR)$(PREFIX)/share/icons/deepin
	cp -r deepin/cursors $(DESTDIR)$(PREFIX)/share/icons/deepin
	install -m644 deepin/cursor.theme $(DESTDIR)$(PREFIX)/share/icons/deepin/cursor.theme

debian/links: hicolor.list
	sh tools/hicolor.links build/deepin hicolor.list > $@
