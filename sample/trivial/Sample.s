let _ = require( '..' );

/**/

let about = _.npm.aboutFromRemote( 'wTools' );
console.log( about.description );
