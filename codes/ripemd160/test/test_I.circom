pragma circom 2.0.0;
include "../I.circom";

template I3(n){
    signal input in_1[n];
    signal input in_2[n];
    signal input in_3[n];
    signal output out[n];

    component  i = I(n);
    
    for (var k=0; k<n; k++) {
        i.x[k] <== in_1[k];
        i.y[k] <== in_2[k];
        i.z[k] <== in_3[k];
       
     }

     for (var k=0; k<n; k++) {
        out[k] <== i.out[k];
     }
}

component main = I3(8);