( function _Basic_ss_()
{

'use strict';

let _ = _global_.wTools;
let Self = _.npm = _.npm || Object.create( null );

// --
// inter
// --

/**
 * @summary Publishes a package to the npm registry.
 * {@see https://docs.npmjs.com/cli/publish}
 * @param {String} o.localPath Path to package directory.
 * @param {String} o.tag Registers the published package with the given tag.
 * @param {Object} o.ready Consequence instance.
 * @param {Number} o.verbosity Verbosity control.
 * @function publish
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

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

/**
 * @summary Fixates versions of the dependecies in provided package.
 * @param {String} o.localPath Path to package directory.
 * @param {String} o.configPath Path to package.json file.
 * @param {String} o.tag Sets specified tag to all dependecies.
 * @param {Routine} o.onDependency Callback routine executed for each dependecy. Accepts single argument - dependecy descriptor.
 * @param {Boolean} [o.dry=0] Returns generated config without making changes in package.json.
 * @param {Number} [o.verbosity=2] Verbosity control.
 * @function fixate
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

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
    self._readChangeWrite( o2 );
    _.mapExtend( o, o2 );
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

/**
 * @summary Fixates versions of the dependecies in provided config.
 * @param {Object} o.config Object representation of package.json file.
 * @param {String} o.tag Sets specified tag to all dependecies.
 * @param {Routine} o.onDependency Callback routine executed for each dependecy. Accepts single argument - dependecy descriptor.
 * @param {Number} [o.verbosity=2] Verbosity control.
 * @function structureFixate
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

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
      let r = o.onDependency( dep );
      _.assert( r === undefined );
      if( dep.version === depVersion && dep.name === depName )
      continue;
      o.changed = true;
      delete o.config[ s ][ depName ];
      if( dep.version === undefined || dep.name === undefined )
      continue;
      o.config[ s ][ dep.name ] = dep.version;
    }
  });

  return o.changed;
}

structureFixate.defaults =
{
  config : null,
  onDependency : null,
  tag : null,
}

//

/**
 * @summary Bumps package version.
 * @param {String} o.localPath Path to package directory.
 * @param {Object} o.configPath Path to package.json file.
 * @param {Routine} o.onDependency Callback routine executed for each dependecy. Accepts single argument - dependecy descriptor.
 * @param {Boolean} [o.dry=0] Returns generated config without making changes in package.json.
 * @param {Number} [o.verbosity=2] Verbosity control.
 * @function bump
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

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
    self._readChangeWrite( o2 );
    _.mapExtend( o, o2 );
  }
  catch( err )
  {
    throw _.err( err, `\nFailed to bump version of npm config ${o.configPath}` );
  }

  return o;

  function onChange( op )
  {
    let o2 = Object.create( null );
    _.mapExtend( o2, _.mapOnly( o, self.structureBump.defaults ) );
    _.mapExtend( o2, _.mapOnly( op, self.structureBump.defaults ) );
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

/**
 * @summary Bumps package version using provided config.
 * @param {Object} o.config Object representation of package.json file.
 * @function structureBump
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

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

/**
 * @summary Gets package metadata from npm registry.
 * @param {String} o.name Package name
 * @param {Boolean} [o.sync=1] Controls sync/async execution mode
 * @param {Boolean} [o.throwing=0] Controls error throwing
 * @function aboutFromRemote
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

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

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

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
  o.config = _.fileProvider.configRead( o.configPath );

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

  str = str.replace( /\s\n/mg, '\n' ) + '\n';

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

/**
 * @summary Retrieves package dependants number from npm storage.
 * @param {(string|string[])} o.remotePath Package name or array of names(the same as on npm storage).
 * @param {boolean} [o.sync=0] Controls sync/async execution mode.
 * @param {number} [o.verbosity=0] Verbosity control.
 * @returns {(number|number[])} Dependanst number for one package or array of dependants for array of packages.
 * @function dependantsRetrieve
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function dependantsRetrieve( o )
{
  const self = this;
  const prefixUri = 'https://www.npmjs.com/package/';

  let counter = 0;

  if( !_.mapIs( o ) )
  o = { remotePath : o }
  _.routineOptions( dependantsRetrieve, o );

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strsAreAll( o.remotePath ), 'Expects only strings as a package name' );

  let isSingle = !_.arrayIs( o.remotePath );
  o.remotePath = _.arrayAs( o.remotePath );

  let uri = o.remotePath.map( ( remotePath ) => uriNormalize( remotePath ) );

  let ready = _.http.retrieve
  ({
    uri,
    sync : 0,
    verbosity : o.verbosity,
    attemptLimit : o.attemptLimit,
    attemptDelay : o.attemptDelay,
    successStatus : [ 200, 404 ],
  });

  ready.then( ( responses ) =>
  {
    let result = responses.map( ( response ) => responsesHandle( response ) );
    if( isSingle )
    return result[ 0 ];
    return result;
  });

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  // debugger;

  return ready;

  /* */

  function uriNormalize( filePath )
  {
    let result;
    if( _.uri.isGlobal( filePath ) )
    {
      let parsed = self.pathParse( filePath );
      result = prefixUri + ( parsed.longPath[ 0 ] === '/' ? parsed.longPath.slice( 1 ) : parsed.longPath );
    }
    else
    {
      result = prefixUri + filePath;
    }
    return result;
  }

  /* */

  function responsesHandle( op )
  {
    let dependants = '';
    if( op.response.statusCode !== 200 )
    return NaN;

    const html = op.response.body;
    const strWithDep = html.match( /[0-9]*,?[0-9]*<\/span>Dependents/ );

    if( !strWithDep )
    return NaN;

    for( let i = strWithDep.index; html[ i ] !== '<'; i++ )
    dependants += html[ i ];
    dependants = Number( dependants.split( ',' ).join( '' ) );

    return dependants;
  }

  /* */

}

dependantsRetrieve.defaults =
{
  remotePath : null,
  sync : 0,
  verbosity : 0,
  attemptLimit : 3,
  attemptDelay : 250,
}

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
 * @property {String} remoteVcsLongerPath
 * @module Tools/mid/NpmTools
 */

/**
 * @summary Parses provided `remotePath` and returns object with components {@link module:Tools/mid/Files.wTools.FileProvider.wFileProviderNpm.RemotePathComponents}.
 * @param {String} remotePath Remote path.
 * @function pathParse
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
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
  _.assert( path.isGlobal( remotePath ) );

  /* */

  let parsed1 = path.parseConsecutive( remotePath );
  _.mapExtend( result, parsed1 );

  if( !result.tag && !result.hash )
  result.tag = 'latest';

  _.assert( !result.tag || !result.hash, 'Remote path:', _.strQuote( remotePath ), 'should contain only hash or tag, but not both.' )

  let [ name, localPath ] = pathIsolateGlobalAndLocal( parsed1.longPath );
  result.localVcsPath = localPath;

  /* */

  let parsed2 = _.mapExtend( null, parsed1 );
  parsed2.protocol = null;
  parsed2.hash = null;
  parsed2.tag = null;
  parsed2.longPath = name;
  result.remoteVcsPath = path.str( parsed2 );

  parsed2.hash = parsed1.hash;
  parsed2.tag = parsed1.tag;
  result.remoteVcsLongerPath = path.str( parsed2 );

  // /* */
  //
  // let parsed3 = _.mapExtend( null, parsed1 );
  // parsed3.longPath = parsed2.longPath;
  // parsed3.protocol = null;
  // parsed3.hash = null;
  // parsed3.tag = null;
  // result.remoteVcsLongerPath = path.str( parsed3 );
  // let version = parsed1.hash || parsed1.tag;
  // if( version )
  // result.remoteVcsLongerPath += '@' + version;

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
  remoteVcsLongerPath : 'wColor@0.3.100'
*/

  /* */

  function pathIsolateGlobalAndLocal( longPath )
  {
    // debugger;
    let splits = _.path.split( longPath );
    if( splits[ 0 ] === '' )
    splits.splice( 0, 1 );
    return [ splits[ 0 ], splits.slice( 1 ).join( '/' ) ];
    // let parsed = path.parseConsecutive( longPath );
    // let splits = _.strIsolateLeftOrAll( parsed.longPath, /^\/?\w+\/?/ );
    // parsed.longPath = _.strRemoveEnd( _.strRemoveBegin( splits[ 1 ], '/' ), '/' );
    // let globalPath = path.str( parsed );
    // return [ globalPath, splits[ 2 ] ];
  }

}

