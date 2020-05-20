( function _NpmTools_test_ss_( ) {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../dwtools/Tools.s' );
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

  test.case = 'basic';
  var remotePath = 'npm:///wpathbasic'
  var exp =
  {
    'protocol' : 'npm',
    'longPath' : '/wpathbasic',
    'parametrizedPath' : '/wpathbasic',
    'tag' : 'latest',
    'localVcsPath' : '',
    'remoteVcsPath' : 'wpathbasic',
    'remoteVcsLongerPath' : 'wpathbasic',
    'isFixated' : false
  }
  var got = _.npm.pathParse( remotePath );
  test.identical( got, exp );

  test.case = 'hash';
  var remotePath = 'npm:///wpathbasic#1.0.0'
  var exp =
  {
    'protocol' : 'npm',
    'hash' : '1.0.0',
    'longPath' : '/wpathbasic',
    'parametrizedPath' : '/wpathbasic#1.0.0',
    'localVcsPath' : '',
    'remoteVcsPath' : 'wpathbasic',
    'remoteVcsLongerPath' : 'wpathbasic#1.0.0',
    'isFixated' : true
  }
  var got = _.npm.pathParse( remotePath );
  test.identical( got, exp );

  test.case = 'tag';
  var remotePath = 'npm:///wpathbasic@beta';
  var exp =
  {
    'protocol' : 'npm',
    'tag' : 'beta',
    'longPath' : '/wpathbasic',
    'parametrizedPath' : '/wpathbasic@beta',
    'localVcsPath' : '',
    'remoteVcsPath' : 'wpathbasic',
    'remoteVcsLongerPath' : 'wpathbasic@beta',
    'isFixated' : false
  }
  var got = _.npm.pathParse( remotePath );
  test.identical( got, exp );

  test.case = 'with local';
  var remotePath = 'npm:///wColor/out/wColor#0.3.100';
  var exp =
  {
    'protocol' : 'npm',
    'hash' : '0.3.100',
    'longPath' : '/wColor/out/wColor',
    'parametrizedPath' : '/wColor/out/wColor#0.3.100',
    'localVcsPath' : 'out/wColor',
    'remoteVcsPath' : 'wColor',
    'remoteVcsLongerPath' : 'wColor#0.3.100',
    'isFixated' : true
  }
  var got = _.npm.pathParse( remotePath );
  test.identical( got, exp );

  // test.case = 'tag only';
  // var remotePath = '@some tag'
  // var exp =
  // {
  //   'longPath' : '@some tag',
  //   'parametrizedPath' : '@some tag',
  //   'localVcsPath' : '',
  //   'remoteVcsPath' : '',
  //   'remoteVcsLongerPath' : '@some tag',
  //   'isFixated' : true,
  // }
  // debugger;
  // var got = _.npm.pathParse( remotePath );
  // debugger;
  // test.identical( got, exp );
  // xxx

  if( !Config.debug )
  return;

  test.case = 'throwing';
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

  install( 'wpathbasic@beta' )
  .then( () =>
  {
    test.case = 'installed beta, remote points to latest'
    let remotePath = 'npm:///wpathbasic@beta'
    var got = _.npm.isUpToDate({ localPath, remotePath });
    test.identical( got, true );
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

  install( 'wpathbasic@0.7.1' )
  .then( () =>
  {
    test.case = 'installed version, remote points to beta'
    let remotePath = 'npm:///wpathbasic#0.7.1'
    var got = _.npm.isUpToDate({ localPath, remotePath });
    test.identical( got, true );
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

//

function hasRemote( test )
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
    var got = _.npm.hasRemote({ localPath, remotePath });
    test.identical( got.downloaded, false );
    test.identical( got.remoteIsValid, false );
    return null;
  })

  install( 'wpathbasic' )
  .then( () =>
  {
    test.case = 'installed latest, remote points to latest'
    let remotePath = 'npm:///wpathbasic'
    var got = _.npm.hasRemote({ localPath, remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );
    return null;
  })

  install( 'wpathbasic' )
  .then( () =>
  {
    test.case = 'installed latest, remote points to latest'
    let remotePath = 'npm:///wpathbasicc'
    var got = _.npm.hasRemote({ localPath, remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, false );
    return null;
  })

  install( 'wpathbasic@beta' )
  .then( () =>
  {
    test.case = 'installed beta, remote points to latest'
    let remotePath = 'npm:///wpathbasic'
    var got = _.npm.hasRemote({ localPath, remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );
    return null;
  })

  install( 'wpathbasic@latest' )
  .then( () =>
  {
    test.case = 'installed beta, remote points to latest'
    let remotePath = 'npm:///wpathbasic'
    var got = _.npm.hasRemote({ localPath, remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );
    return null;
  })

  install( 'wpathbasic@0.7.1' )
  .then( () =>
  {
    test.case = 'installed version, remote points to latest'
    let remotePath = 'npm:///wpathbasic'
    var got = _.npm.hasRemote({ localPath, remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );
    return null;
  })

  install( 'wpathbasic@0.7.1' )
  .then( () =>
  {
    test.case = 'installed version, remote points to beta'
    let remotePath = 'npm:///wpathbasic@beta'
    var got = _.npm.hasRemote({ localPath, remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );
    return null;
  })

  return ready;
}

hasRemote.timeOut = 60000;

//

async function dependantsRetrieve( test )
{
  test.open( 'string as a parameter' );
    test.open( '0 dependants' );
      test.case = 'local relative';
      let got = await _.npm.dependantsRetrieve( 'wmodulefortesting12ab' );
      let exp = 0;
      test.identical( got, exp );

      test.case = 'global relative';
      got = await _.npm.dependantsRetrieve( 'npm://wmodulefortesting12ab' );
      exp = 0;
      test.identical( got, exp );

      test.case = 'global absolute';
      got = await _.npm.dependantsRetrieve( 'npm:///wmodulefortesting12ab' );
      exp = 0;
      test.identical( got, exp );
    test.close( '0 dependants' );

    test.open( 'not 0 dependants' );
      test.case = 'local relative';
      got = await _.npm.dependantsRetrieve( 'wmodulefortesting1a' );
      exp = 1;
      test.identical( got, exp );

      test.case = 'global relative';
      got = await _.npm.dependantsRetrieve( 'npm://wmodulefortesting1a' );
      exp = 1;
      test.identical( got, exp );

      test.case = 'global absolute';
      got = await _.npm.dependantsRetrieve( 'npm:///wmodulefortesting1a' );
      exp = 1;
      test.identical( got, exp );
    test.close( 'not 0 dependants' );

    test.open( 'pakage name has "/"' );
      test.case = 'local relative';
      got = await _.npm.dependantsRetrieve( '@tensorflow/tfjs' );
      test.gt( got, 100 );

      test.case = 'global relative';
      got = await _.npm.dependantsRetrieve( 'npm://@tensorflow/tfjs' );
      test.gt( got, 100 );

      test.case = 'global absolute';
      got = await _.npm.dependantsRetrieve( 'npm:///@tensorflow/tfjs' );
      test.gt( got, 100 );
    test.close( 'pakage name has "/"' );

    test.open( 'dependants > 999' );
      test.case = 'local relative';
      got = await _.npm.dependantsRetrieve( 'express' );
      test.is( _.numberIs( got ) );
      test.gt( got, 10000 );

      test.case = 'global relative';
      got = await _.npm.dependantsRetrieve( 'npm://express' );
      test.is( _.numberIs( got ) );
      test.gt( got, 10000 );

      test.case = 'global absolute';
      got = await _.npm.dependantsRetrieve( 'npm:///express' );
      test.is( _.numberIs( got ) );
      test.gt( got, 10000 );
    test.close( 'dependants > 999' );

    test.open( 'nonexistent package name' );
      test.case = 'local relative';
      got = await _.npm.dependantsRetrieve( 'nonexistentPackageName' );
      exp = NaN;
      test.identical( got, exp );

      test.case = 'global relative';
      got = await _.npm.dependantsRetrieve( 'npm://nonexistentPackageName' );
      exp = NaN;
      test.identical( got, exp );

      test.case = 'global absolute';
      got = await _.npm.dependantsRetrieve( 'npm:///nonexistentPackageName' );
      exp = NaN;
      test.identical( got, exp );
    test.close( 'nonexistent package name' );
  test.close( 'string as a parameter' );

  test.open( 'object as a parameter' );
    test.open( '0 dependants' );
      test.case = 'local relative';
      got = await _.npm.dependantsRetrieve( { remotePath : 'wmodulefortesting12ab' } );
      exp = 0;
      test.identical( got, exp );

      test.case = 'global relative';
      got = await _.npm.dependantsRetrieve( { remotePath : 'npm://wmodulefortesting12ab' } );
      exp = 0;
      test.identical( got, exp );

      test.case = 'global absolute';
      got = await _.npm.dependantsRetrieve( { remotePath : 'npm:///wmodulefortesting12ab' } );
      exp = 0;
      test.identical( got, exp );
    test.close( '0 dependants' );

    test.open( 'not 0 dependants' );
      test.case = 'local relative';
      got = await _.npm.dependantsRetrieve( { remotePath : 'wmodulefortesting1a' } );
      exp = 1;
      test.identical( got, exp );

      test.case = 'global relative';
      got = await _.npm.dependantsRetrieve( { remotePath : 'npm://wmodulefortesting1a' } );
      exp = 1;
      test.identical( got, exp );

      test.case = 'global absolute';
      got = await _.npm.dependantsRetrieve( { remotePath : 'npm:///wmodulefortesting1a' } );
      exp = 1;
      test.identical( got, exp );
    test.close( 'not 0 dependants' );

    test.open( 'pakage name has "/"' );
      test.case = 'local relative';
      got = await _.npm.dependantsRetrieve( { remotePath : '@tensorflow/tfjs' } );
      test.gt( got, 100 );

      test.case = 'global relative';
      got = await _.npm.dependantsRetrieve( { remotePath : 'npm://@tensorflow/tfjs' } );
      test.gt( got, 100 );

      test.case = 'global absolute';
      got = await _.npm.dependantsRetrieve( { remotePath : 'npm:///@tensorflow/tfjs' } );
      test.gt( got, 100 );
    test.close( 'pakage name has "/"' );

    test.open( 'dependants > 999' );
      test.case = 'local relative';
      got = await _.npm.dependantsRetrieve( { remotePath : 'express' } );
      test.is( _.numberIs( got ) );
      test.gt( got, 10000 );

      test.case = 'global relative';
      got = await _.npm.dependantsRetrieve( { remotePath : 'npm://express' } );
      test.is( _.numberIs( got ) );
      test.gt( got, 10000 );

      test.case = 'global absolute';
      got = await _.npm.dependantsRetrieve( { remotePath : 'npm:///express' } );
      test.is( _.numberIs( got ) );
      test.gt( got, 10000 );
    test.close( 'dependants > 999' );

    test.open( 'nonexistent package name' );
      test.case = 'local relative';
      got = await _.npm.dependantsRetrieve( { remotePath : 'nonexistentPackageName' } );
      exp = NaN;
      test.identical( got, exp );

      test.case = 'global relative';
      got = await _.npm.dependantsRetrieve( { remotePath : 'npm://nonexistentPackageName' } );
      exp = NaN;
      test.identical( got, exp );

      test.case = 'global absolute';
      got = await _.npm.dependantsRetrieve( { remotePath : 'npm:///nonexistentPackageName' } );
      exp = NaN;
      test.identical( got, exp );
    test.close( 'nonexistent package name' );
  test.close( 'object as a parameter' );
}

dependantsRetrieve.description =
`
Retrieves the number of dependent packages
`

//

async function dependantsRetrieveMultipleRequests( test )
{
    let localRelative = [
    'wmodulefortesting1', 'wmodulefortesting1a', 'wmodulefortesting1b',
    'wmodulefortesting12', 'wmodulefortesting12ab', 'nonexistentPackageName',
    'wmodulefortesting1', 'wmodulefortesting1a', 'wmodulefortesting1b',
    'wmodulefortesting12', 'wmodulefortesting12ab', 'nonexistentPackageName',
    'wmodulefortesting1', 'wmodulefortesting1a', 'wmodulefortesting1b',
    'wmodulefortesting12', 'wmodulefortesting12ab', 'nonexistentPackageName',
    'wmodulefortesting1', 'wmodulefortesting1a', 'wmodulefortesting1b',
    'wmodulefortesting12', 'wmodulefortesting12ab', 'nonexistentPackageName',
    'wmodulefortesting1', 'wmodulefortesting1a', 'wmodulefortesting1b',
    'wmodulefortesting12', 'wmodulefortesting12ab', 'nonexistentPackageName',
    'wmodulefortesting1', 'wmodulefortesting1a', 'wmodulefortesting1b',
    'wmodulefortesting12', 'wmodulefortesting12ab', 'nonexistentPackageName',
  ];

  let globalRelative = [
    'npm://wmodulefortesting1', 'npm://wmodulefortesting1a', 'npm://wmodulefortesting1b',
    'npm://wmodulefortesting12', 'npm://wmodulefortesting12ab', 'npm://nonexistentPackageName',
    'npm://wmodulefortesting1', 'npm://wmodulefortesting1a', 'npm://wmodulefortesting1b',
    'npm://wmodulefortesting12', 'npm://wmodulefortesting12ab', 'npm://nonexistentPackageName',
    'npm://wmodulefortesting1', 'npm://wmodulefortesting1a', 'npm://wmodulefortesting1b',
    'npm://wmodulefortesting12', 'npm://wmodulefortesting12ab', 'npm://nonexistentPackageName',
    'npm://wmodulefortesting1', 'npm://wmodulefortesting1a', 'npm://wmodulefortesting1b',
    'npm://wmodulefortesting12', 'npm://wmodulefortesting12ab', 'npm://nonexistentPackageName',
    'npm://wmodulefortesting1', 'npm://wmodulefortesting1a', 'npm://wmodulefortesting1b',
    'npm://wmodulefortesting12', 'npm://wmodulefortesting12ab', 'npm://nonexistentPackageName',
    'npm://wmodulefortesting1', 'npm://wmodulefortesting1a', 'npm://wmodulefortesting1b',
    'npm://wmodulefortesting12', 'npm://wmodulefortesting12ab', 'npm://nonexistentPackageName',
  ];

  let globalAbsolute = [
    'npm:///wmodulefortesting1', 'npm:///wmodulefortesting1a', 'npm:///wmodulefortesting1b',
    'npm:///wmodulefortesting12', 'npm:///wmodulefortesting12ab', 'npm:///nonexistentPackageName',
    'npm:///wmodulefortesting1', 'npm:///wmodulefortesting1a', 'npm:///wmodulefortesting1b',
    'npm:///wmodulefortesting12', 'npm:///wmodulefortesting12ab', 'npm:///nonexistentPackageName',
    'npm:///wmodulefortesting1', 'npm:///wmodulefortesting1a', 'npm:///wmodulefortesting1b',
    'npm:///wmodulefortesting12', 'npm:///wmodulefortesting12ab', 'npm:///nonexistentPackageName',
    'npm:///wmodulefortesting1', 'npm:///wmodulefortesting1a', 'npm:///wmodulefortesting1b',
    'npm:///wmodulefortesting12', 'npm:///wmodulefortesting12ab', 'npm:///nonexistentPackageName',
    'npm:///wmodulefortesting1', 'npm:///wmodulefortesting1a', 'npm:///wmodulefortesting1b',
    'npm:///wmodulefortesting12', 'npm:///wmodulefortesting12ab', 'npm:///nonexistentPackageName',
    'npm:///wmodulefortesting1', 'npm:///wmodulefortesting1a', 'npm:///wmodulefortesting1b',
    'npm:///wmodulefortesting12', 'npm:///wmodulefortesting12ab', 'npm:///nonexistentPackageName',
  ];

  let dependants = [
    4, 1, 1, 1, 0, NaN,
    4, 1, 1, 1, 0, NaN,
    4, 1, 1, 1, 0, NaN,
    4, 1, 1, 1, 0, NaN,
    4, 1, 1, 1, 0, NaN,
    4, 1, 1, 1, 0, NaN
  ];

  test.open( 'string as a parameter' );
    test.case = 'local relative';
    let got = await _.npm.dependantsRetrieve( localRelative );
    let exp = dependants;
    test.identical( got, exp );

    test.case = 'global relative';
    got = await _.npm.dependantsRetrieve( globalRelative );
    exp = dependants;
    test.identical( got, exp );

    test.case = 'global absolute';
    got = await _.npm.dependantsRetrieve( globalAbsolute );
    exp = dependants;
    test.identical( got, exp );
  test.close( 'string as a parameter' );

  test.open( 'object as a parameter' );
    test.case = 'local relative';
    got = await _.npm.dependantsRetrieve( { remotePath : localRelative } );
    exp = dependants;
    test.identical( got, exp );

    test.case = 'global relative';
    got = await _.npm.dependantsRetrieve( { remotePath : globalRelative } );
    exp = dependants;
    test.identical( got, exp );

    test.case = 'global absolute';
    got = await _.npm.dependantsRetrieve( { remotePath : globalAbsolute } );
    exp = dependants;
    test.identical( got, exp );
  test.close( 'object as a parameter' );
}

dependantsRetrieveMultipleRequests.description =
`
Retrieves dependants of each package in array
`
dependantsRetrieveMultipleRequests.timeOut = 120000;

// --
// declare
// --

var Proto =
{

  name : 'Tools.mid.NpmTools',
  silencing : 1,
  routineTimeOut : 60000,

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
    isRepository,
    hasRemote,

    dependantsRetrieve,
    dependantsRetrieveMultipleRequests,

  },

}

//

var Self = new wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();