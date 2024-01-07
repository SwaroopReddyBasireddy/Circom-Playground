pragma circom 2.0.0;

include "constants.circom";
include "ripemd160compression.circom";

template Ripemd160(nBits) {
    signal input in[nBits];
    signal output out[160];

    var i;
    var k;
    var nBlocks;
    var bitsLastBlock;


    nBlocks = ((nBits + 64)\512)+1;

    signal paddedIn[nBlocks*512];

    for (k=0; k<nBits; k++) {
        paddedIn[k] <== in[k];
    }
    paddedIn[nBits] <== 1;

    for (k=nBits+1; k<nBlocks*512-64; k++) {
        paddedIn[k] <== 0;
    }

    for (k = 0; k<64; k++) {
        paddedIn[nBlocks*512 - k -1] <== (nBits >> k)&1;
    }

    component ha0 = H_initial(0);
    component hb0 = H_initial(1);
    component hc0 = H_initial(2);
    component hd0 = H_initial(3);
    component he0 = H_initial(4);
    
    component ripemd160compression[nBlocks];

for (i=0; i<nBlocks; i++) {

        ripemd160compression[i] = Ripemd160compression() ;

    if (i==0) {
            for (k=0; k<32; k++ ) {
                ripemd160compression[i].hin[0*32+k] <== ha0.out[k];
                ripemd160compression[i].hin[1*32+k] <== hb0.out[k];
                ripemd160compression[i].hin[2*32+k] <== hc0.out[k];
                ripemd160compression[i].hin[3*32+k] <== hd0.out[k];
                ripemd160compression[i].hin[4*32+k] <== he0.out[k];
                }
        } else {
            for (k=0; k<32; k++ ) {
                ripemd160compression[i].hin[32*0+k] <== ripemd160compression[i-1].out[32*0+31-k];
                ripemd160compression[i].hin[32*1+k] <== ripemd160compression[i-1].out[32*1+31-k];
                ripemd160compression[i].hin[32*2+k] <== ripemd160compression[i-1].out[32*2+31-k];
                ripemd160compression[i].hin[32*3+k] <== ripemd160compression[i-1].out[32*3+31-k];
                ripemd160compression[i].hin[32*4+k] <== ripemd160compression[i-1].out[32*4+31-k];
                }
        }

        for (k=0; k<512; k++) {
            ripemd160compression[i].inp[k] <== paddedIn[i*512+k];
        }
    }

    for (k=0; k<160; k++) {
        out[k] <== ripemd160compression[nBlocks-1].out[k];
    }

}
