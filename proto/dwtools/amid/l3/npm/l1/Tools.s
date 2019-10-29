( function _Tools_s_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  require( '../IncludeBase.s' );

}

let _ = _global_.wTools;
let Self = _.npm = _.npm || Object.create( null );

// --
// inter
// --

function publish( o )
{
  let self = this;

  _.routineOptions( publish, arguments );
  if( !o.verbosity || o.verbosity < 0 )
  o.verbosity = 0;

  _.assert( _.path.isAbsolute( o.localPath ), 'Expects local path' );
  _.assert( _.strDefined( o.tag ), 'Expects tag' );

  if( !o.ready )
  o.ready = new _.Consequence().take( null );

  let start = _.process.starter
  ({
    currentPath : o.localPath,
    outputCollecting : 1,
    outputGraying : 1,
    outputPiping : o.verbosity >= 2,
    inputMirroring : o.verbosity >= 2,
    mode : 'shell',
    ready : o.ready
  });

  return start( `npm publish --tag ${o.tag}` )
  .finally( ( err, arg ) =>
  {
    if( err )
    throw _.err( err, `\nFailed publish ${o.localPath} with tag ${o.tag}` );
    return arg;
  });
}

publish.defaults =
{
  localPath : null,
  tag : null,
  ready : null,
  verbosity : 0,
}

//

function fixate( o )
{
  let self = this;

  o = _.routineOptions( fixate, o );
  if( !o.verbosity || o.verbosity < 0 )
  o.verbosity = 0;

  try
  {
    let o2 = _.mapOnly( _.mapExtend( null, o ), self._readChangeWrite.defaults );
    o2.onChange = onChange;
    o.changed = self._readChangeWrite( o2 );
    o.config = o.config;
    return o;
  }
  catch( err )
  {
    throw _.err( err, `\nFailed to bump version of npm config ${o.configPath}` );
  }

  function onChange( op )
  {
    let o2 = Object.create( null );
    _.mapExtend( o2, _.mapOnly( o, self.structureFixate.defaults ) );
    _.mapExtend( o2, _.mapOnly( op, self.structureFixate.defaults ) );
    self.structureFixate( o2 );
    return o2.changed;
  }

}

fixate.defaults =
{
  localPath : null,
  configPath : null,
  onDependency : null,
  dry : 0,
  tag : null,
  verbosity : 0,
}

//

function structureFixate( o )
{

  let dependencySectionsNames =
  [
    'dependencies',
    'devDependencies',
    'optionalDependencies',
    'bundledDependencies',
    'peerDependencies',
  ];

  o = _.routineOptions( structureFixate, o );
  o.changed = false;

  if( !o.onDependency )
  o.onDependency = function onDependency( dep )
  {
    dep.version = o.tag;
  }

  _.assert( _.strDefined( o.tag ) );

  dependencySectionsNames.forEach( ( s ) =>
  {
    if( o.config[ s ] )
    for( let depName in o.config[ s ] )
    {
      let depVersion = o.config[ s ][ depName ];
      let dep = Object.create( null );
      dep.name = depName;
      dep.version = depVersion;
      dep.config = o.config;
      if( dep.version )
      continue;
      // if( o.onDependency )
      // if( !o.onDependency( dep ) )
      // continue;
      let r = o.onDependency( dep );
      _.assert( r === undefined );
      if( dep.version === depVersion && dep.name === depName )
      continue;
      o.changed = true;
      delete o.config[ s ][ depName ];
      if( dep.version === undefined || dep.name === undefined )
      continue;
      o.config[ s ][ dep.name ] = dep.version;
      // o.config[ s ][ depName ] = depVersionPatch( dep );
      // o.config[ s ][ depName ] = depVersionPatch( dep );
    }
  });

  return o.changed;

  // function depVersionPatch( dep )
  // {
  //   return o.tag;
  // }

}

structureFixate.defaults =
{
  config : null,
  onDependency : null,
  tag : null,
}

//

function bump( o )
{
  let self = this;

  o = _.routineOptions( bump, o );
  if( !o.verbosity || o.verbosity < 0 )
  o.verbosity = 0;

  try
  {
    let o2 = _.mapOnly( _.mapExtend( null, o ), self._readChangeWrite.defaults );
    o2.onChange = onChange;
    o.changed = self._readChangeWrite( o2 );
    o.config = o.config;
  }
  catch( err )
  {
    throw _.err( err, `\nFailed to bump version of npm config ${o.configPath}` );
  }

  return o;

  function onChange( op )
  {
    let o2 = Object.create( null );
    _.mapExtend( o2, _.mapOnly( o, self.structureFixate.defaults ) );
    _.mapExtend( o2, _.mapOnly( op, self.structureFixate.defaults ) );
    self.structureBump( o2 );
    return o2.changed;
  }

}

