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
 * First parameter set :
 * @param { String } remotePath - Remote path.
 * Second parameter set :
 * @param { Aux } o - Options map.
 * @param { String } o.remotePath - Remote path.
 * @returns { Map } - Returns map with parsed {-remotePath-}
 * @function parse
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If {-remotePath-} has hash and tag simultaneously.
 * @throws { Error } If {-remotePath-} has not valid type.
 * @throws { Error } If options map {-o-} has unknown option.
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
  if( _.mapIs( o.remotePath ) )
  return o.remotePath;

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( o.remotePath ) );
  _.assert( !o.full || !o.atomic, 'Expects single parse algorithm' );

  /* */

  let result = Object.create( null );
  let parsed = _.uri.parseConsecutive( o.remotePath );
  _.mapExtend( result, parsed );

  if( o.full )
  result.protocols = parsed.protocols = parsed.protocol ? parsed.protocol.split( '+' ) : [];

  _.assert
  (
    !result.tag || !result.hash,
    `Remote path: ${ _.strQuote( o.remotePath ) } should contain only hash or tag, but not both.`
  );

  if( !result.tag && !result.hash )
  result.tag = 'latest';

  let [ name, localPath ] = pathIsolateGlobalAndLocal( parsed.longPath );
  result.localVcsPath = localPath;
  result.host = name || '';

  /* */

  // let parsed2 = _.mapExtend( null, parsed );
  // parsed2.protocol = null;
  // parsed2.hash = null;
  // parsed2.tag = null;
  // parsed2.longPath = name;
  // result.remoteVcsPath = path.str( parsed2 );

  // result.remoteVcsLongerPath = result.remoteVcsPath + '@' + ( result.hash || result.tag );

  /* */

  result.isFixated = _.npm.path.isFixated( result );

  result = resultFilter( result );

  return result;

  /* */

  function pathIsolateGlobalAndLocal( longPath )
  {
    let splits = _.path.split( longPath );
    if( splits[ 0 ] === '' )
    splits.splice( 0, 1 );
    return [ splits[ 0 ], splits.slice( 1 ).join( '/' ) ];
  }

  /* */

  function resultFilter( src )
  {
    if( o.full )
    return src;

    /* */

    let butMap = Object.create( null );
    butMap.longPath = null;
    butMap.isFixated = null;

    if( o.atomic )
    {
      src.isGlobal = _.strBegins( src.longPath, _.uri.rootToken );
    }
    else if( o.objects )
    {
      _.assert
      (
        !src.protocol || _.longHas( _.npm.protocols, src.protocol ), 'Parsing of objects is available only for npm paths'
      );
      _.assert( !_.strHasAny( parsed.longPath, [ 'git@', '.git' ] ), 'Parsing of objects is available only for npm paths' );
      butMap.localVcsPath = null;
    }
    else
    {
      _.assert( 0, 'Unexpected set of options' );
    }

    return _.mapDelete( src, butMap );
  }
}

parse_body.defaults =
{
  remotePath : null,
  full : 1,
  atomic : 0,
  objects : 0,
};

//

let parse = _.routineUnite( parse_head, parse_body );

//

/**
 * Routine normalize() returns normalized path for module routines.
 * Normalized path contains protocol. Normalized path is global path.
 *
 * @example
 * _.npm.path.normalize( 'wmodulefortesting1' );
 * // returns : 'npm:///wmodulefortesting1'
 *
 * @example
 * _.npm.path.normalize( 'wmodulefortesting1#0.1.101' );
 * // returns : 'npm:///wmodulefortesting1#0.1.101'
 *
 * @param { String } remotePath - A path to normalize.
 * @returns { String } - Returns normalized remote path.
 * @function normalize
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If {-remotePath-} has hash and tag simultaneously.
 * @throws { Error } If {-remotePath-} has not valid type.
 * @namespace wTools.npm.path
 * @module Tools/mid/NpmTools
 */

function normalize( remotePath )
{
  _.assert( arguments.length === 1 );
  _.assert( _.strDefined( remotePath ) );

  let parsed = _.uri.parse( remotePath );

  _.assert
  (
    !parsed.tag || !parsed.hash,
    `Remote path: ${ _.strQuote( remotePath ) } should contain only hash or tag, but not both.`
  );

  let result;
  if( parsed.protocol )
  {
    result = _.uri.normalize( remotePath );
    result = _.strReplace( result, /:\/+/, ':///' );
  }
  else
  {
    _.assert( !_.strHasAny( parsed.longPath, [ 'git@', '.git' ] ), 'Expects full git paths' );
    result = _.npm.protocols[ 0 ] + _.uri.protocolToken;
    parsed.longPath = _.uri.join( _.uri.rootToken, parsed.longPath );
    result += parsed.longPath;
    if( parsed.tag )
    result += _.uri.tagToken + parsed.tag;
    if( parsed.hash )
    result += _.uri.hashToken + parsed.hash;
  }

  return result;
}

//

/**
 * Routine nativize() returns nativized path for utility NPM.
 *
 * @example
 * _.npm.path.nativize( 'npm:///wmodulefortesting1' );
 * // returns : 'wmodulefortesting1'
 *
 * @example
 * _.npm.path.nativize( 'npm:///wmodulefortesting1#0.1.101' );
 * // returns : 'wmodulefortesting1@0.1.101'
 *
 * @param { String } remotePath - A path to nativize.
 * @returns { String } - Returns nativized remote path.
 * @function nativize
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If {-remotePath-} has hash and tag simultaneously.
 * @throws { Error } If {-remotePath-} has not valid type.
 * @namespace wTools.npm.path
 * @module Tools/mid/NpmTools
 */

function nativize( remotePath )
{
  _.assert( arguments.length === 1 );
  _.assert( _.strDefined( remotePath ) );

  let parsed = _.uri.parse( remotePath );

  _.assert
  (
    !parsed.tag || !parsed.hash,
    `Remote path: ${ _.strQuote( remotePath ) } should contain only hash or tag, but not both.`
  );

  let result;
  if( !parsed.protocol || _.longHas( _.npm.protocols, parsed.protocol ) )
  {
    _.assert( !_.strHasAny( parsed.longPath, [ 'git@', '.git' ] ), 'Expects full git paths' );
    result = parsed.host || '';
    result = _.strRemoveBegin( result, '/' );
    if( parsed.tag || parsed.hash )
    result += '@' + ( parsed.tag || parsed.hash );
  }
  else
  {
    result = _.uri.nativize( remotePath );
  }

  return result;
}

//

/**
 * Routine isFixated() returns true if remote path {-remotePath-} has fixed version of npm package.
 *
 * @example
 * _.npm.path.isFixated( 'npm:///wmodulefortesting1' );
 * // returns : false
 *
 * @example
 * _.npm.path.isFixated( 'npm:///wmodulefortesting1#0.1.101' );
 * // returns : true
 *
 * @param { String|Aux } remotePath - A path to check. Can be parsed path in an Aux container.
 * @returns { Boolean } - Returns true if remote path has fixated version, otherwise, returns false.
 * @function isFixated
 * @throws { Error } If arguments.length is not equal to 1.
 * @throws { Error } If {-remotePath-} is not a global path.
 * @throws { Error } If {-remotePath-} has hash and tag simultaneously.
 * @throws { Error } If {-remotePath-} has not valid type.
 * @namespace wTools.npm.path
 * @module Tools/mid/NpmTools
 */

function isFixated( remotePath )
{
  _.assert( arguments.length === 1, 'Expects single remote path {-remotePath-}' );

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

  normalize,
  nativize,

  isFixated,

}

_.mapExtend( Self, Extension );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();
