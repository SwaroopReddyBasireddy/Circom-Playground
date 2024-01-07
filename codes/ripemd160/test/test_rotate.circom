pragma circom 2.0.0;
include "../rotate.circom";


template ROL(n,r){
    signal input in[n];
    signal output out[n];

    component rol = RotL(n,r);

    for(var k = 0; k < n; k++){
        rol.in[k] <== in[k];
    }

    for (var k=0; k<n; k++) {
        out[k] <== rol.out[k];
     }
}

component main = ROL(8,2);