bump.defaults =
{
  localPath : null,
  configPath : null,
  dry : 0,
  verbosity : 0,
}

//

function structureBump( o )
{

  let dependencySectionsNames =
  [
    'dependencies',
    'devDependencies',
    'optionalDependencies',
    'bundledDependencies',
    'peerDependencies',
  ];

  o = _.routineOptions( structureBump, o );
  o.changed = false;

  let version = o.config.version || '0.0.0';
  let versionArray = version.split( '.' );
  versionArray[ 2 ] = Number( versionArray[ 2 ] );
  _.sure( _.intIs( versionArray[ 2 ] ), `Cant deduce current version : ${version}` );

  versionArray[ 2 ] += 1;
  version = versionArray.join( '.' );

  o.changed = true;
  o.config.version = version;

  return version;

  function depVersionPatch( dep )
  {
    return o.tag;
  }

}

structureBump.defaults =
{
  config : null,
}

//

function aboutFromRemote( o )
{
  let self = this;
  let PackageJson = require( 'package-json' );

  if( _.strIs( arguments[ 0 ] ) )
  o = { name : arguments[ 0 ] }
  o = _.routineOptions( aboutFromRemote, o );

  let ready = _.Consequence.From( PackageJson( o.name, { fullMetadata : true } ) );

  ready.then( ( record ) =>
  {
    // debugger;
    // console.log( record.author )
    // return null;
    // debugger;
    return record;
  });

  ready.catch( ( err ) =>
  {
    debugger;
    if( !o.throwing )
    {
      _.errAttend( err );
      return null;
    }
    throw _.err( err, `\nFailed to get information about remote module ${name}` );
  });

  // debugger;
  if( o.sync )
  return ready.deasync();

  return ready;
}

aboutFromRemote.defaults =
{
  name : null,
  sync : 1,
  throwing : 0,
}

//

function _readChangeWrite( o )
{
  let self = this;

  o = _.routineOptions( _readChangeWrite, o );
  if( !o.verbosity || o.verbosity < 0 )
  o.verbosity = 0;

  if( !o.configPath )
  o.configPath = _.path.join( o.localPath, 'package.json' );
  o.config = _.fileProvider.fileConfigRead( o.configPath );

  o.changed = o.onChange( o );

  _.assert( _.boolIs( o.changed ) );
  if( !o.changed )
  return o;

  let str = null;
  let encoder = _.Gdf.Select
  ({
    in : 'structure',
    out : 'string',
    ext : 'json',
  })[ 1 ]; /* xxx : workaround */
  _.assert( !!encoder, `No encoder` );
  str = encoder.encode({ data : o.config }).data;

  if( o.verbosity >= 2 )
  logger.log( str );

  if( o.dry )
  return o;

  if( str )
  _.fileProvider.fileWrite( o.configPath, str );
  else
  _.fileProvider.fileWrite( o.configPath, o.config );

  return o;
}

_readChangeWrite.defaults =
{
  localPath : null,
  configPath : null,
  dry : 0,
  verbosity : 0,
  onChange : null,
}

//

// --
// path
// --

/**
 * @typedef {Object} RemotePathComponents
 * @property {String} protocol
 * @property {String} hash
 * @property {String} longPath
 * @property {String} localVcsPath
 * @property {String} remoteVcsPath
 * @property {String} longerRemoteVcsPath
 * @memberof module:Tools/mid/Files.wTools.FileProvider.wFileProviderNpm
 */

/**
 * @summary Parses provided `remotePath` and returns object with components {@link module:Tools/mid/Files.wTools.FileProvider.wFileProviderNpm.RemotePathComponents}.
 * @param {String} remotePath Remote path.
 * @function pathParse
 * @memberof module:Tools/mid/Files.wTools.FileProvider.wFileProviderNpm#
 */

