#  MIDI plugin for Godot on iOS

I hacked this together after discovering that the MIDI support in Godot is not
available on iOS. This plugin uses the CoreMIDI framework to receive MIDI
events.

## Build

1. Install `uv` from https://docs.astral.sh/uv/
2. Install `xcode` and command line tools
3. Build godot headers by running `make godot-headers`
3. Run `make`
4. Copy `bin/godot_ios_midi.a` and `src/godot_ios_midi.gdip` to your Godot project's `ios/plugins` directory
5. Enable plugin on export

## Usage

```csharp
public override void _Ready()
{
    if (Engine.HasSingleton("MidiIOS"))
    {
        var plugin = Engine.GetSingleton("MidiIOS");
        plugin.Connect(
            "midi_event",
            Callable.From(
                (Godot.Collections.Dictionary eventData) => OnMidiEvent(eventData)
            )
        );
    }
}

public void OnMidiEvent(Godot.Collections.Dictionary eventData)
{
    byte[] midiBytes = (byte[])eventData["data"];
    var timestamp = (double)eventData["timestamp"];

    GD.Print(
        $"MIDI Event Received - Timestamp: {timestamp}, Data: {BitConverter.ToString(midiBytes)}
    );
}
```
