pragma circom 2.0.0;
include "./gates.circom";
//include "../circomlib/circuits/gates.circom";

/*
out = (x v -y) ^ z =>
(x + (1-y) - x(1-y))^z = (1-y-xy)^z

or = 1-y+xy
out or ^ z
*/

template H(n){
    signal input x[n];
    signal input y[n];
    signal input z[n];
    signal output out[n];
    signal or[n];
    
    for(var k = 0; k < n; k++){
        or[k] <== 1 - y[k] + x[k] * y[k];
    }

    component xor = XOR2(n);
    for(var k = 0; k < n; k++){
        xor.a[k] <==  or[k];
        xor.b[k] <== z[k];
    }

    for(var k = 0; k < n; k++){
        out[k] <== xor.out[k];
    }
        

}