//

/**
 * @summary Returns true if remote path `filePath` has fixed version of npm package.
 * @param {String} filePath Global path.
 * @function pathIsFixated
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
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
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
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
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function versionLocalRetrive( o )
{
  let self = this;
  let path = _.uri;

  if( !_.mapIs( o ) )
  o = { localPath : o }

  _.routineOptions( versionLocalRetrive, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let ready = new _.Consequence().take( null );

  ready.then( () => self.isRepository( o ) )
  ready.then( ( isRepository ) =>
  {
    if( !isRepository )
    return '';

    return _.fileProvider.fileRead
    ({
      filePath : path.join( o.localPath, 'package.json' ),
      encoding : 'json',
      sync : 0,
    });
  })
  ready.finally( ( err, read ) =>
  {
    if( err )
    return null;
    if( _.strIs( read ) )
    return read;
    if( !read.version )
    return null;
    return read.version;
  })

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;
}

var defaults = versionLocalRetrive.defaults = Object.create( null );
defaults.localPath = null;
defaults.sync = 1;
defaults.verbosity = 0;

//

/**
 * @summary Returns latest version of npm package using its remote path `o.remotePath`.
 * @param {Object} o Options map.
 * @param {String} o.remotePath Remote path.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function versionRemoteLatestRetrive
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function versionRemoteLatestRetrive( o )
{
  let self = this;
  let path = _.uri;

  if( !_.mapIs( o ) )
  o = { remotePath : o }

  _.routineOptions( versionRemoteLatestRetrive, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let ready = new _.Consequence().take( null );
  let shell = _.process.starter
  ({
    verbosity : o.verbosity - 1,
    outputCollecting : 1,
    sync : 0,
    deasync : 0,
  });
  let parsed = null;

  ready.then( () =>
  {
    parsed = self.pathParse( o.remotePath );
    return shell( 'npm show ' + parsed.remoteVcsPath );
  })
  ready.then( ( got ) =>
  {
    let latestVersion = /latest.*?:.*?([0-9\.][0-9\.][0-9\.]+)/.exec( got.output );
    if( !latestVersion )
    {
      debugger;
      throw _.err( 'Failed to get information about NPM package', parsed.remoteVcsPath );
    }
    latestVersion = latestVersion[ 1 ];

    return latestVersion;
  })

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;
}

var defaults = versionRemoteLatestRetrive.defaults = Object.create( null );
defaults.remotePath = null;
defaults.sync = 1;
defaults.verbosity = 0;

//

/**
 * @summary Returns current version of npm package using its remote path `o.remotePath`.
 * @description Returns latest version if no version specified in remote path.
 * @param {Object} o Options map.
 * @param {String} o.remotePath Remote path.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function versionRemoteCurrentRetrive
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function versionRemoteCurrentRetrive( o )
{
  let self = this;
  let path = _.uri;

  if( !_.mapIs( o ) )
  o = { remotePath : o }

  _.routineOptions( versionRemoteCurrentRetrive, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let ready = new _.Consequence().take( null );

  ready.then( () =>
  {
    let parsed = self.pathParse( o.remotePath );
    if( parsed.isFixated )
    return parsed.hash;
    return self.versionRemoteLatestRetrive( o );
  })

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;
}

var defaults = versionRemoteCurrentRetrive.defaults = Object.create( null );
defaults.remotePath = null;
defaults.sync = 1;
defaults.verbosity = 0;

//

function versionRemoteRetrive( o )
{
  let self = this;
  let path = _.uri;

  if( !_.mapIs( o ) )
  o = { remotePath : o }

  _.routineOptions( versionRemoteLatestRetrive, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let ready = new _.Consequence().take( null );
  let shell = _.process.starter
  ({
    verbosity : o.verbosity - 1,
    outputCollecting : 1,
    sync : 0,
    deasync : 0,
  });

  ready.then( () =>
  {
    let parsed = self.pathParse( o.remotePath );
    return shell( 'npm show ' + parsed.remoteVcsLongerPath + ' version' );
  })
  ready.then( ( got ) =>
  {
    let version = _.strStrip( got.output );
    return version;
  })

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;
}

var defaults = versionRemoteRetrive.defaults = Object.create( null );
defaults.remotePath = null;
defaults.sync = 1;
defaults.verbosity = 0;

//

/**
 * @summary Returns true if local copy of package `o.localPath` is up to date with remote version `o.remotePath`.
 * @param {Object} o Options map.
 * @param {String} o.localPath Local path to package.
 * @param {String} o.remotePath Remote path to package.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function isUpToDate
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function isUpToDate( o )
{
  let self = this;
  let path = _.uri;

  _.routineOptions( isUpToDate, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let parsed = self.pathParse( o.remotePath );

  let ready = new _.Consequence().take( null );

  ready.then( () => self.versionLocalRetrive({ localPath : o.localPath, verbosity : o.verbosity, sync : 0 }) )
  ready.then( ( currentVersion ) =>
  {
    if( !currentVersion )
    return false;

    if( parsed.hash === currentVersion )
    return true;

    return self.versionRemoteRetrive({ remotePath : o.remotePath, verbosity : o.verbosity, sync : 0 })
    .then( ( latestVersion ) => currentVersion === latestVersion )
  })

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;
}

var defaults = isUpToDate.defaults = Object.create( null );
defaults.localPath = null;
defaults.remotePath = null;
defaults.sync = 1;
defaults.verbosity = 0;

//

/**
 * @summary Returns true if path `o.localPath` contains npm package.
 * @param {Object} o Options map.
 * @param {String} o.localPath Local path to package.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function hasFiles
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function hasFiles( o )
{
  let localProvider = _.fileProvider;

  _.routineOptions( hasFiles, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( !localProvider.isDir( o.localPath ) )
  return false;
  if( !localProvider.dirIsEmpty( o.localPath ) )
  return true;

  return false;
}

var defaults = hasFiles.defaults = Object.create( null );
defaults.localPath = null;
defaults.verbosity = 0;

//

/**
 * @summary Returns true if path `o.localPath` contains a package.
 * @param {Object} o Options map.
 * @param {String} o.localPath Local path to package.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function isRepository
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function isRepository( o )
{
  let self = this;
  let path = _.uri;

  _.routineOptions( isRepository, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let ready = _.Consequence.Try( () =>
  {
    if( !_.fileProvider.fileExists( o.localPath ) )
    return false;

    // if( !localProvider.isDir( path.join( o.localPath, 'node_modules' ) ) )
    // return false;

    if( !_.fileProvider.isTerminal( path.join( o.localPath, 'package.json' ) ) )
    return false;

    return true;
  })

  if( o.sync )
  return ready.syncMaybe();

  return ready;
}

var defaults = isRepository.defaults = Object.create( null );
defaults.localPath = null;
defaults.sync = 1;
defaults.verbosity = 0;

//

/**
 * @summary Returns true if path `o.localPath` contains a npm package that was installed from remote `o.remotePath`.
 * @param {Object} o Options map.
 * @param {String} o.localPath Local path to package.
 * @param {String} o.remotePath Remote path to package.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function hasRemote
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function hasRemote( o )
{
  let self = this;
  let localProvider = _.fileProvider;
  let path = localProvider.path;

  _.routineOptions( hasRemote, o );
  _.assert( arguments.length === 1, 'Expects single argument' );
  _.assert( _.strDefined( o.localPath ) );
  _.assert( _.strDefined( o.remotePath ) );

  let ready = new _.Consequence().take( null );

  ready.then( () =>
  {
    let result = Object.create( null );
    result.downloaded = true;
    result.remoteIsValid = false;

    if( !localProvider.fileExists( o.localPath ) )
    {
      result.downloaded = false;
      return result;
    }

    let configPath = path.join( o.localPath, 'package.json' );
    let configExists = localProvider.fileExists( configPath );

    if( !configExists )
    {
      result.downloaded = false;
      return result;
    }

    let config = localProvider.configRead( configPath );
    let remoteVcsPath = self.pathParse( o.remotePath ).remoteVcsPath;
    let originVcsPath = config.name;

    _.sure( _.strDefined( remoteVcsPath ) );
    _.sure( _.strDefined( originVcsPath ) );

    result.remoteVcsPath = remoteVcsPath;
    result.originVcsPath = originVcsPath;
    result.remoteIsValid = originVcsPath === remoteVcsPath;

    return result;
  })

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;
}

var defaults = hasRemote.defaults = Object.create( null );
defaults.localPath = null;
defaults.remotePath = null;
defaults.sync = 1;
defaults.verbosity = 0;

//

function hasLocalChanges( o )
{
  if( _.objectIs( o ) )
  if( o.sync !== undefined )
  {
    if( o.sync )
    return false;
    else
    return new _.Consequence().take( false );
  }
  return false;
}

// --
// declare
// --

let Extend =
{

  protocols : [ 'npm' ],

  publish,

  fixate, /* qqq : cover please */
  structureFixate, /* qqq : cover please */
  bump, /* qqq : cover please */
  structureBump, /* qqq : cover please */

  aboutFromRemote,

  _readChangeWrite,

  dependantsRetrieve,

  // vcs

  pathParse,
  pathIsFixated,
  pathFixate,
  versionLocalRetrive,
  versionRemoteLatestRetrive,
  versionRemoteCurrentRetrive,
  versionRemoteRetrive,
  isUpToDate,
  hasFiles,
  isRepository,
  hasRemote,

  hasLocalChanges,

}

_.mapExtend( Self, Extend );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

} )();
