pragma circom 2.0.0;

//include "../circomlib/circuits/gates.circom";

/* 
out = (x & y) v (-x & z) =>
    = xy + (1-x)z - xy(1-x)z
    = xy + (1-x)z - xyz+x^2 yz
    = xy - xz + z

*/

template G(n) {
    signal input x[n];
    signal input y[n];
    signal input z[n];
    signal output out[n];
    signal mid[n];

    for(var k = 0; k < n; k++){
        mid[k] <== (1 - x[k]) * z[k];
        out[k] <== x[k]*y[k] + mid[k];
    }
    
}