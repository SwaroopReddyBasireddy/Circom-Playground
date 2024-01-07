pragma circom 2.0.0;
include "../J.circom";

template J3(n){
    signal input in_1[n];
    signal input in_2[n];
    signal input in_3[n];
    signal output out[n];

    component  j = J(n);
    
    for (var k=0; k<n; k++) {
        j.x[k] <== in_1[k];
        j.y[k] <== in_2[k];
        j.z[k] <== in_3[k];
       
     }

     for (var k=0; k<n; k++) {
        out[k] <== j.out[k];
     }
}

component main = J3(8);