pragma circom 2.0.0;
include "../constants.circom";

template Constants(x) {
    signal input in1;
    signal input in2;
    signal output out1;
    signal output out2;

    component h = H(x);
    component r_0 = r(x);

    var lc = 0;
    var e = 1;
    for (var i=0; i<32; i++) {
        lc = lc + e*h.out[i];
        e *= 2;
    }

    lc === in1;

    r_0.out === in2;

    out1 <== in1;
    out2 <== in2;
}

component main {public [in1, in2]} =  Constants(1);

