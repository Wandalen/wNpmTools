let _ = require( 'wnpmtools' );

/**/

let about = _.npm.aboutFromRemote( 'wTools' );
console.log( about.description );
