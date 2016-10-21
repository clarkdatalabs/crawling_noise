// Generates notes within G natural minor

var minor, major, starting_note;
minor = List[0, 2, 3, 5, 7, 8, 10, 12, 14, 15, 17, 19, 20, 22, 24]; // natural minor scale for two octaves
major = List[0, 2, 4, 5, 7, 9, 11, 12, 14, 16, 17, 19, 21, 23, 24]; // major scale for two octaves
starting_note = 55; // G minor
SynthDef(\smooth, { |freq = 440, sustain = 1, amp = 0.4|
    var sig;
	sig =  FSinOsc.ar(freq.midicps, 0, amp) * EnvGen.kr(Env.linen(0.4, sustain, 0.3), doneAction: 2);
	m.add(freq);
    Out.ar(0, sig ! 2)
}).add;

n = NetAddr.new("127.0.0.1", nil);    // create the NetAddr
// create the OSCresponderNode
o = OSCFunc({ arg msg, time, addr, recvPort; [msg, time, addr, recvPort].postln; Synth(\smooth, [freq: starting_note + minor[(msg[1] % 15)], sustain: 0.5 + (msg[2] % 3) ]);}, '/startup', n);

// s.boot;
// o.free;
// s.quit;
// To-do - 1) listen for rare events as well, and upon hearing one, generate diatonic chords using [index, index +2, index + 4] and/or [index, index + 2, index + 4, index + 6] using a different synth


