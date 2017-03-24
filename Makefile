build:
	@swift build 

install:
	@mv .build/release/l10n /usr/local/bin/

clean:
	@swift build --clean=dist

run: build
	@.build/debug/l10n

release: clean
	@swift build --configuration release

gen_xcode:
	@swift package generate-xcodeproj
