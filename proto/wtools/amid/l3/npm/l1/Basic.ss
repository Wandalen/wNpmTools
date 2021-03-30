( function _Basic_ss_()
{

'use strict';

const _ = _global_.wTools;
const Self = _.npm = _.npm || Object.create( null );

// --
// meta
// --

function _readChangeWrite( o )
{
  let self = this;

  o = _.routineOptions( _readChangeWrite, o );
  if( !o.verbosity || o.verbosity < 0 )
  o.verbosity = 0;

  if( !o.configPath )
  o.configPath = self.pathConfigFromLocal( o.localPath );
  o.config = _.fileProvider.configRead( o.configPath );

  o.changed = o.onChange( o );

  _.assert( _.boolIs( o.changed ) );
  if( !o.changed )
  return o;

  /* qqq : for Dmytro : use routine for adjusting formatting here. introduce option */

  let encoder = _.gdf.selectSingleContext
  ({
    inFormat : 'structure',
    outFormat : 'string',
    ext : 'json',
    feature : { fine : 1 },
  })

  let str = encoder.encode({ data : o.config }).out.data;

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

function _readChangeWrite_functor( fo )
{

  if( !_.mapIs( fo ) )
  fo = { onChange : arguments[ 0 ], name : arguments[ 1 ] }

  fo = _.routineOptions( _readChangeWrite_functor, fo );
  fo.head = fo.head || head;
  fo.body = fo.body || body;

  const name = fo.name;
  const onChange = fo.onChange;
  _.assert( _.strDefined( name ) );
  _.assert( _.routineIs( onChange ) );
  _.assert( _.aux.is( fo.onChange.defaults ) );
  _.assert( fo.onChange.defaults.config !== undefined );

  if( !fo.body.defaults && fo.onChange.defaults )
  fo.body.defaults = _.mapExtend( null, fo.onChange.defaults )
  let defaults2 = Object.create( null );
  defaults2.verbosity = 0;
  defaults2.dry = 0;
  defaults2.localPath = null;
  defaults2.configPath = null;
  _.mapSupplement( fo.body.defaults, defaults2 )

  return _.routine.unite
  ({
    head : fo.head,
    body : fo.body,
  });

  function head( routine, args )
  {
    let o = _.routineOptions( routine, args );
    if( routine.defaults.verbosity !== undefined )
    if( !o.verbosity || o.verbosity < 0 )
    o.verbosity = 0;
    return o;
  }

  function body( o )
  {
    let self = this;

    try
    {
      let o2 = _.mapOnly_( null, o, self._readChangeWrite.defaults );
      o2.onChange = onChangeCall;
      self._readChangeWrite( o2 );
      _.mapExtend( o, o2 );
      return o;
    }
    catch( err )
    {
      throw _.err( err, `\nFailed to ${name} version of npm config ${o.configPath}` );
    }

    function onChangeCall( op )
    {
      let o2 = Object.create( null );
      _.mapOnly_( o2, o, onChange.defaults );
      _.mapOnly_( o2, op, onChange.defaults );
      onChange.call( self, o2 );
      return o2.changed;
    }
  }

}

_readChangeWrite_functor.defaults =
{
  head : null,
  body : null,
  onChange : null,
  name : null,
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
 * @summary Parses provided `remotePath` and returns object with components {@link module:Tools/mid/Files.wTools.FileProvider.Npm.RemotePathComponents}.
 * @param {String} remotePath Remote path.
 * @function pathParse
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function pathParse( remotePath ) /* xxx : rename into pathAnalyze() */
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

  // parsed2.hash = parsed1.hash;
  // parsed2.tag = parsed1.tag;
  result.remoteVcsLongerPath = result.remoteVcsPath + '@' + ( result.hash || result.tag );
  // result.remoteVcsLongerPath = self.pathNativize(  );

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

  // result.isFixated = self.pathIsFixated( result );
  result.isFixated = _.npm.path.isFixated( result );

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

function pathNativize( remotePath )
{

  _.assert( arguments.length === 1 );
  _.assert( _.strDefined( remotePath ) );

  let parsedPath = _.uri.parseFull( remotePath );

  let result = parsedPath.longPath;

  if( parsedPath.hash || parsedPath.tag )
  result += '@' + ( parsedPath.hash || parsedPath.tag );

  return result;
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
  // let parsed = self.pathParse( filePath );
  let parsed = _.npm.path.parse( filePath );

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

  // let parsed = self.pathParse( o.remotePath );
  let parsed = _.npm.path.parse( o.remotePath );
  let latestVersion = self.remoteVersionLatest
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

function pathConfigFromLocal( localPath )
{
  return _.path.join( localPath, 'package.json' );
}

//

function pathLocalFromConfig( configPath )
{
  _.assert( _.path.fullName( configPath ) === 'package.json' );
  return _.path.dir( configPath );
}

//

/* xxx : qqq : implement and use similar routine for git */
function pathDownloadFromLocal( localPath )
{
  return _.path.join( localPath, 'node_modules' );
}

//

function pathLocalFromDownload( configPath )
{
  _.assert( _.path.fullName( configPath ) === 'node_modules' );
  return _.path.dir( configPath );
}

// --
// write l2
// --

/* qqq : for Dmytro : bad : lack of routine _.npm.structureFormat() ! */
function format( o )
{
  _.assert( arguments.length === 1, 'Expects single options map {-o-}' );
  _.assert( _.strDefined( o.filePath ), 'Expects path to JSON file {-o.filePath-}' );

  const fileProvider = _.fileProvider;
  let config = fileProvider.configRead({ filePath : o.filePath, encoding : 'json' });
  config = regularDependenciesSort( config );
  fileProvider.fileWrite( o.filePath, JSON.stringify( config, null, '  ' ) + '\n' );
  return true;

  /* */

  function regularDependenciesSort( config )
  {
    const dependencies =
    [
      'dependencies',
      'devDependencies',
      'optionalDependencies',
      'peerDependencies',
    ];
    for( let i = 0; i < dependencies.length; i++ )
    if( config[ dependencies[ i ] ] )
    {
      const src = config[ dependencies[ i ] ];
      const result = Object.create( null );
      const keys = _.mapKeys( src );
      keys.sort( sortElements );

      for( let i = 0; i < keys.length; i++ )
      result[ keys[ i ] ] = src[ keys[ i ] ];

      config[ dependencies[ i ] ] = result;
    }

    return config;
  }

  /* */

  function sortElements( a, b )
  {
    return a.toLowerCase().localeCompare( b.toLowerCase() );
  }
}

format.defaults = Object.create( null );
format.defaults.filePath = null;

//

/**
 * @summary Fixates versions of the dependencies in provided config.
 * @param {Object} o.config Object representation of package.json file.
 * @param {String} o.tag Sets specified tag to all dependencies.
 * @param {Routine} o.onDep Callback routine executed for each dependecy. Accepts single argument - dependecy descriptor.
 * @param {Number} [o.verbosity=2] Verbosity control.
 * @function structureFixate
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function structureFixate( o )
{

  // let depSectionsNames =
  // [
  //   'dependencies',
  //   'devDependencies',
  //   'optionalDependencies',
  //   'bundledDependencies',
  //   'peerDependencies',
  // ];

  o = _.routineOptions( structureFixate, o );
  o.changed = false;

  if( !o.onDep )
  o.onDep = function onDep( dep )
  {
    dep.version = o.tag;
  }

  _.assert( _.strDefined( o.tag ) );

  this.DepSectionsNames.forEach( ( s ) =>
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
      let r = o.onDep( dep );
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
  onDep : null,
  tag : null,
}

//

/**
 * @summary Fixates versions of the dependencies in provided package.
 * @param {String} o.localPath Path to package directory.
 * @param {String} o.configPath Path to package.json file.
 * @param {String} o.tag Sets specified tag to all dependencies.
 * @param {Routine} o.onDep Callback routine executed for each dependecy. Accepts single argument - dependecy descriptor.
 * @param {Boolean} [o.dry=0] Returns generated config without making changes in package.json.
 * @param {Number} [o.verbosity=2] Verbosity control.
 * @function fixate
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

const fixate = _readChangeWrite_functor( structureFixate, 'fixate' );

var defaults = fixate.defaults;
_.assert( defaults === fixate.body.defaults );
_.assert( defaults !== structureFixate.defaults );
_.assert( defaults.onDep !== undefined );

// function fixate( o )
// {
//   let self = this;
//
//   o = _.routineOptions( fixate, o );
//   if( !o.verbosity || o.verbosity < 0 )
//   o.verbosity = 0;
//
//   try
//   {
//     let o2 = _.mapOnly_( null, o, self._readChangeWrite.defaults );
//     o2.onChange = onChange;
//     self._readChangeWrite( o2 );
//     _.mapExtend( o, o2 );
//     return o;
//   }
//   catch( err )
//   {
//     throw _.err( err, `\nFailed to bump version of npm config ${o.configPath}` );
//   }
//
//   function onChange( op )
//   {
//     let o2 = Object.create( null );
//     _.mapOnly_( o2, o, self.structureFixate.defaults );
//     _.mapOnly_( o2, op, self.structureFixate.defaults );
//     self.structureFixate( o2 );
//     return o2.changed;
//   }
//
// }
//
// fixate.defaults =
// {
//   localPath : null,
//   configPath : null,
//   onDep : null,
//   dry : 0,
//   tag : null,
//   verbosity : 0,
// }

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
 * @summary Bumps package version.
 * @param {String} o.localPath Path to package directory.
 * @param {Object} o.configPath Path to package.json file.
 * @param {Routine} o.onDep Callback routine executed for each dependecy. Accepts single argument - dependecy descriptor.
 * @param {Boolean} [o.dry=0] Returns generated config without making changes in package.json.
 * @param {Number} [o.verbosity=2] Verbosity control.
 * @function bump
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

// function bump( o )
// {
//   let self = this;
//
//   o = _.routineOptions( bump, o );
//   if( !o.verbosity || o.verbosity < 0 )
//   o.verbosity = 0;
//   try
//   {
//     let o2 = _.mapOnly_( null, o, self._readChangeWrite.defaults );
//     o2.onChange = onChange;
//     self._readChangeWrite( o2 );
//     _.mapExtend( o, o2 );
//   }
//   catch( err )
//   {
//     throw _.err( err, `\nFailed to bump version of npm config ${o.configPath}` );
//   }
//
//   return o;
//
//   function onChange( op )
//   {
//     let o2 = Object.create( null );
//     _.mapOnly_( o2, o, self.structureBump.defaults );
//     _.mapOnly_( o2, op, self.structureBump.defaults );
//     self.structureBump( o2 );
//     return o2.changed;
//   }
//
// }
//
// bump.defaults =
// {
//   localPath : null,
//   configPath : null,
//   dry : 0,
//   verbosity : 0,
// }

const bump = _readChangeWrite_functor( structureBump, 'bump' );

// var defaults = bump.defaults;
// defaults.verbosity = 0;
// defaults.dry = 0;
// defaults.localPath = null;
// defaults.configPath = null;

//

function structureDepRemove( o )
{
  let self = this;

  if( !_.mapIs( o ) )
  o = { localPath : arguments[ 0 ], depPath : arguments[ 1 ] }
  o = _.routineOptions( structureDepRemove, o );



}

structureDepRemove.defaults =
{
  config : null,
  depPath : null,
  kind : null,
}

const depRemove = _readChangeWrite_functor( structureDepRemove, 'depRemove' );

// //
//
// function depRemove()
// {
//   let self = this;
//
//   if( !_.mapIs( o ) )
//   o = { localPath : arguments[ 0 ], depPath : arguments[ 1 ] }
//   o = _.routineOptions( depRemove, o );
//   if( !o.verbosity || o.verbosity < 0 )
//   o.verbosity = 0;
//
//   try
//   {
//     let o2 = _.mapOnly_( null, o, self._readChangeWrite.defaults );
//     o2.onChange = onChange;
//     self._readChangeWrite( o2 );
//     _.mapExtend( o, o2 );
//     return o;
//   }
//   catch( err )
//   {
//     throw _.err( err, `\nFailed to bump version of npm config ${o.configPath}` );
//   }
//
//   function onChange( op )
//   {
//     let o2 = Object.create( null );
//     _.mapOnly_( o2, o, self.structureFixate.defaults );
//     _.mapOnly_( o2, op, self.structureFixate.defaults );
//     self.structureDepRemove( o2 );
//     return o2.changed;
//   }
//
// }
//
// depRemove.defaults =
// {
//   configPath : null,
//   localPath : null,
//   dry : 0,
//   verbosity : 0,
//   ... structureDepRemove.defaults,
// }

// --
// write l3
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

// --
// read l3
// --

function versionLog( o )
{
  let self = this;

  _.routineOptions( versionLog, o );

  if( !o.configPath )
  o.configPath = self.pathConfigFromLocal( o.localPath );
  // o.configPath = _.path.join( o.localPath, 'package.json' ); /* xxx : qqq for Dmytro : introduce routine::localPathToConfigPath and use everywhere */

  _.assert( _.strDefined( o.configPath ) );
  _.assert( _.strDefined( o.remotePath ) );

  let logger = o.logger || _global_.logger;
  let packageJson =  _.fileProvider.fileRead({ filePath : o.configPath, encoding : 'json', throwing : 0 });
  // let remotePath = self.pathNativize( o.remotePath );
  let remotePath = _.npm.path.nativize( o.remotePath );

  _.assert( !o.logging || !!logger, 'No defined logger' );

  return _.process.start
  ({
    execPath : `npm view ${remotePath} version`,
    outputCollecting : 1,
    outputPiping : 0,
    inputMirroring : 0,
    throwingExitCode : 0,
  })
  .then( ( got ) =>
  {
    let current = packageJson ? packageJson.version : 'unknown';
    let latest = _.strStrip( got.output );

    if( got.exitCode || !latest )
    latest = 'unknown'

    let log = '';
    log += `Current version : ${current}\n`;
    log += `Latest version of ${o.remotePath} : ${latest}\n`;

    if( o.logging )
    logger.log( log );

    return log;
  })

}

versionLog.defaults =
{
  logger : null,
  logging : 1,
  remotePath : null,
  localPath : null,
  configPath : null,
}

// --
// remote
// --

/**
 * @summary Gets package metadata from npm registry.
 * @param {String} o.name Package name
 * @param {Boolean} [o.sync=1] Controls sync/async execution mode
 * @param {Boolean} [o.throwing=0] Controls error throwing
 * @function remoteAbout
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function remoteAbout( o )
{
  const self = this;
  const packageServer = 'https://registry.npmjs.org/';
  // let PackageJson = require( 'package-json' );

  if( _.strIs( arguments[ 0 ] ) )
  o = { name : arguments[ 0 ] };
  o = _.routineOptions( remoteAbout, o );

  const splits = _.strIsolateLeftOrAll({ src : o.name, delimeter : '!' });
  o.name = splits[ 0 ];
  o.version = splits[ 2 ] ? splits[ 2 ] : 'latest';

  // let ready = _.Consequence.From( PackageJson( o.name, { fullMetadata : true, version : o.version } ) );
  const ready = _.http.retrieve
  ({
    uri : _.path.join( packageServer, o.name ),
    sync : 0,
    attemptLimit : o.attemptLimit,
    attemptDelay : o.attemptDelay,
    successStatus : [ 200, 404 ],
  });

  ready.then( handleResponse );

  // ready.catch( ( err ) =>
  // {
  //   if( !o.throwing )
  //   {
  //     _.errAttend( err );
  //     return null;
  //   }
  //   throw _.err( err, `\nFailed to get information about remote module ${name}` );
  // });

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;

  /* */

  function handleResponse( op )
  {
    const response = op.response;
    let err;

    if( response.statusCode === 200 )
    {
      const data = response.body;
      const distTagVersion = data[ 'dist-tags' ][ o.version ];

      if( distTagVersion )
      return data.versions[ distTagVersion ];

      const versionData = data.versions[ o.version ];
      if( versionData )
      return versionData;

      err = _.err( `Wrong version tag ${ _.strQuote( o.version ) }` );
    }

    if( o.throwing )
    throw _.err( err ? err : response.body.error, `\nFailed to get information about remote module ${ _.strQuote( o.name ) }` );
    return null;
  }
}

remoteAbout.defaults =
{
  name : null,
  sync : 1,
  throwing : 1,
  attemptLimit : 3,
  attemptDelay : 500,
}

//

/**
 * @summary Retrieves package dependants number from npm storage.
 * @param {(string|string[])} o.remotePath Package name or array of names(the same as on npm storage).
 * @param {boolean} [o.sync=0] Controls sync/async execution mode.
 * @param {number} [o.verbosity=0] Verbosity control.
 * @returns {(number|number[])} Dependanst number for one package or array of dependants for array of packages.
 * @function remoteDependants
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function remoteDependants( o )
{
  const self = this;
  const prefixUri = 'https://www.npmjs.com/package/';

  let counter = 0;

  if( !_.mapIs( o ) )
  o = { remotePath : o }
  _.routineOptions( remoteDependants, o );

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

  return ready;

  /* */

  function uriNormalize( filePath )
  {
    let result;
    if( _.uri.isGlobal( filePath ) )
    {
      // let parsed = self.pathParse( filePath );
      let parsed = _.npm.path.parse( filePath );
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

remoteDependants.defaults =
{
  remotePath : null,
  sync : 0,
  verbosity : 0,
  attemptLimit : 3,
  attemptDelay : 250,
}

// --
// local
// --

/* qqq : cover */
function localName( o )
{
  let self = this;
  let path = _.uri;
  /* xxx : qqq : for Dmytro : use path and fileProvider of self everywhere in module::NpmToools and module::GitTools */

  if( !_.mapIs( o ) )
  o = { localPath : arguments[ 0 ] }

  _.routineOptions( localName, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  if( !o.config )
  {
    if( !o.configPath )
    o.configPath = self.pathConfigFromLocal( o.localPath );
    if( !_.fileProvider.fileExists( o.configPath ) )
    return;
    o.config = _.fileProvider.configRead( o.configPath );
  }

  return o.config.name;
}

localName.defaults =
{
  localPath : null,
  configPath : null,
  config : null,
}

// --
// vcs
// --

/**
 * @summary Returns version of npm package located at `o.localPath`.
 * @param {Object} o Options map.
 * @param {String} o.localPath Path to npm package on hard drive.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function localVersion
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function localVersion( o )
{
  let self = this;
  let path = _.uri;

  if( !_.mapIs( o ) )
  o = { localPath : arguments[ 0 ] }

  _.routineOptions( localVersion, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let ready = new _.Consequence().take( null );

  ready.then( () => self.isRepository( o ) )
  ready.then( ( isRepository ) =>
  {
    if( !isRepository )
    return '';

    return _.fileProvider.fileRead
    ({
      // filePath : path.join( o.localPath, 'package.json' ),
      filePath : self.pathConfigFromLocal( o.localPath ),
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

var defaults = localVersion.defaults = Object.create( null );
defaults.localPath = null;
defaults.sync = 1;
defaults.verbosity = 0;

//

/**
 * @summary Returns latest version of npm package using its remote path `o.remotePath`.
 * @param {Object} o Options map.
 * @param {String} o.remotePath Remote path.
 * @param {Number} o.verbosity=0 Level of verbosity.
 * @function remoteVersionLatest
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function remoteVersionLatest( o )
{
  let self = this;
  let path = _.uri;

  if( !_.mapIs( o ) )
  o = { remotePath : o }

  _.routineOptions( remoteVersionLatest, o );
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
    // parsed = _.npm.pathParse( o.remotePath );
    // return shell( 'npm show ' + parsed.remoteVcsPath );
    parsed = _.npm.path.parse({ remotePath : o.remotePath, full : 0, objects : 1 });
    return shell( 'npm show ' + parsed.host );
  })
  ready.then( ( got ) =>
  {
    let latestVersion = /latest.*?:.*?([0-9\.][0-9\.][0-9\.]+)/.exec( got.output );
    if( !latestVersion )
    {
      // throw _.err( 'Failed to get information about NPM package', parsed.remoteVcsPath );
      throw _.err( 'Failed to get information about NPM package', parsed.host );
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

var defaults = remoteVersionLatest.defaults = Object.create( null );
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
 * @function remoteVersionCurrent
 * @namespace wTools.npm
 * @module Tools/mid/NpmTools
 */

function remoteVersionCurrent( o )
{
  let self = this;
  let path = _.uri;

  if( !_.mapIs( o ) )
  o = { remotePath : o }

  _.routineOptions( remoteVersionCurrent, o );
  _.assert( arguments.length === 1, 'Expects single argument' );

  let ready = new _.Consequence().take( null );

  ready.then( () =>
  {
    // let parsed = self.pathParse( o.remotePath );
    let parsed = self.path.parse( o.remotePath );
    if( parsed.isFixated )
    return parsed.hash;
    return self.remoteVersionLatest( o );
  })

  if( o.sync )
  {
    ready.deasync();
    return ready.sync();
  }

  return ready;
}

var defaults = remoteVersionCurrent.defaults = Object.create( null );
defaults.remotePath = null;
defaults.sync = 1;
defaults.verbosity = 0;

//

function remoteVersion( o )
{
  let self = this;
  let path = _.uri;

  if( !_.mapIs( o ) )
  o = { remotePath : o }

  _.routineOptions( remoteVersionLatest, o );
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
    // let parsed = self.pathParse( o.remotePath );
    // return shell( 'npm show ' + parsed.remoteVcsLongerPath + ' version' );
    let packageVcsName = _.npm.path.nativize( o.remotePath );
    return shell( 'npm show ' + packageVcsName + ' version' );
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

var defaults = remoteVersion.defaults = Object.create( null );
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

  // let parsed = self.pathParse( o.remotePath );
  let parsed = self.path.parse( o.remotePath );

  let ready = new _.Consequence().take( null );

  ready.then( () => self.localVersion({ localPath : o.localPath, verbosity : o.verbosity, sync : 0 }) )
  ready.then( ( currentVersion ) =>
  {
    if( !currentVersion )
    return false;

    if( parsed.hash === currentVersion )
    return true;

    return self.remoteVersion({ remotePath : o.remotePath, verbosity : o.verbosity, sync : 0 })
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

    // if( !_.fileProvider.isTerminal( path.join( o.localPath, 'package.json' ) ) )
    if( !_.fileProvider.isTerminal( self.pathConfigFromLocal( o.localPath ) ) )
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

    // self.pathConfigFromLocal( o.localPath )
    // let configPath = path.join( o.localPath, 'package.json' );
    let configPath = self.pathConfigFromLocal( o.localPath );
    let configExists = localProvider.fileExists( configPath );

    if( !configExists )
    {
      result.downloaded = false;
      return result;
    }

    let config = localProvider.configRead( configPath );
    // let remoteVcsPath = self.pathParse( o.remotePath ).remoteVcsPath;
    let remoteVcsPath = _.npm.path.parse({ remotePath : o.remotePath, full : 0, objects : 1 }).host;
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

let DepSectionsNames =
[
  'dependencies',
  'devDependencies',
  'optionalDependencies',
  'bundledDependencies',
  'peerDependencies',
];

let Extension =
{

  protocols : [ 'npm' ],
  DepSectionsNames,

  // meta

  _readChangeWrite,
  _readChangeWrite_functor,

  // path

  pathParse,
  pathNativize,
  pathIsFixated,
  pathFixate,
  pathConfigFromLocal, /* qqq : cover */
  pathLocalFromConfig, /* qqq : cover */
  pathDownloadFromLocal, /* qqq : cover */
  pathLocalFromDownload, /* qqq : cover */

  // write l2

  format,

  fixate, /* qqq : cover please */
  structureFixate, /* qqq : cover please */
  bump, /* qqq : cover please */
  structureBump, /* qqq : cover please */

  // structureDepAdd, /* qqq : implement and cover */
  // depAdd, /* qqq : implement and cover */
  structureDepRemove, /* qqq : implement and cover */
  depRemove, /* qqq : cover */

  // write l3

  publish,

  // read l3

  versionLog,

  // remote

  remoteAbout,
  remoteDependants,

  // local

  localName,

  // vcs

  /* xxx : rename */
  localVersion,
  remoteVersionLatest,
  remoteVersionCurrent,
  remoteVersion,
  isUpToDate,
  hasFiles,
  isRepository,
  hasRemote,
  hasLocalChanges,

}

_.mapExtend( Self, Extension );

//

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

} )();
