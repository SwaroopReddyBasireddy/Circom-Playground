pragma circom 2.0.0;
include "../F.circom";

template F3(n){
    signal input in_1[n];
    signal input in_2[n];
    signal input in_3[n];
    signal output out[n];

    component  f = F(n);
    
    for (var k=0; k<n; k++) {
        f.x[k] <== in_1[k];
        f.y[k] <== in_2[k];
        f.z[k] <== in_3[k];
       
     }

     for (var k=0; k<n; k++) {
        out[k] <== f.out[k];
     }
}

component main = F3(8);