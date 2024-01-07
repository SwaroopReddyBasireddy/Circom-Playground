pragma circom 2.0.0;
include "../G.circom";

template G3(n){
    signal input in_1[n];
    signal input in_2[n];
    signal input in_3[n];
    signal output out[n];

    component  g = G(n);
    
    for (var k=0; k<n; k++) {
        g.x[k] <== in_1[k];
        g.y[k] <== in_2[k];
        g.z[k] <== in_3[k];
       
     }

     for (var k=0; k<n; k++) {
        out[k] <== g.out[k];
     }
}

component main = G3(8);