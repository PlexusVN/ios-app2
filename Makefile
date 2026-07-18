PROJECT_NAME = SensiUltralock
SCHEME = $(PROJECT_NAME)
CONFIGURATION = Release

.PHONY: all generate build clean archive export install

all: generate build

generate:
	xcodegen generate --project .

build: generate
	xcodebuild -project "$(PROJECT_NAME).xcodeproj" \
		-scheme "$(SCHEME)" \
		-configuration "$(CONFIGURATION)" \
		-sdk iphonesimulator \
		-destination 'platform=iOS Simulator,name=iPhone 15' \
		CODE_SIGNING_REQUIRED=NO \
		CODE_SIGNING_ALLOWED=NO \
		build

archive: generate
	xcodebuild clean archive \
		-project "$(PROJECT_NAME).xcodeproj" \
		-scheme "$(SCHEME)" \
		-configuration "$(CONFIGURATION)" \
		-sdk iphoneos \
		-archivePath "$(PROJECT_NAME).xcarchive" \
		-destination "generic/platform=iOS" \
		CODE_SIGNING_REQUIRED=NO \
		CODE_SIGNING_ALLOWED=NO

export: archive
	xcodebuild -exportArchive \
		-archivePath "$(PROJECT_NAME).xcarchive" \
		-exportPath "./output" \
		-exportOptionsPlist .github/exportOptions.plist \
		CODE_SIGNING_REQUIRED=NO \
		CODE_SIGNING_ALLOWED=NO

clean:
	rm -rf "$(PROJECT_NAME).xcarchive"
	rm -rf output/
	rm -rf "$(PROJECT_NAME).xcodeproj"
	rm -rf DerivedData/
