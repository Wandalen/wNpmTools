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
    self._readChangeWrite( o2 );
    _.mapExtend( o, o2 );
    // o.config = o.config;
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
    self._readChangeWrite( o2 );
    _.mapExtend( o, o2 );
    // o.config = o.config;
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

  if( o.sync )
  {
    // return ready.deasync();
    ready.deasyncWait();
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

// --
// declare
// --

let Extend =
{

  protocols : [ 'npm' ],

  publish,

  fixate,
  structureFixate,
  bump, /* qqq : cover please */
  structureBump,

  aboutFromRemote,

  _readChangeWrite,

}

_.mapExtend( Self, Extend );

//

if( typeof module !== 'undefined' && module !== null )
module[ 'exports' ] = _global_.wTools;

})();
