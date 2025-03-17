//
//  godot_ios_midi.cpp
//  godot-ios-midi
//
//  Created by Reiner Gerecke on 17.03.25.
//

#include "core/config/engine.h"
#include "godot_ios_midi_module.h"
#include "godot_ios_midi.h"
#include "core/version.h"

Midi *plugin;

void init_my_plugin() {
    plugin = memnew(Midi);
    Engine::get_singleton()->add_singleton(Engine::Singleton("MidiIOS", plugin));
}

void deinit_my_plugin() {
    if (plugin) {
        memdelete(plugin);
    }
}
