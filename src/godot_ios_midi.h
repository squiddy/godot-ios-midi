//
//  godot_ios_midi.h
//  godot-ios-midi
//
//  Created by Reiner Gerecke on 17.03.25.
//

#ifndef godot_ios_midi_h
#define godot_ios_midi_h

#import <CoreMIDI/CoreMIDI.h>
#include "core/object/class_db.h"

class Midi : public Object {
    GDCLASS(Midi, Object);

    static Midi *instance;
    static void _bind_methods();

public:

    static Midi *get_singleton();
    void setupMIDI();

    Midi();
    ~Midi();
};

#endif
