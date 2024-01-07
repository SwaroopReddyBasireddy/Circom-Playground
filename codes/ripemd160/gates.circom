/* Xor3 function for ripemd160

Method 1: =>
out = a ^ b ^ c  => (a ^ b) ^ c =>

mid = a ^ b = a + b - 2*a*b
out = mid ^ c = mid + c - 2*mid*c

Method 2: =>
out = a+b+c - 2*a*b - 2*a*c - 2*b*c + 4*a*b*c   =>

out = a*( 1 - 2*b - 2*c + 4*b*c ) + b + c - 2*b*c =>

mid = b*c
out = a*( 1 - 2*b -2*c + 4*mid ) + b + c - 2 * mid

*/
pragma circom 2.1.3;

// template OR(n) {
//     signal input a[n];
//     signal input b[n];
//     signal output out[n];

//     for (var k=0; k<n; k++) {
//         out[k] <== a[k] + b[k] - a[k]*b[k];
//     }

// template AND(n) {
//     signal input a[n];
//     signal input b[n];
//     signal output out[n];

//     for (var k=0; k<n; k++) {
//         out[k] <== a[k]*b[k];
//     }
// }

// template NOT(n) {
//     signal input a[n];
//     signal output out[n];

//     for (var k=0; k<n; k++) {
//         out[k] <== 1 - a[k];
//     }
// }

template XOR2(n) {
    signal input a[n];
    signal input b[n];
    signal output out[n];

    for (var k=0; k<n; k++) {
        out[k] <== a[k] + b[k] - 2 *a[k]*b[k];
    }

}  

template XOR3(n) {
    signal input a[n];
    signal input b[n];
    signal input c[n];
    signal output out[n];
    signal mid[n];

    // Method 1
    for (var k=0; k<n; k++) {
        mid[k] <== a[k] + b[k] - 2 *a[k]*b[k];
        out[k] <== mid[k] + c[k] - 2 *mid[k]*c[k];
    }

    // // Method 2
    // for (var k=0; k<n; k++) {
    //     mid[k] <== b[k]*c[k];
    //     out[k] <== a[k] * (1 -2*b[k]  -2*c[k] +4*mid[k]) + b[k] + c[k] -2*mid[k];
    // }
}