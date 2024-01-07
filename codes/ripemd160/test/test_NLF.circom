pragma circom 2.0.0;
include "../nonLinear_function.circom";

template Nlf(n){
    signal input in_1[n];
    signal input in_2[n];
    signal input in_3[n];
    signal output out[n];

    component f = NLF(30,n);
    for (var k=0; k<32; k++) {
        f.x[k] <== in_1[k];
        f.y[k] <== in_2[k];
        f.z[k] <== in_3[k];
       
     }

     for (var k=0; k<32; k++) {
        out[k] <== f.out[k];
     }
}

component main = Nlf(8);
