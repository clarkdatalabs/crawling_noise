// Generates notes within G natural minor

var minor, major, starting_note, max_links, current_note, note_input, divs_input, old_site_domain;
minor = List[0, 2, 3, 5, 7, 8, 10, 12, 14, 15, 17, 19, 20, 22, 24, 26, 27, 29, 31, 32, 34, 36]; // natural minor scale for two octaves
major = List[0, 2, 4, 5, 7, 9, 11, 12, 14, 16, 17, 19, 21, 23, 24, 26, 28, 29, 31, 33, 35, 36]; // major scale for two octaves
starting_note = 43; // G below middle C
max_links = 100; // starting value for max of links
current_note = 0;  // starting value for melody notes
note_input = 0;
divs_input = 0;
old_site_domain = 0;

SynthDef(\smooth, { |freq = 440, sustain = 3, amp = 0.3|
    var sig;
	sig =  FSinOsc.ar([freq.midicps], 0, amp) * FSinOsc.ar((freq - 12).midicps, 0, (amp/16)) * EnvGen.kr(Env.linen(0.3, sustain, 0.4), doneAction: 2);
	m.add(freq);
    Out.ar(0, sig ! 2)
}).add;

SynthDef(\chord1, { |freq = 440, sustain = 1.5, amp = 0.2|
    var sig;
	sig =  FSinOsc.ar([freq.midicps], 0, amp) * FSinOsc.ar((freq+12).midicps, 0, (amp/8)) * EnvGen.kr(Env.linen(0.2, sustain, 0.3), doneAction: 2);
	m.add(freq);
    Out.ar(1, sig ! 2)
}).add;


n = NetAddr.new("127.0.0.1", nil);    // create the NetAddr
// create the OSCresponderNode

o = OSCFunc({ arg msg, time, addr, recvPort; [msg, time, addr, recvPort].postln;
	note_input = msg[1].postln;
	divs_input = msg[3];
	if(note_input.notNil, {
		// always plays a melody note through \smooth synth
		// now chooses an int between 0 and 14 based on linear mapping from 0 to max_links, highest value so far, to 0 to 14
		// which we will use as an index for a note in
		if(note_input > max_links, {max_links = note_input.postln});
		current_note = note_input.linlin(0, max_links, 0, 14).ceil;
		current_note.postln;
		// plays melody notes
		Synth(\smooth, [freq: starting_note + minor[current_note], sustain: 1 ]);
		//	plays chord	 (chord from 1st, 3rd, and 5th notes)
		if(divs_input % 2 == 1, {
		Synth(\chord1, [freq: starting_note + minor[current_note], sustain: 0.2 + (divs_input % 2)]);
		Synth(\chord1, [freq: starting_note + minor[current_note + 2], sustain: 0.2 + (divs_input % 2)]);
		Synth(\chord1, [freq: starting_note + minor[current_note + 4], amp: 0.1,  sustain: 0.2 + (divs_input % 2)]);});
		if(msg[4] != old_site_domain, {
			max_links = note_input;
			old_site_domain = msg[4]; });
			Synth(\chord1, [freq: starting_note + minor[current_note + 6], sustain: 0.2 + (divs_input % 2)]);
		// When going to a new domain, this resets the max links value, which allows for a greater range of notes for melody
		});
	//  plays chord (5th note)
//	if(msg[4] > 1, {
//		Synth(\chord1, [freq: starting_note + minor[current_note + 4], sustain: 1.5 + (msg[2] % 3)]); });
// when on not on a  dot com domain, adds the 5th to the chord
}, '/startup', n);

// instead of trying to make chords within a given synth, forming chords using three different instances of synth \smooth. much less froggy!

// to get the server up and running, run s.boot and then the code snippet above

//s.boot;
//o.free;
//s.quit;


// to-do - 1) listen for rare events as well, and upon hearing one, generate diatonic chords using [index, index +2, index + 4] and/or [index, index + 2, index + 4, index + 6] using a different synth



//440

//FQ: 440 "middle A"
//midicps

//57 -> make middle A --> 440
//58 -> make A# -> 452.46452
//59 -> B
//60 C
//61 C#
//62 D

//55 + minor[0] = 55 = G
//55 + minor[1] = 57 = A
//55 + minor[2] = 58 = Bb

//G A Bb C D E F G A Bb C D E F G
//0 1 2 3 4 5

//3 % 2 -> 1
//5 % 3 -> 2
//MSG 21472194 % 15 - 0 and 14