build:
	@swift build 

install:
	@mv .build/release/l10n /usr/local/bin/

clean:
	@swift build --clean=dist

run: build
	@.build/debug/l10n

release: 
	@swift build -c release -Xswiftc -static-stdlib

gen_xcode:
	@swift package generate-xcodeproj

docker:
	@docker run --rm -it --name swift -v $PWD:/local/dev swift:3.0.2 /bin/bash
