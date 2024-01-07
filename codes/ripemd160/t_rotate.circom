pragma circom 2.0.0;

include "rotate.circom";

template T_rotate() {
    signal input r;
    signal input in[32];
    signal output out[32];

    component rol =  RotL(32, r);

    for(var k = 0; k < 32; k++){
        rol.in[k] <== in[k];
    }

    for (var k=0; k < 32; k++) {
        out[k] <== rol.out[k];
     }
}