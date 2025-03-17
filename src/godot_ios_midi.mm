//
//  godot_ios_midi.m
//  godot-ios-midi
//
//  Created by Reiner Gerecke on 17.03.25.
//

#include "godot_ios_midi.h"
#include "core/object/class_db.h"
#include "core/config/project_settings.h"

#import <CoreMIDI/CoreMIDI.h>
#import <Foundation/Foundation.h>

Midi *Midi::instance = NULL;

Midi *Midi::get_singleton() {
    return instance;
};

void Midi::_bind_methods() {
	ADD_SIGNAL(MethodInfo("midi_event", PropertyInfo(Variant::DICTIONARY, "data")));
}


void MyMIDIReadProc(const MIDIPacketList *packetList, void *readProcRefCon, void *srcConnRefCon) {
    Midi *instance = static_cast<Midi *>(readProcRefCon);
    if (!instance) return;

    MIDIPacket *packet = (MIDIPacket *)packetList->packet;

    for (int i = 0; i < packetList->numPackets; i++) {
        printf("MIDI Packet Received: ");

        for (int j = 0; j < packet->length; j++) {
            printf("%02X ", packet->data[j]);
        }

        Dictionary state;
        state["timestamp"] = packet->timeStamp;
        PackedByteArray midi_data;
        midi_data.resize(packet->length);
        memcpy(midi_data.ptrw(), packet->data, packet->length);
        state["data"] = midi_data;
        instance->call_deferred("emit_signal", "midi_event", state);

        printf("\n");

        packet = MIDIPacketNext(packet);
    }
}

void Midi::setupMIDI() {
    MIDIClientRef midiClient;
    MIDIPortRef midiInputPort;

    OSStatus status = MIDIClientCreate(CFSTR("MIDI Client"), NULL, NULL, &midiClient);
    if (status != noErr) {
        NSLog(@"Failed to create MIDI client");
        return;
    }

    status = MIDIInputPortCreate(midiClient, CFSTR("MIDI Input Port"), MyMIDIReadProc, this, &midiInputPort);
    if (status != noErr) {
        NSLog(@"Failed to create MIDI input port");
        return;
    }

    ItemCount numSources = MIDIGetNumberOfSources();
    for (ItemCount i = 0; i < numSources; i++) {
        MIDIEndpointRef source = MIDIGetSource(i);
        if (source != 0) {
            MIDIPortConnectSource(midiInputPort, source, NULL);
            NSLog(@"Connected to MIDI source %lu", (unsigned long)i);
        }
    }
}

Midi::Midi() {
    instance = this;

    this->setupMIDI();
}

Midi::~Midi() {
    instance = NULL;
}
