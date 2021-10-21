
if( typeof module !== 'undefined' )
require( 'wnpmtools' );

let _ = wTools;

/* */

let about = _.npm.remoteAbout( 'wTools' );
console.log( about.description );
/* log : Collection of general purpose tools for solving problems. Fundamentally extend JavaScript without spoiling namespace, so may be used solely or in conjunction with another module of such kind */

