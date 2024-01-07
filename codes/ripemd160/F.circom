pragma circom 2.0.0;
include "./gates.circom";
//include "../circomlib/circuits/gates.circom";

/*
out = XOR3(x,y,x)

*/

template F(n){
    signal input x[n];
    signal input y[n];
    signal input z[n];
    signal output out[n];
    
    component xor3 = XOR3(n);
    
    for(var k = 0; k < n; k++){
        xor3.a[k] <== x[k];
        xor3.b[k] <== y[k];
        xor3.c[k] <== z[k];
    }

    for(var k = 0; k < n; k++){
        out[k] <== xor3.out[k];
    }
}