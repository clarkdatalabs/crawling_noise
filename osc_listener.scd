// Generates notes within G natural minor

var minor, major, starting_note, max_links, max_divs, current_note, current_div_val, old_site_domain, links, size, divs_input, domain, input_time;
minor = List[0, 2, 3, 5, 7, 8, 10, 12, 14, 15, 17, 19, 20, 22, 24, 26, 27, 29, 31, 32, 34, 36, 38, 39]; // natural minor scale for two octaves
major = List[0, 2, 4, 5, 7, 9, 11, 12, 14, 16, 17, 19, 21, 23, 24, 26, 28, 29, 31, 33, 35, 36, 38, 40]; // major scale for two octaves ,not currently used
starting_note = 43; // G below middle C
max_links = 100; // starting value for max # of links on web crawled pages
max_divs = 50; // starting value for max # of divs on web crawled pages
current_note = 0;  // starting value for var used to calculate notes to use
current_div_val = 0; // starting value for var used to for cho
links = 0; // starting value for current value of # of links on most recent page
size = 0; // starting value for current value of size on most recent page
divs_input = 0; // starting value for current value of # of divs on most recent page
domain = 0; // starting value for current top level domain (0 for .edu, 1 for .com, 2 for other) on most recent page
input_time = 0; // starting value for current time to load current page from web crawler

SynthDef(\smooth, { |freq = 440, sustain = 3, amp = 0.4| // synth for melody notes
    var sig;
	sig =  FSinOsc.ar([freq.midicps], 0, amp) * FSinOsc.ar((freq - 12).midicps, 0, (amp/16)) * EnvGen.kr(Env.linen(0.3, sustain, 0.7), doneAction: 2);
	m.add(freq);
    Out.ar(0, sig ! 2)
}).add;

SynthDef(\chord1, { |freq = 440, sustain = 1.5, amp = 0.3| // synth for chords
    var sig;
	sig =  FSinOsc.ar([freq.midicps], 0, amp) * FSinOsc.ar((freq -12).midicps, 0, (amp/8)) * EnvGen.kr(Env.linen(0.2, sustain, 0.6), doneAction: 2);
	m.add(freq);
    Out.ar(1, sig ! 2)
}).add;


n = NetAddr.new("127.0.0.1", nil);    // create the NetAddr
// create the OSCresponderNode

o = OSCFunc({ arg msg, time, addr, recvPort; [msg, time, addr, recvPort].postln;
	links = msg[1].postln;
	size = msg[2];
	divs_input = msg[3];
	domain = msg[4];
	input_time = msg[5];
	if(links.notNil, {
		if(links > max_links, {max_links = links});
		current_note = links.linlin(0, max_links, 0, 14).ceil;
		current_note.postln;  // current_note maps the # of links to a value between 0 and 14
		if(divs_input > max_divs, {max_divs = divs_input.postln});
		current_div_val = divs_input.linlin(0, max_divs, 0, 2).floor;
		current_div_val.postln; // similarly, # of divs mapped to a value between 0 and 2
		Synth(\smooth, [freq: starting_note + minor[current_note], sustain: 0.1 ]); // plays melody note
		//	plays chord	 (chord from 1st, 3rd, and 5th notes)
		if(input_time > 0, {  // chords only played if crawler takes 1 or more seconds to load page.
			if(current_div_val == 0, {  // plays major chord if # of divs in lower 3rd of range
				Synth(\chord1, [freq: starting_note + minor[current_note], sustain: 0.2 + input_time]);
				Synth(\chord1, [freq: starting_note + minor[current_note + 2], sustain: 0.2 + input_time]);
				Synth(\chord1, [freq: starting_note + minor[current_note + 4], amp: 0.1,  sustain: 0.2 + input_time]);});

			if(current_div_val == 1, {  // plays major chord first inversion if # of divs in middle 3rd of range
				Synth(\chord1, [freq: starting_note + minor[current_note], sustain: 0.2 + input_time]);
				Synth(\chord1, [freq: starting_note + minor[current_note + 5], sustain: 0.2 + input_time]);
				Synth(\chord1, [freq: starting_note + minor[current_note + 9], amp: 0.1,  sustain: 0.2 + input_time]);});

			if(current_div_val == 2, { // plays major chord second inversion if # of divs in upper 3rd of range
				Synth(\chord1, [freq: starting_note + minor[current_note], sustain: 0.2 + input_time]);
				Synth(\chord1, [freq: starting_note + minor[current_note + 4], sustain: 0.2 + input_time]);
				Synth(\chord1, [freq: starting_note + minor[current_note + 6], amp: 0.1,  sustain: 0.2 + input_time]);}); });


		if(domain != old_site_domain, {
			max_links = links;
			max_divs = divs_input;
			old_site_domain = msg[4]; }); // resets max_links and max_divs when sites are new domains to avoid skewed mapping
			Synth(\chord1, [freq: starting_note + minor[current_note + 6], sustain: 0.2 + input_time]);  // adds the 7th note

		});
}, '/startup', n);

// commands to use for booting up/quitting SC localhost server
//s.boot;
//o.free;
//s.quit;