function pathParse( remotePath )
{
  let self = this;
  let path = _.uri;
  let result = Object.create( null );

  if( _.mapIs( remotePath ) )
  return remotePath;

  _.assert( arguments.length === 1 );
  _.assert( _.strIs( remotePath ) );
  _.assert( path.isGlobal( remotePath ) )

  /* */

  let parsed1 = path.parseConsecutive( remotePath );
  _.mapExtend( result, parsed1 );

  let p = pathIsolateGlobalAndLocal( parsed1.longPath );
  result.localVcsPath = p[ 1 ];

  /* */

  let parsed2 = _.mapExtend( null, parsed1 );
  parsed2.protocol = null;
  parsed2.hash = null;
  parsed2.longPath = p[ 0 ];
  result.remoteVcsPath = path.str( parsed2 );

  /* */

  let parsed3 = _.mapExtend( null, parsed1 );
  parsed3.longPath = parsed2.longPath;
  parsed3.protocol = null;
  parsed3.hash = null;
  result.longerRemoteVcsPath = path.str( parsed3 );
  if( parsed1.hash )
  result.longerRemoteVcsPath += '@' + parsed1.hash;

  /* */

  result.isFixated = self.pathIsFixated( result );

  return result

/*

  remotePath : 'npm:///wColor/out/wColor#0.3.100'

  protocol : 'npm',
  hash : '0.3.100',
  longPath : '/wColor/out/wColor',
  localVcsPath : 'out/wColor',
  remoteVcsPath : 'wColor',
  longerRemoteVcsPath : 'wColor@0.3.100'

*/

  /* */

  function pathIsolateGlobalAndLocal( longPath )
  {
    let parsed = path.parseConsecutive( longPath );
    let splits = _.strIsolateLeftOrAll( parsed.longPath, /^\/?\w+\/?/ );
    parsed.longPath = _.strRemoveEnd( _.strRemoveBegin( splits[ 1 ], '/' ), '/' );
    let globalPath = path.str( parsed );
    return [ globalPath, splits[ 2 ] ];
  }

}

//

/**
 * @summary Returns true if remote path `filePath` has fixed version of npm package.
 * @param {String} filePath Global path.
 * @function pathIsFixated
 * @memberof module:Tools/mid/Files.wTools.FileProvider.wFileProviderNpm#
 */

function pathIsFixated( filePath )
{
  let self = this;
  let path = _.uri;
  let parsed = self.pathParse( filePath );

  if( !parsed.hash )
  return false;

  return true;
}

//

/**
 * @summary Changes version of package specified in path `o.remotePath` to latest available.
 * @param {Object} o Options map.
 * @param {String} o.remotePath Remote path.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function pathIsFixated
 * @memberof module:Tools/mid/Files.wTools.FileProvider.wFileProviderNpm#
 */

