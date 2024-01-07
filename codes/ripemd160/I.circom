pragma circom 2.0.0;

//include "../circomlib/circuits/gates.circom";

/* 
out = (x & z) V (y & -z) =>
    = xz + y(1-z) - xzy(1-z)
    = xz + y(1-z) - xyz + xyz^2
    xz + y(1-z)

*/

template I(n) {
    signal input x[n];
    signal input y[n];
    signal input z[n];
    signal output out[n];
    signal mid[n];

    for(var k = 0; k < n; k++){
        mid[k] <== (1 - z[k])*y[k];
        out[k] <== x[k]*z[k] + mid[k];
    }
    
}