pragma circom 2.0.0;
include "../H.circom";

template H3(n){
    signal input in_1[n];
    signal input in_2[n];
    signal input in_3[n];
    signal output out[n];

    component  h = H(n);
    
    for (var k=0; k<n; k++) {
        h.x[k] <== in_1[k];
        h.y[k] <== in_2[k];
        h.z[k] <== in_3[k];
       
     }

     for (var k=0; k<n; k++) {
        out[k] <== h.out[k];
     }
}

component main = H3(8);