( function _NpmTools_test_ss_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../Tools.s' );
  _.include( 'wTesting' );
  require( '../l3/npm/IncludeMid.s' );
}

//

var _ = _global_.wTools;

// --
// context
// --

function onSuiteBegin( test )
{
  let context = this;
  context.provider = _.fileProvider;
  let path = context.provider.path;
  context.suitePath = context.provider.path.pathDirTempOpen( path.join( __dirname, '../..'  ),'NpmTools' );
  context.suitePath = context.provider.pathResolveLinkFull({ filePath : context.suitePath, resolvingSoftLink : 1 });
  context.suitePath = context.suitePath.absolutePath;

}

//

function onSuiteEnd( test )
{
  let context = this;
  let path = context.provider.path;
  _.assert( _.strHas( context.suitePath, 'NpmTools' ), context.suitePath );
  path.pathDirTempClose( context.suitePath );
}

// --
// tests
// --

function trivial( test )
{

  var about = _.npm.aboutFromRemote( 'wTools' );
  test.is( !!about );
  var exp = 'wTools';
  test.identical( about.name, exp );

}

//

function pathParse( test )
{
  var remotePath = 'npm:///wpathbasic'
  var expected =
  {
    'protocol' : 'npm',
    'longPath' : '/wpathbasic',
    'tag' : 'latest',
    'localVcsPath' : '',
    'remoteVcsPath' : 'wpathbasic',
    'longerRemoteVcsPath' : 'wpathbasic',
    'isFixated' : false
  }
  var got = _.npm.pathParse( remotePath );
  test.identical( got, expected );

  var remotePath = 'npm:///wpathbasic#1.0.0'
  var expected =
  {
    'protocol' : 'npm',
    'hash' : '1.0.0',
    'longPath' : '/wpathbasic',
    'localVcsPath' : '',
    'remoteVcsPath' : 'wpathbasic',
    'longerRemoteVcsPath' : 'wpathbasic@1.0.0',
    'isFixated' : true
  }
  var got = _.npm.pathParse( remotePath );
  test.identical( got, expected );

  var remotePath = 'npm:///wpathbasic@beta'
  var expected =
  {
    'protocol' : 'npm',
    'tag' : 'beta',
    'longPath' : '/wpathbasic',
    'localVcsPath' : '',
    'remoteVcsPath' : 'wpathbasic',
    'longerRemoteVcsPath' : 'wpathbasic@beta',
    'isFixated' : false
  }
  var got = _.npm.pathParse( remotePath );
  test.identical( got, expected );

  var remotePath = 'npm:///wpathbasic#1.0.0@beta'
  test.shouldThrowErrorSync( () => npm.pathParse( remotePath ) );
}

//

function pathIsFixated( test )
{
  var remotePath = 'npm:///wpathbasic'
  var got = _.npm.pathIsFixated( remotePath );
  test.identical( got, false );

  var remotePath = 'npm:///wpathbasic#1.0.0'
  var got = _.npm.pathIsFixated( remotePath );
  test.identical( got, true );

  var remotePath = 'npm:///wpathbasic@beta'
  var got = _.npm.pathIsFixated( remotePath );
  test.identical( got, false );

  var remotePath = 'npm:///wpathbasic#1.0.0@beta'
  test.shouldThrowErrorSync( () => npm.pathIsFixated( remotePath ) );
}

