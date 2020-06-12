( function _NpmTools_test_ss_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../dwtools/Tools.s' );
  _.include( 'wTesting' );
  require( '../npm/Include.ss' );
}

var _ = _testerGlobal_.wTools;

// --
// context
// --

function onSuiteBegin( test )
{
  let context = this;
  context.suiteTempPath = _.path.pathDirTempOpen( _.path.join( __dirname, '../..' ), 'NpmTools' );
  context.assetsOriginalPath = _.path.join( __dirname, '_asset' );
}

//

function onSuiteEnd( test )
{
  let context = this;
  _.assert( _.strHas( context.suiteTempPath, 'NpmTools' ), context.suiteTempPath );
  _.path.pathDirTempClose( context.suiteTempPath );
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

function fixate( test )
{
  let self = this;
  var a = test.assetFor( 'fixate' ); /* aaa Artem : done. should be single call of assetFor per test routine */

  /* aaa Artem : done. simplify package.json files. remove redundant fields */

  test.open( 'dependency versions are specified' );

  test.case = 'without callback';

  a.reflect(); /* aaa Artem : done. reflect should be inside of test case, not outside */

  var localPath = a.abs( 'fixateNotEmptyVersions' );
  var tag = '=';
  var got = _.npm.fixate({ localPath, tag }).config;

  /* aaa Artem : done. sperate case should test whole "got" map */
  /* aaa Artem : done. another case read written file and check it content */
  var exp =
  {
    'name' : 'test package.json',
    'version' : '1.0.0',
    'dependencies' : { 'package1' : '1.0.0', 'package2' : '1.0.0' },
    'devDependencies' : { 'package3' : '1.0.0', 'package4' : '1.0.0' },
    'optionalDependencies' : { 'package5' : '1.0.0', 'package6' : '1.0.0' },
    'bundledDependencies' : [ 'package7', 'package8' ],
    'peerDependencies' : { 'package9' : '1.0.0', 'package10' : '1.0.0' }
  }
  /* aaa Artem : done. why fixateNotEmptyVersions is called only without callback onDependency? */

  test.identical( got, exp );

  //

  test.case = 'with callback';

  a.reflect();

  var localPath = a.abs( 'fixateNotEmptyVersions' );
  var tag = '=';
  var o = { localPath, tag, onDependency }
  var got = _.npm.fixate( o ).config;
  var exp =
  {
    'name' : 'test package.json',
    'version' : '1.0.0',
    'dependencies' : { 'package1' : '1.0.0', 'package2' : '1.0.0' },
    'devDependencies' : { 'package3' : '1.0.0', 'package4' : '1.0.0' },
    'optionalDependencies' : { 'package5' : '1.0.0', 'package6' : '1.0.0' },
    'bundledDependencies' : [ 'package7', 'package8' ],
    'peerDependencies' : { 'package9' : '1.0.0', 'package10' : '1.0.0' }
  }

  test.identical( got, exp );

  //

  test.case = 'check whole "got" map';

  a.reflect();

  var localPath = a.abs( 'fixateNotEmptyVersions' );
  var tag = '=';
  var got = _.npm.fixate({ localPath, tag });

  test.is( _.strDefined( got.localPath ) );
  test.is( _.strDefined( got.configPath ) );
  test.identical( got.tag, '=' );
  test.identical( got.onDependency, null );
  test.identical( got.dry, 0 );
  test.identical( got.verbosity, 0 );
  test.identical( got.changed, false );

  //

  test.case = 'read written config';

  a.reflect();

  var localPath = a.abs( 'fixateNotEmptyVersions' );
  var tag = '=';
  _.npm.fixate({ localPath, tag });
  var got = _.fileProvider.configRead({ filePath : a.abs( 'fixateNotEmptyVersions/package.json' ) });
  var exp =
  {
    'name' : 'test package.json',
    'version' : '1.0.0',
    'dependencies' : { 'package1' : '1.0.0', 'package2' : '1.0.0' },
    'devDependencies' : { 'package3' : '1.0.0', 'package4' : '1.0.0' },
    'optionalDependencies' : { 'package5' : '1.0.0', 'package6' : '1.0.0' },
    'bundledDependencies' : [ 'package7', 'package8' ],
    'peerDependencies' : { 'package9' : '1.0.0', 'package10' : '1.0.0' }
  }

  test.identical( got, exp );

  test.close( 'dependency versions are specified' );

  /* */

  test.open( 'dependency versions are not specified' );

  test.case = 'without callback';

  a.reflect();

  var localPath = a.abs( 'fixateEmptyVersions' );
  var tag = '=';
  var got = _.npm.fixate( { localPath, tag } ).config;
  var exp =
  { /* aaa Artem : done. fix styles, please */
    'name' : 'test package.json',
    'version' : '1.0.0',
    'dependencies' : { 'package1' : '=', 'package2' : '=' },
    'devDependencies' : { 'package3' : '=', 'package4' : '=' },
    'optionalDependencies' : { 'package5' : '=', 'package6' : '=' },
    'bundledDependencies' : [ 'package7', 'package8' ],
    'peerDependencies' : { 'package9' : '=', 'package10' : '=' }
  }

  test.identical( got, exp );

  //

  test.case = 'read written config';

  a.reflect();

  var localPath = a.abs( 'fixateEmptyVersions' );
  var tag = '=';
  _.npm.fixate({ localPath, tag });
  var got = _.fileProvider.configRead({ filePath : a.abs( 'fixateEmptyVersions/package.json' ) });
  var exp =
  {
    'name' : 'test package.json',
    'version' : '1.0.0',
    'dependencies' : { 'package1' : '=', 'package2' : '=' },
    'devDependencies' : { 'package3' : '=', 'package4' : '=' },
    'optionalDependencies' : { 'package5' : '=', 'package6' : '=' },
    'bundledDependencies' : [ 'package7', 'package8' ],
    'peerDependencies' : { 'package9' : '=', 'package10' : '=' }
  }

  test.identical( got, exp );

  //

  test.case = 'with callback';

  a.reflect();

  var localPath = a.abs( 'fixateEmptyVersions' );
  var tag = '=';
  var o = { localPath, tag, onDependency }
  var got = _.npm.fixate( o ).config;
  var exp =
  {
    'name' : 'test package.json',
    'version' : '1.0.0',
    'dependencies' : { 'package1' : '=1.1.1', 'package2' : '=2.2.2' },
    'devDependencies' : { 'package3' : '=3.3.3', 'package4' : '=4.4.4' },
    'optionalDependencies' : { 'package5' : '=5.5.5', 'package6' : '=6.6.6' },
    'bundledDependencies' : [ 'package7', 'package8' ],
    'peerDependencies' : { 'package9' : '=9.9.9', 'package10' : '=10.10.10' }
  }

  test.identical( got, exp );

  test.close( 'dependency versions are not specified' );

  /* callback */

  function onDependency( dep )
  {
    const depVersionsToFixate =
    {
      'package1' : '1.1.1',
      'package2' : '2.2.2',
      'package3' : '3.3.3',
      'package4' : '4.4.4',
      'package5' : '5.5.5',
      'package6' : '6.6.6',
      'package7' : '7.7.7',
      'package8' : '8.8.8',
      'package9' : '9.9.9',
      'package10' : '10.10.10',
    }

    for( let depName in depVersionsToFixate )
    {
      if( dep.name === depName )
      dep.version = o.tag + depVersionsToFixate[ depName ];
    }
  }
}

fixate.description =
`
Fixates versions of the dependecies in provided package
`;

// //

function bump( test )
{
  let self = this;

  let a = test.assetFor( 'bump' );

  /* aaa Artem : done. similar problems here */

  test.case = '`local path` option points to the config file';

  a.reflect();

  var localPath = a.abs( '.' );
  var got = _.npm.bump( { localPath } ).config;
  var exp =
  {
    'name' : 'test package.json',
    'version' : '1.0.1',
    'dependencies' : { 'package1' : '1.1.1' },
    'devDependencies' : { 'package2' : '2.2.2' }
  }

  test.identical( got, exp );

  //

  test.case = 'read written config';

  a.reflect();

  var localPath = a.abs( '.' );
  _.npm.bump({ localPath });
  var got = _.fileProvider.configRead({ filePath : a.abs( 'package.json' ) });
  var exp =
  {
    'name' : 'test package.json',
    'version' : '1.0.1',
    'dependencies' : { 'package1' : '1.1.1' },
    'devDependencies' : { 'package2' : '2.2.2' }
  }

  test.identical( got, exp );

  //

  test.case = 'check whole "got" map';

  a.reflect();

  var localPath = a.abs( '.' );
  var got = _.npm.bump({ localPath });

  test.is( _.strDefined( got.localPath ) );
  test.is( _.strDefined( got.configPath ) );
  test.identical( got.dry, 0 );
  test.identical( got.verbosity, 0 );
  test.identical( got.changed, true );
}

bump.description =
`
Bumps package version
`;

//

function pathParse( test )
{

  test.case = 'basic';
  var remotePath = 'npm:///wmodulefortesting1'
  var exp =
  {
    'protocol' : 'npm',
    'longPath' : '/wmodulefortesting1',
    'parametrizedPath' : '/wmodulefortesting1',
    'tag' : 'latest',
    'localVcsPath' : '',
    'remoteVcsPath' : 'wmodulefortesting1',
    'remoteVcsLongerPath' : 'wmodulefortesting1@latest',
    'isFixated' : false
  }
  var got = _.npm.pathParse( remotePath );
  test.identical( got, exp );

  test.case = 'hash';
  var remotePath = 'npm:///wmodulefortesting1#1.0.0'
  var exp =
  {
    'protocol' : 'npm',
    'hash' : '1.0.0',
    'longPath' : '/wmodulefortesting1',
    'parametrizedPath' : '/wmodulefortesting1#1.0.0',
    'localVcsPath' : '',
    'remoteVcsPath' : 'wmodulefortesting1',
    'remoteVcsLongerPath' : 'wmodulefortesting1@1.0.0',
    'isFixated' : true
  }
  var got = _.npm.pathParse( remotePath );
  test.identical( got, exp );

  test.case = 'tag';
  var remotePath = 'npm:///wmodulefortesting1@beta';
  var exp =
  {
    'protocol' : 'npm',
    'tag' : 'beta',
    'longPath' : '/wmodulefortesting1',
    'parametrizedPath' : '/wmodulefortesting1@beta',
    'localVcsPath' : '',
    'remoteVcsPath' : 'wmodulefortesting1',
    'remoteVcsLongerPath' : 'wmodulefortesting1@beta',
    'isFixated' : false
  }
  var got = _.npm.pathParse( remotePath );
  test.identical( got, exp );

  test.case = 'with local';
  var remotePath = 'npm:///wmodulefortesting1/out/wmodulefortesting1#0.3.100';
  var exp =
  {
    'protocol' : 'npm',
    'hash' : '0.3.100',
    'longPath' : '/wmodulefortesting1/out/wmodulefortesting1',
    'parametrizedPath' : '/wmodulefortesting1/out/wmodulefortesting1#0.3.100',
    'localVcsPath' : 'out/wmodulefortesting1',
    'remoteVcsPath' : 'wmodulefortesting1',
    'remoteVcsLongerPath' : 'wmodulefortesting1@0.3.100',
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
  var remotePath = 'npm:///wmodulefortesting1#1.0.0@beta'
  test.shouldThrowErrorSync( () => npm.pathParse( remotePath ) );

}

//

function pathIsFixated( test )
{
  var remotePath = 'npm:///wmodulefortesting1'
  var got = _.npm.pathIsFixated( remotePath );
  test.identical( got, false );

  var remotePath = 'npm:///wmodulefortesting1#1.0.0'
  var got = _.npm.pathIsFixated( remotePath );
  test.identical( got, true );

  var remotePath = 'npm:///wmodulefortesting1@beta'
  var got = _.npm.pathIsFixated( remotePath );
  test.identical( got, false );

  var remotePath = 'npm:///wmodulefortesting1#1.0.0@beta'
  test.shouldThrowErrorSync( () => npm.pathIsFixated( remotePath ) );
}

//

function pathFixate( test )
{
  var remotePath = 'npm:///wmodulefortesting1'
  var got = _.npm.pathFixate( remotePath );
  test.is( _.strHas( got, /npm:\/\/\/wmodulefortesting1#.+/ ) );

  var remotePath = 'npm:///wmodulefortesting1#1.0.0'
  var got = _.npm.pathFixate( remotePath );
  test.is( _.strHas( got, /npm:\/\/\/wmodulefortesting1#.+/ ) );
  test.notIdentical( got, remotePath );

  var remotePath = 'npm:///wmodulefortesting1@beta'
  var got = _.npm.pathFixate( remotePath );
  test.is( _.strHas( got, /npm:\/\/\/wmodulefortesting1#.+/ ) );
  test.notIdentical( got, remotePath );

  var remotePath = 'npm:///wmodulefortesting1#1.0.0@beta'
  test.shouldThrowErrorSync( () => npm.pathFixate( remotePath ) );
}

//

function versionLocalRetrive( test )
{
  let self = this;
  let a = test.assetFor( false );
  let testPath = a.abs( '.' );
  let filePath = a.abs( 'package.json' );
  /* aaa Artem : done. avoid using _.path.* in tests, use a.abs() instead please */

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

  /* aaa Artem : done. use modules for testing instead of production modules here and everywhere */
  var remotePath = 'npm:///wmodulefortesting1';
  var got = _.npm.versionRemoteLatestRetrive( remotePath );
  test.is( _.strDefined( got ) );

  var remotePath = 'npm:///wmodulefortesting1@latest';
  var got = _.npm.versionRemoteLatestRetrive( remotePath );
  test.is( _.strDefined( got ) );

  var remotePath = 'npm:///wmodulefortesting1@beta';
  var got = _.npm.versionRemoteLatestRetrive( remotePath );
  test.is( _.strDefined( got ) );

  var remotePath = 'npm:///wmodulefortesting1#0.0.3';
  var got = _.npm.versionRemoteLatestRetrive( remotePath );
  test.is( _.strDefined( got ) );

  test.shouldThrowErrorSync( () => _.npm.versionRemoteLatestRetrive( 'npm:///wmodulefortestinggg1' ))
  test.shouldThrowErrorSync( () => _.npm.versionRemoteLatestRetrive( 'npm:///wmodulefortestinggg1@beta' ))
  test.shouldThrowErrorSync( () => _.npm.versionRemoteLatestRetrive( 'npm:///wmodulefortestinggg1#0.0.3' ))

}

versionRemoteLatestRetrive.timeOut = 30000;

//

function versionRemoteCurrentRetrive( test )
{
  var remotePath = 'npm:///wmodulefortesting1'
  var got = _.npm.versionRemoteCurrentRetrive( remotePath );
  test.is( _.strDefined( got ) );

  var remotePath = 'npm:///wmodulefortesting1@latest'
  var got = _.npm.versionRemoteCurrentRetrive( remotePath );
  test.is( _.strDefined( got ) );
  test.notIdentical( got, remotePath );

  var remotePath = 'npm:///wmodulefortesting1@beta'
  var got = _.npm.versionRemoteCurrentRetrive( remotePath );
  test.is( _.strDefined( got ) );
  test.notIdentical( got, remotePath );

  var remotePath = 'npm:///wmodulefortesting1#0.0.3'
  var got = _.npm.versionRemoteCurrentRetrive( remotePath );
  test.is( _.strDefined( got ) );
  test.identical( got, '0.0.3' );
}

versionRemoteCurrentRetrive.timeOut = 30000;

//

function isUpToDate( test )
{
  let self = this;
  let a = test.assetFor( false );
  let testPath = a.abs( '.' );
  let localPath = a.abs( 'node_modules/wmodulefortesting1' );
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
    let remotePath = 'npm:///wmodulefortesting1'
    var got = _.npm.isUpToDate({ localPath, remotePath });
    test.identical( got, false );
    return null;
  })

  install( 'wmodulefortesting1' )
  .then( () =>
  {
    test.case = 'installed latest, remote points to latest'
    let remotePath = 'npm:///wmodulefortesting1'
    var got = _.npm.isUpToDate({ localPath, remotePath });
    test.identical( got, true );
    return null;
  })

  install( 'wmodulefortesting1@beta' )
  .then( () =>
  {
    test.case = 'installed beta, remote points to latest'
    let remotePath = 'npm:///wmodulefortesting1'
    var got = _.npm.isUpToDate({ localPath, remotePath });
    test.identical( got, false );
    return null;
  })

  install( 'wmodulefortesting1@beta' )
  .then( () =>
  {
    test.case = 'installed beta, remote points to latest'
    let remotePath = 'npm:///wmodulefortesting1@beta'
    var got = _.npm.isUpToDate({ localPath, remotePath });
    test.identical( got, true );
    return null;
  })

  install( 'wmodulefortesting1@latest' )
  .then( () =>
  {
    test.case = 'installed beta, remote points to latest'
    let remotePath = 'npm:///wmodulefortesting1'
    var got = _.npm.isUpToDate({ localPath, remotePath });
    test.identical( got, true );
    return null;
  })

  install( 'wmodulefortesting1@0.0.5' )
  .then( () =>
  {
    test.case = 'installed version, remote points to latest'
    let remotePath = 'npm:///wmodulefortesting1'
    var got = _.npm.isUpToDate({ localPath, remotePath });
    test.identical( got, false );
    return null;
  })

  install( 'wmodulefortesting1@0.0.3' )
  .then( () =>
  {
    test.case = 'installed version, remote points to beta'
    let remotePath = 'npm:///wmodulefortesting1@beta'
    var got = _.npm.isUpToDate({ localPath, remotePath });
    test.identical( got, false );
    return null;
  })

  install( 'wmodulefortesting1@0.0.3' )
  .then( () =>
  {
    test.case = 'installed version, remote points to beta'
    let remotePath = 'npm:///wmodulefortesting1#0.0.3'
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
  let a = test.assetFor( false );
  let testPath = a.abs( '.' );
  let localPath = a.abs( 'node_modules/wmodulefortesting1' );
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

  install( 'wmodulefortesting1' )
  .then( () =>
  {
    test.case = 'installed latest'
    var got = _.npm.isRepository({ localPath });
    test.identical( got, true );
    return null;
  })

  install( 'wmodulefortesting1@beta' )
  .then( () =>
  {
    test.case = 'installed beta'
    var got = _.npm.isRepository({ localPath });
    test.identical( got, true );
    return null;
  })

  install( 'wmodulefortesting1@0.0.3' )
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
  let a = test.assetFor( false );
  let testPath = a.abs( '.' );
  let localPath = a.abs( 'node_modules/wmodulefortesting1' );
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
    let remotePath = 'npm:///wmodulefortesting1'
    var got = _.npm.hasRemote({ localPath, remotePath });
    test.identical( got.downloaded, false );
    test.identical( got.remoteIsValid, false );
    return null;
  })

  install( 'wmodulefortesting1' )
  .then( () =>
  {
    test.case = 'installed latest, remote points to latest'
    let remotePath = 'npm:///wmodulefortesting1'
    var got = _.npm.hasRemote({ localPath, remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );
    return null;
  })

  install( 'wmodulefortesting1' )
  .then( () =>
  {
    test.case = 'installed latest, remote points to latest'
    let remotePath = 'npm:///wmodulefortestinggg1'
    var got = _.npm.hasRemote({ localPath, remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, false );
    return null;
  })

  install( 'wmodulefortesting1@beta' )
  .then( () =>
  {
    test.case = 'installed beta, remote points to latest'
    let remotePath = 'npm:///wmodulefortesting1'
    var got = _.npm.hasRemote({ localPath, remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );
    return null;
  })

  install( 'wmodulefortesting1@latest' )
  .then( () =>
  {
    test.case = 'installed beta, remote points to latest'
    let remotePath = 'npm:///wmodulefortesting1'
    var got = _.npm.hasRemote({ localPath, remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );
    return null;
  })

  install( 'wmodulefortesting1@0.0.3' )
  .then( () =>
  {
    test.case = 'installed version, remote points to latest'
    let remotePath = 'npm:///wmodulefortesting1'
    var got = _.npm.hasRemote({ localPath, remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );
    return null;
  })

  install( 'wmodulefortesting1@0.0.3' )
  .then( () =>
  {
    test.case = 'installed version, remote points to beta'
    let remotePath = 'npm:///wmodulefortesting1@beta'
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
  {
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
  }
  test.close( 'string as a parameter' );

  test.open( 'map as a parameter' );
  {
    test.open( '0 dependants' );
    test.case = 'local relative';
    let got = await _.npm.dependantsRetrieve( { remotePath : 'wmodulefortesting12ab' } );
    let exp = 0;
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
  }
  test.close( 'map as a parameter' );
}

dependantsRetrieve.description =
`
Retrieves the number of dependent packages
`

//

async function dependantsRetrieveMultipleRequests( test )
{
  let names =
  [
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
    'wmodulefortesting1', 'wmodulefortesting1a', 'wmodulefortesting1b',
    'wmodulefortesting12', 'wmodulefortesting12ab', 'nonexistentPackageName',
    'wmodulefortesting1', 'wmodulefortesting1a', 'wmodulefortesting1b',
    'wmodulefortesting12', 'wmodulefortesting12ab', 'nonexistentPackageName',
    'wmodulefortesting1', 'wmodulefortesting1a', 'wmodulefortesting1b',
    'wmodulefortesting12', 'wmodulefortesting12ab', 'nonexistentPackageName',
    'wmodulefortesting1', 'wmodulefortesting1a', 'wmodulefortesting1b',
    'wmodulefortesting12', 'wmodulefortesting12ab', 'nonexistentPackageName',
  ];

  let namesResult =
  [
    4, 1, 1,
    1, 0, NaN,
    4, 1, 1,
    1, 0, NaN,
    4, 1, 1,
    1, 0, NaN,
    4, 1, 1,
    1, 0, NaN,
    4, 1, 1,
    1, 0, NaN,
    4, 1, 1,
    1, 0, NaN,
    4, 1, 1,
    1, 0, NaN,
    4, 1, 1,
    1, 0, NaN,
    4, 1, 1,
    1, 0, NaN,
    4, 1, 1,
    1, 0, NaN,
  ];

  let wrongNames =
  [
    'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName',
    'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName',
    'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName',
    'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName',
    'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName',
    'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName',
    'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName',
    'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName',
    'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName',
    'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName', 'nonexistentName',
  ]

  let wrongNamesResult =
  [
    NaN, NaN, NaN, NaN, NaN, NaN,
    NaN, NaN, NaN, NaN, NaN, NaN,
    NaN, NaN, NaN, NaN, NaN, NaN,
    NaN, NaN, NaN, NaN, NaN, NaN,
    NaN, NaN, NaN, NaN, NaN, NaN,
    NaN, NaN, NaN, NaN, NaN, NaN,
    NaN, NaN, NaN, NaN, NaN, NaN,
    NaN, NaN, NaN, NaN, NaN, NaN,
    NaN, NaN, NaN, NaN, NaN, NaN,
    NaN, NaN, NaN, NaN, NaN, NaN,
  ];

  test.case = 'array as a parameter';
  let got = await _.npm.dependantsRetrieve( names );
  let exp = namesResult;
  test.identical( got, exp );

  test.case = 'map as a parameter';
  got = await _.npm.dependantsRetrieve( { remotePath : names } );
  exp = namesResult;
  test.identical( got, exp );

  test.case = 'wrong names array';
  got = await _.npm.dependantsRetrieve( wrongNames );
  exp = wrongNamesResult;
  test.identical( got, exp );

}

dependantsRetrieveMultipleRequests.timeOut = 120000;
dependantsRetrieveMultipleRequests.description =
`
Retrieves dependants of each package in array
`

//

async function dependantsRetrieveStress( test )
{
  const temp =
  [
    'wmodulefortesting1', 'wmodulefortesting1a', 'wmodulefortesting1b',
    'wmodulefortesting12', 'wmodulefortesting12ab', 'nonexistentPackageName',
  ];
  const remotePath = [];
  const result = [];
  const l = 100;

  for( let i = 0; i < l; i++ )
  {
    remotePath.push( ... temp );
    result.push( 4, 1, 1, 1, 0, NaN );
  }

  test.case = `${remotePath.length} packages`;
  let got = await _.npm.dependantsRetrieve( { remotePath, verbosity : 3 } );
  let exp = result;
  test.identical( got, exp );

}

dependantsRetrieveStress.rapidity = -2;
dependantsRetrieveStress.timeOut = 300000;
dependantsRetrieveStress.description =
`
Stress testing
`

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
    suiteTempPath : null,
    assetsOriginalPath : null,
    appJsPath : null,
  },

  tests :
  {

    fixate,
    bump,

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
    dependantsRetrieveStress,

  },

}

//

var Self = new wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