function pathFixate( o )
{
  let self = this;
  let path = _.uri;

  if( !_.mapIs( o ) )
  o = { remotePath : o }
  _.routineOptions( pathFixate, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let parsed = self.pathParse( o.remotePath );
  let latestVersion = self.versionRemoteLatestRetrive
  ({
    remotePath : o.remotePath,
    verbosity : o.verbosity,
  });

  let result = path.str
  ({
    protocol : parsed.protocol,
    longPath : parsed.longPath,
    hash : latestVersion,
  });

  return result;
}

var defaults = pathFixate.defaults = Object.create( null );
defaults.remotePath = null;
defaults.verbosity = 0;

//

/**
 * @summary Returns version of npm package located at `o.localPath`.
 * @param {Object} o Options map.
 * @param {String} o.localPath Path to npm package on hard drive.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function versionLocalRetrive
 * @memberof module:Tools/mid/Files.wTools.FileProvider.wFileProviderNpm#
 */

function versionLocalRetrive( o )
{
  let self = this;
  let path = _.uri;

  if( !_.mapIs( o ) )
  o = { localPath : o }

  _.routineOptions( versionLocalRetrive, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( !!self.system );

  if( !self.isDownloaded( o ) )
  return '';

  let localProvider = self.system.providerForPath( o.localPath );

  _.assert( localProvider instanceof _.FileProvider.HardDrive || localProvider.originalFileProvider instanceof _.FileProvider.HardDrive, 'Support only downloading on hard drive' );

  let currentVersion;
  try
  {
    let read = localProvider.fileRead({ filePath : path.join( o.localPath, 'package.json' ), encoding : 'json' });
    currentVersion = read.version;
  }
  catch( err )
  {
    debugger;
    return null;
  }

  return currentVersion || null;
}

var defaults = versionLocalRetrive.defaults = Object.create( null );
defaults.localPath = null;
defaults.verbosity = 0;

//

/**
 * @summary Returns latest version of npm package using its remote path `o.remotePath`.
 * @param {Object} o Options map.
 * @param {String} o.remotePath Remote path.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function versionRemoteLatestRetrive
 * @memberof module:Tools/mid/Files.wTools.FileProvider.wFileProviderNpm#
 */

function versionRemoteLatestRetrive( o )
{
  let self = this;
  let path = _.uri;

  if( !_.mapIs( o ) )
  o = { remotePath : o }

  _.routineOptions( versionRemoteLatestRetrive, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( !!self.system );

  let parsed = self.pathParse( o.remotePath );
  let shell = _.process.starter
  ({
    verbosity : o.verbosity - 1,
    outputCollecting : 1,
    sync : 1,
    deasync : 0,
  });

  let got = shell( 'npm show ' + parsed.remoteVcsPath );
  let latestVersion = /latest.*?:.*?([0-9\.][0-9\.][0-9\.]+)/.exec( got.output );

  if( !latestVersion )
  {
    debugger;
    throw _.err( 'Failed to get information about NPM package', parsed.remoteVcsPath );
  }

  latestVersion = latestVersion[ 1 ];

  return latestVersion;
}

var defaults = versionRemoteLatestRetrive.defaults = Object.create( null );
defaults.remotePath = null;
defaults.verbosity = 0;

//

/**
 * @summary Returns current version of npm package using its remote path `o.remotePath`.
 * @description Returns latest version if no version specified in remote path.
 * @param {Object} o Options map.
 * @param {String} o.remotePath Remote path.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function versionRemoteCurrentRetrive
 * @memberof module:Tools/mid/Files.wTools.FileProvider.wFileProviderNpm#
 */

function versionRemoteCurrentRetrive( o )
{
  let self = this;
  let path = _.uri;

  if( !_.mapIs( o ) )
  o = { remotePath : o }

  _.routineOptions( versionRemoteCurrentRetrive, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( !!self.system );

  let parsed = self.pathParse( o.remotePath );
  if( parsed.isFixated )
  return parsed.hash;

  return self.versionRemoteLatestRetrive( o );
}

var defaults = versionRemoteCurrentRetrive.defaults = Object.create( null );
defaults.remotePath = null;
defaults.verbosity = 0;

//

/**
 * @summary Returns true if local copy of package `o.localPath` is up to date with remote version `o.remotePath`.
 * @param {Object} o Options map.
 * @param {String} o.localPath Local path to package.
 * @param {String} o.remotePath Remote path to package.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function isUpToDate
 * @memberof module:Tools/mid/Files.wTools.FileProvider.wFileProviderNpm#
 */

function isUpToDate( o )
{
  let self = this;
  let path = _.uri;

  _.routineOptions( isUpToDate, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( !!self.system );

  let parsed = self.pathParse( o.remotePath );

  let currentVersion = self.versionLocalRetrive
  ({
    localPath : o.localPath,
    verbosity : o.verbosity,
  });

  if( !currentVersion )
  return false;

  if( parsed.hash === currentVersion )
  return true;

  let latestVersion = self.versionRemoteLatestRetrive
  ({
    remotePath : o.remotePath,
    verbosity : o.verbosity,
  });

  return currentVersion === latestVersion;
}

var defaults = isUpToDate.defaults = Object.create( null );
defaults.localPath = null;
defaults.remotePath = null;
defaults.verbosity = 0;

//

/**
 * @summary Returns true if path `o.localPath` contains a package.
 * @param {Object} o Options map.
 * @param {String} o.localPath Local path to package.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function isDownloaded
 * @memberof module:Tools/mid/Files.wTools.FileProvider.wFileProviderNpm#
 */

function isDownloaded( o )
{
  let self = this;
  let path = _.uri;

  _.routineOptions( isDownloaded, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( !!self.system );

  let srcCurrentPath;
  let localProvider = self.system.providerForPath( o.localPath );

  _.assert( localProvider instanceof _.FileProvider.HardDrive || localProvider.originalFileProvider instanceof _.FileProvider.HardDrive, 'Support only downloading on hard drive' );

  if( !localProvider.fileExists( o.localPath ) )
  return false;

  // if( !localProvider.isDir( path.join( o.localPath, 'node_modules' ) ) )
  // return false;

  if( !localProvider.isTerminal( path.join( o.localPath, 'package.json' ) ) )
  return false;

  return true;
}

var defaults = isDownloaded.defaults = Object.create( null );
defaults.localPath = null;
defaults.verbosity = 0;

// --
// relations
// --

// --
// declare
// --

let Extend =
{

  publish,

  fixate,
  structureFixate,
  bump,
  structureBump,

  aboutFromRemote,

  _readChangeWrite,

  // vcs

  pathParse,
  pathIsFixated,
  pathFixate,
  versionLocalRetrive,
  versionRemoteLatestRetrive,
  versionRemoteCurrentRetrive,
  isUpToDate,
  isDownloaded,

}

_.mapExtend( Self, Extend );

//

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = _global_.wTools;

})();