function pathFixate( test )
{
  var remotePath = 'npm:///wpathbasic'
  var got = _.npm.pathFixate( remotePath );
  test.is( _.strHas( got, /npm:\/\/\/wpathbasic#.+/ ));

  var remotePath = 'npm:///wpathbasic#1.0.0'
  var got = _.npm.pathFixate( remotePath );
  test.is( _.strHas( got, /npm:\/\/\/wpathbasic#.+/ ));
  test.notIdentical( got, remotePath );

  var remotePath = 'npm:///wpathbasic@beta'
  var got = _.npm.pathFixate( remotePath );
  test.is( _.strHas( got, /npm:\/\/\/wpathbasic#.+/ ));
  test.notIdentical( got, remotePath );

  var remotePath = 'npm:///wpathbasic#1.0.0@beta'
  test.shouldThrowErrorSync( () => npm.pathFixate( remotePath ) );
}

function versionLocalRetrive( test )
{
  let self = this;
  let testPath = _.path.join( self.suitePath, test.name );
  let filePath = _.path.join( testPath, 'package.json' );

  test.case = 'path doesn`t exist'
  var got = _.npm.versionLocalRetrive({ localPath : testPath })
  test.identical( got, '' );

  _.fileProvider.dirMake( testPath );

  test.case = 'no package'
  var got = _.npm.versionLocalRetrive({ localPath : testPath })
  test.identical( got, '' );

  test.case = 'after init'
  var data = { version : '1.0.0' }
  _.fileProvider.fileWrite({ filePath, data, encoding : 'json' })
  var got = _.npm.versionLocalRetrive({ localPath : testPath })
  test.identical( got, '1.0.0' );

  test.case = 'after init'
  var data = { version : null }
  _.fileProvider.fileWrite({ filePath, data, encoding : 'json' })
  var got = _.npm.versionLocalRetrive({ localPath : testPath })
  test.identical( got, null );
}

//

function versionRemoteLatestRetrive( test )
{
  var remotePath = 'npm:///wpathbasic'
  var got = _.npm.versionRemoteLatestRetrive( remotePath );
  test.is( _.strDefined( got ) );

  var remotePath = 'npm:///wpathbasic@latest'
  var got = _.npm.versionRemoteLatestRetrive( remotePath );
  test.is( _.strDefined( got ) );

  var remotePath = 'npm:///wpathbasic@beta'
  var got = _.npm.versionRemoteLatestRetrive( remotePath );
  test.is( _.strDefined( got ) );

  var remotePath = 'npm:///wpathbasic#0.7.1'
  var got = _.npm.versionRemoteLatestRetrive( remotePath );
  test.is( _.strDefined( got ) );

  test.shouldThrowErrorSync( () => _.npm.versionRemoteLatestRetrive( 'npm:///wpathbasicc' ))
  test.shouldThrowErrorSync( () => _.npm.versionRemoteLatestRetrive( 'npm:///wpathbasicc@beta' ))
  test.shouldThrowErrorSync( () => _.npm.versionRemoteLatestRetrive( 'npm:///wpathbasicc#0.7.1' ))
}

versionRemoteLatestRetrive.timeOut = 30000;

//

function versionRemoteCurrentRetrive( test )
{
  var remotePath = 'npm:///wpathbasic'
  var got = _.npm.versionRemoteCurrentRetrive( remotePath );
  test.is( _.strDefined( got ) );

  var remotePath = 'npm:///wpathbasic@latest'
  var got = _.npm.versionRemoteCurrentRetrive( remotePath );
  test.is( _.strDefined( got ) );
  test.notIdentical( got, remotePath );

  var remotePath = 'npm:///wpathbasic@beta'
  var got = _.npm.versionRemoteCurrentRetrive( remotePath );
  test.is( _.strDefined( got ) );
  test.notIdentical( got, remotePath );

  var remotePath = 'npm:///wpathbasic#0.7.1'
  var got = _.npm.versionRemoteCurrentRetrive( remotePath );
  test.is( _.strDefined( got ) );
  test.identical( got, '0.7.1' );
}

versionRemoteCurrentRetrive.timeOut = 30000;


function isUpToDate( test )
{
  let self = this;
  let testPath = _.path.join( self.suitePath, test.name );
  let localPath = _.path.join( testPath, 'node_modules/wpathbasic');
  let ready = new _.Consequence().take( null );

  _.fileProvider.dirMake( testPath )

  let install = _.process.starter
  ({
    execPath : 'npm install --no-package-lock --legacy-bundling --prefix ' + _.fileProvider.path.nativize( testPath ),
    currentPath : testPath,
    ready
  })

  ready

  .then( () =>
  {
    test.case = 'no package'
    let remotePath = 'npm:///wpathbasic'
    var got = _.npm.isUpToDate({ localPath, remotePath });
    test.identical( got, false );
    return null;
  })

  install( 'wpathbasic' )
  .then( () =>
  {
    test.case = 'installed latest, remote points to latest'
    let remotePath = 'npm:///wpathbasic'
    var got = _.npm.isUpToDate({ localPath, remotePath });
    test.identical( got, true );
    return null;
  })

  install( 'wpathbasic@beta' )
  .then( () =>
  {
    test.case = 'installed beta, remote points to latest'
    let remotePath = 'npm:///wpathbasic'
    var got = _.npm.isUpToDate({ localPath, remotePath });
    test.identical( got, false );
    return null;
  })

  install( 'wpathbasic@latest' )
  .then( () =>
  {
    test.case = 'installed beta, remote points to latest'
    let remotePath = 'npm:///wpathbasic'
    var got = _.npm.isUpToDate({ localPath, remotePath });
    test.identical( got, true );
    return null;
  })

  install( 'wpathbasic@0.7.1' )
  .then( () =>
  {
    test.case = 'installed version, remote points to latest'
    let remotePath = 'npm:///wpathbasic'
    var got = _.npm.isUpToDate({ localPath, remotePath });
    test.identical( got, false );
    return null;
  })

  install( 'wpathbasic@0.7.1' )
  .then( () =>
  {
    test.case = 'installed version, remote points to beta'
    let remotePath = 'npm:///wpathbasic@beta'
    var got = _.npm.isUpToDate({ localPath, remotePath });
    test.identical( got, false );
    return null;
  })

  return ready;
}

isUpToDate.timeOut = 60000;

//

function isRepository( test )
{
  let self = this;
  let testPath = _.path.join( self.suitePath, test.name );
  let localPath = _.path.join( testPath, 'node_modules/wpathbasic');
  let ready = new _.Consequence().take( null );

  _.fileProvider.dirMake( testPath )

  let install = _.process.starter
  ({
    execPath : 'npm install --no-package-lock --legacy-bundling --prefix ' + _.fileProvider.path.nativize( testPath ),
    currentPath : testPath,
    ready
  })

  ready

  .then( () =>
  {
    test.case = 'no package'
    var got = _.npm.isRepository({ localPath });
    test.identical( got, false );
    return null;
  })

  install( 'wpathbasic' )
  .then( () =>
  {
    test.case = 'installed latest'
    var got = _.npm.isRepository({ localPath });
    test.identical( got, true );
    return null;
  })

  install( 'wpathbasic@beta' )
  .then( () =>
  {
    test.case = 'installed beta'
    var got = _.npm.isRepository({ localPath });
    test.identical( got, true );
    return null;
  })

  install( 'wpathbasic@0.7.1' )
  .then( () =>
  {
    test.case = 'installed version'
    var got = _.npm.isRepository({ localPath });
    test.identical( got, true );
    return null;
  })

  return ready;
}

isRepository.timeOut = 20000;

// --
// declare
// --

var Proto =
{

  name : 'Tools.mid.NpmTools',
  silencing : 1,

  onSuiteBegin,
  onSuiteEnd,

  context :
  {
    provider : null,
    suitePath : null,
  },

  tests :
  {
    trivial,
    pathParse,
    pathIsFixated,
    pathFixate,

    versionLocalRetrive,
    versionRemoteLatestRetrive,
    versionRemoteCurrentRetrive,

    isUpToDate,
    isRepository
  },

}

//

var Self = new wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
