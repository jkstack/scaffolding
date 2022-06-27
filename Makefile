.PHONY: all linux.amd64 linux.386 windows.amd64 windows.386

OUTDIR=release

PROJ=scaffolding
VERSION=1.0.0
TIMESTAMP=`date +%s`

BRANCH=`git rev-parse --abbrev-ref HEAD`
HASH=`git log -n1 --pretty=format:%h`
REVERSION=`git log --oneline|wc -l|tr -d ' '`
BUILD_TIME=`date +'%Y-%m-%d %H:%M:%S'`
LDFLAGS="-X 'main.gitBranch=$(BRANCH)' \
-X 'main.gitHash=$(HASH)' \
-X 'main.gitReversion=$(REVERSION)' \
-X 'main.buildTime=$(BUILD_TIME)' \
-X 'main.version=$(VERSION)' \
-X 'main.pluginName=$(PROJ)'"

all: clean prepare linux.amd64 linux.386 windows.amd64 windows.386
	cp CHANGELOG.md $(OUTDIR)/CHANGELOG.md
	cp manifest.json $(OUTDIR)/$(VERSION)/manifest.json
	sed -i "s|#NAME|$(PROJ)|g" $(OUTDIR)/$(VERSION)/manifest.json
	sed -i "s|#VERSION|$(VERSION)|g" $(OUTDIR)/$(VERSION)/manifest.json
version:
	@echo $(VERSION)
linux.amd64:
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -mod vendor -ldflags $(LDFLAGS) \
		-o $(OUTDIR)/$(VERSION)/linux.amd64 code/*.go
linux.386:
	GOOS=linux GOARCH=386 CGO_ENABLED=0 go build -mod vendor -ldflags $(LDFLAGS) \
		-o $(OUTDIR)/$(VERSION)/linux.386 code/*.go
windows.amd64:
	GOOS=windows GOARCH=amd64 CGO_ENABLED=0 go build -mod vendor -ldflags $(LDFLAGS) \
		-o $(OUTDIR)/$(VERSION)/windows.amd64 code/*.go
windows.386:
	ln -s vendor src
	mkdir -p src/$(PROJ)
	ln -s ../../code src/$(PROJ)/code
	GOPATH=$(shell realpath .) GOOS=windows GOARCH=386 CGO_ENABLED=0 go10 build -ldflags $(LDFLAGS) \
		-o $(OUTDIR)/$(VERSION)/windows.386 code/*.go
	rm -fr src vendor/$(PROJ)
prepare:
	mkdir -p $(OUTDIR)
	go mod vendor
clean:
	 if [ -e $(OUTDIR)/BUILD_LIST ]; then \
		mv -f $(OUTDIR)/BUILD_LIST BUILD_LIST; \
		rm -fr $(OUTDIR) && mkdir -p $(OUTDIR); \
		mv BUILD_LIST $(OUTDIR)/BUILD_LIST; \
	else \
		rm -fr $(OUTDIR); \
	fi
distclean:
	rm -fr $(OUTDIR) src vendor/$(PROJ) code/code vendor/vendor
