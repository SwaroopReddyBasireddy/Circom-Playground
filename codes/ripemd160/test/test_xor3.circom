pragma circom 2.0.0;
include "../gates.circom";

template Xor3 (n){
    signal input in_1[n];
    signal input in_2[n];
    signal input in_3[n];
    signal output out[n];

    component  xor = XOR3(n);
    
    for (var k=0; k<n; k++) {
        xor.a[k] <== in_1[k];
        xor.b[k] <== in_2[k];
        xor.c[k] <== in_3[k];
       
     }

     for (var k=0; k<n; k++) {
        out[k] <== xor.out[k];
     }
}

component main = Xor3(4);