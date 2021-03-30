
let _ = require( 'wnpmtools' );

/* */

let about = _.npm.remoteAbout( 'wTools' );
console.log( about.description );
