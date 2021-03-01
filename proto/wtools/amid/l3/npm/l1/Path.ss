( function _Path_ss_()
{

'use strict';

let _ = _global_.wTools;
let Parent = _.uri.path;
let Self = _.npm.path = _.npm.path || Object.create( Parent );

// --
//
// --

/**
 * @typedef { Object } RemotePathComponents
 * @property { String } protocol
 * @property { String } hash
 * @property { String } longPath
 * @property { String } host
 * @property { String } localVcsPath
 * @property { Boolean } isFixated
 * @module Tools/mid/NpmTools
 */

/**
 * Routine parse() parses provided {-remotePath-} and returns object with components
 * {@link module:Tools/mid/Files.wTools.FileProvider.Npm.RemotePathComponents}.
 *
 * @example
 * _.npm.path.parse( 'npm:///wTools/out/wTools.out.will.yml!alpha' );
 * // returns :
 * // {
 * //   protocol : 'npm',
 * //   tag : 'alpha',
 * //   longPath : 'wTools',
 * //   localVcsPath : 'out/wTools.out.will.yml',
 * // }
 *
 * @returns { Map } - Returns map with parsed {-remotePath-}
 * @param { String } remotePath - Remote path.
 * @function pathParse
 * @namespace wTools.npm.path
 * @module Tools/mid/NpmTools
 */

function parse_head( routine, args )
{
  let o = args[ 0 ];

  _.assert( args.length === 1, 'Expects single options map {-o-}' );

  if( _.strIs( o ) )
  o = { remotePath : o };

  _.routineOptions( routine, o );
  _.assert( _.strIs( o.remotePath ) || _.mapIs( o.remotePath ), 'Expects file path {-o.remotePath-}' );

  return o;
}

//

function parse_body( o )
{
  let self = this;

  if( _.mapIs( o.remotePath ) )
  return o.remotePath;

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( o.remotePath ) );
  _.assert( _.uri.isGlobal( o.remotePath ) );

  /* */

  let result = Object.create( null );
  let parsed1 = _.uri.parseConsecutive( o.remotePath );
  _.mapExtend( result, parsed1 );

  _.assert( !result.tag || !result.hash, 'Remote path:', _.strQuote( o.remotePath ), 'should contain only hash or tag, but not both.' )

  if( !result.tag && !result.hash )
  result.tag = 'latest';

  let [ name, localPath ] = pathIsolateGlobalAndLocal( parsed1.longPath );
  result.localVcsPath = localPath;
  result.host = name || '';

  /* */

  // let parsed2 = _.mapExtend( null, parsed1 );
  // parsed2.protocol = null;
  // parsed2.hash = null;
  // parsed2.tag = null;
  // parsed2.longPath = name;
  // result.remoteVcsPath = path.str( parsed2 );

  // result.remoteVcsLongerPath = result.remoteVcsPath + '@' + ( result.hash || result.tag );

  /* */

  result.isFixated = _.npm.path.isFixated( result );

  return result;

  /* */

  function pathIsolateGlobalAndLocal( longPath )
  {
    let splits = _.path.split( longPath );
    if( splits[ 0 ] === '' )
    splits.splice( 0, 1 );
    return [ splits[ 0 ], splits.slice( 1 ).join( '/' ) ];
  }
}

parse_body.defaults =
{
  remotePath : null,
};

//

let parse = _.routineUnite( parse_head, parse_body );

//

function isFixated( remotePath )
{
  let parsed = _.npm.path.parse({ remotePath });

  if( !parsed.hash )
  return false;

  return true;
}

// --
// declare
// --

let Extension =
{

  parse,

  isFixated,

}

_.mapExtend( Self, Extension );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();
