SynthDef(\smooth, { |freq = 440, sustain = 1, amp = 0.5|
    var sig;
	sig = Pinknoise.ar(0.5) * SinOsc.ar(freq, 0, amp) * EnvGen.kr(Env.linen(0.05, sustain, 0.1), doneAction: 2);
    Out.ar(0, sig ! 2)
}).add;

n = NetAddr.new("127.0.0.1", nil);    // create the NetAddr
// create the OSCresponderNode
o = OSCFunc({ arg msg, time, addr, recvPort; [msg, time, addr, recvPort].postln; Synth(\smooth, [freq: msg[1]*4.5, sustain: msg[2]/5000]);}, '/startup', n);


o.free;


