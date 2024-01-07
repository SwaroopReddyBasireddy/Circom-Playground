pragma circom 2.0.0;
include "./gates.circom";
//include "../circomlib/circuits/gates.circom";

/*
out = x ^ (y v -z) =>
(y + 1-z - y + yz)^x = (1-z-yz)^z

or = 1-z+yz
out x ^ or
*/

template J(n){
    signal input x[n];
    signal input y[n];
    signal input z[n];
    signal output out[n];
    signal or[n];
    
    for(var k = 0; k < n; k++){
        or[k] <== 1 - z[k] + y[k] * z[k];
    }

    component xor = XOR2(n);
    for(var k = 0; k < n; k++){
        xor.a[k] <== x[k];
        xor.b[k] <== or[k];
    }

    for(var k = 0; k < n; k++){
        out[k] <== xor.out[k];
    }
        

}