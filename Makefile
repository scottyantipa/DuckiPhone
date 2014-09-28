# builds a release version for the simulator
.PHONY: build_simulator
build_simulator:
	xcodebuild -arch i386 ONLY_ACTIVE_ARCH=NO -sdk iphonesimulator8.0 -configuration Release

# launch the simulator given the release version of the app
.PHONY: simulate
simulate:
	ios-sim launch build/Release-iphonesimulator/Duck.app