pragma circom 2.0.0;

include "constants.circom";
include "ripemd160compression.circom";
include "../circomlib/circuits/bitify.circom";

template Ripemd160_2() {
    signal input a;
    signal input b;
    signal output out;

    var i;
    var k;

    component bits2num = Bits2Num(160);
    component num2bits[2];

    num2bits[0] = Num2Bits(216);
    num2bits[1] = Num2Bits(216);

    num2bits[0].in <== a;
    num2bits[1].in <== b;


    component ripemd160compression = Ripemd160compression() ;

    component ha0 = H_initial(0);
    component hb0 = H_initial(1);
    component hc0 = H_initial(2);
    component hd0 = H_initial(3);
    component he0 = H_initial(4);
    
    for (k=0; k<32; k++ ) {
        ripemd160compression.hin[0*32+k] <== ha0.out[k];
        ripemd160compression.hin[1*32+k] <== hb0.out[k];
        ripemd160compression.hin[2*32+k] <== hc0.out[k];
        ripemd160compression.hin[3*32+k] <== hd0.out[k];
        ripemd160compression.hin[4*32+k] <== he0.out[k];
            }

    for (i=0; i<216; i++) {
        ripemd160compression.inp[i] <== num2bits[0].out[215-i];
        ripemd160compression.inp[i+216] <== num2bits[1].out[215-i];
    }

    ripemd160compression.inp[432] <== 1;

    for (i=433; i<503; i++) {
        ripemd160compression.inp[i] <== 0;
    }

    ripemd160compression.inp[503] <== 1;
    ripemd160compression.inp[504] <== 1;
    ripemd160compression.inp[505] <== 0;
    ripemd160compression.inp[506] <== 1;
    ripemd160compression.inp[507] <== 1;
    ripemd160compression.inp[508] <== 0;
    ripemd160compression.inp[509] <== 0;
    ripemd160compression.inp[510] <== 0;
    ripemd160compression.inp[511] <== 0;

    for (i=0; i<160; i++) {
        bits2num.in[i] <== ripemd160compression.out[159-i];
    }

    out <== bits2num.out;
}