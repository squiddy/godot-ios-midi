default:
	uvx scons target=debug
	mv bin/libgodot_ios_midi.a bin/godot_ios_midi.a

godot-headers:
	cd src/godot && uvx scons platform=ios target=template_debug generate_bundle=yes
