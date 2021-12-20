( function _NpmTools_test_ss_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../node_modules/Tools' );
  require( '../../l3/npm/Include.ss' );
  _.include( 'wTesting' );
}

const _ = _global_.wTools;
const __ = _globals_.testing.wTools;

// --
// context
// --

function onSuiteBegin( test )
{
  let context = this;
  context.suiteTempPath = _.path.tempOpen( _.path.join( __dirname, '../..' ), 'NpmTools' );
  context.assetsOriginalPath = _.path.join( __dirname, '_asset' );
}

//

function onSuiteEnd( test )
{
  let context = this;
  _.assert( _.strHas( context.suiteTempPath, 'NpmTools' ), context.suiteTempPath );
  _.path.tempClose( context.suiteTempPath );
}

// --
// tests
// --

function pathParse( test )
{

  test.case = 'basic';
  var remotePath = 'npm:///wmodulefortesting1'
  var exp =
  {
    'protocol' : 'npm',
    'longPath' : '/wmodulefortesting1',
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
    'localVcsPath' : '',
    'remoteVcsPath' : 'wmodulefortesting1',
    'remoteVcsLongerPath' : 'wmodulefortesting1@1.0.0',
    'isFixated' : true
  }
  var got = _.npm.pathParse( remotePath );
  test.identical( got, exp );

  test.case = 'tag';
  var remotePath = 'npm:///wmodulefortesting1!beta';
  var exp =
  {
    'protocol' : 'npm',
    'tag' : 'beta',
    'longPath' : '/wmodulefortesting1',
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
    'localVcsPath' : 'out/wmodulefortesting1',
    'remoteVcsPath' : 'wmodulefortesting1',
    'remoteVcsLongerPath' : 'wmodulefortesting1@0.3.100',
    'isFixated' : true
  }
  var got = _.npm.pathParse( remotePath );
  test.identical( got, exp );

  // test.case = 'tag only';
  // var remotePath = '!some tag'
  // var exp =
  // {
  //   'longPath' : '!some tag',
  //   'postfixedPath' : '!some tag',
  //   'localVcsPath' : '',
  //   'remoteVcsPath' : '',
  //   'remoteVcsLongerPath' : '!some tag',
  //   'isFixated' : true,
  // }
  // var got = _.npm.pathParse( remotePath );
  // test.identical( got, exp );
  // xxx

  if( !Config.debug )
  return;

  test.case = 'throwing';
  var remotePath = 'npm:///wmodulefortesting1#1.0.0!beta'
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
  test.true( _.strHas( got, /npm:\/\/\/wmodulefortesting1#.+/ ) );

  var remotePath = 'npm:///wmodulefortesting1#1.0.0'
  var got = _.npm.pathFixate( remotePath );
  test.true( _.strHas( got, /npm:\/\/\/wmodulefortesting1#.+/ ) );
  test.notIdentical( got, remotePath );

  var remotePath = 'npm:///wmodulefortesting1!beta'
  var got = _.npm.pathFixate( remotePath );
  test.true( _.strHas( got, /npm:\/\/\/wmodulefortesting1#.+/ ) );
  test.notIdentical( got, remotePath );

  var remotePath = 'npm:///wmodulefortesting1#1.0.0!beta'
  test.shouldThrowErrorSync( () => npm.pathFixate( remotePath ) );
}

//

function pathDownloadFromLocal( test )
{
  test.case = 'local path - root';
  var src = '/';
  var got = _.npm.pathDownloadFromLocal( src );
  test.identical( got, '/node_modules' );

  test.case = 'local path - absolute path, file without extension';
  var src = '/a/b/c';
  var got = _.npm.pathDownloadFromLocal( src );
  test.identical( got, '/a/b/c/node_modules' );

  test.case = 'local path - absolute path, file with extension';
  var src = '/a/b/c.d';
  var got = _.npm.pathDownloadFromLocal( src );
  test.identical( got, '/a/b/c.d/node_modules' );

  test.case = 'local path - absolute path, directory';
  var src = '/a/b/c/';
  var got = _.npm.pathDownloadFromLocal( src );
  test.identical( got, '/a/b/c/node_modules' );

  /* */

  test.case = 'local path - relative';
  var src = './';
  var got = _.npm.pathDownloadFromLocal( src );
  test.identical( got, './node_modules' );

  test.case = 'local path - relative path, file without extension';
  var src = './a/b/c';
  var got = _.npm.pathDownloadFromLocal( src );
  test.identical( got, './a/b/c/node_modules' );

  test.case = 'local path - relative path, file with extension';
  var src = './a/b/c.d';
  var got = _.npm.pathDownloadFromLocal( src );
  test.identical( got, './a/b/c.d/node_modules' );

  test.case = 'local path - relative path, directory';
  var src = './a/b/c/';
  var got = _.npm.pathDownloadFromLocal( src );
  test.identical( got, './a/b/c/node_modules' );

  /* */

  test.case = 'local path - relative';
  var src = '../';
  var got = _.npm.pathDownloadFromLocal( src );
  test.identical( got, '../node_modules' );

  test.case = 'local path - relative path, file without extension';
  var src = '../a/b/c';
  var got = _.npm.pathDownloadFromLocal( src );
  test.identical( got, '../a/b/c/node_modules' );

  test.case = 'local path - relative path, file with extension';
  var src = '../a/b/c.d';
  var got = _.npm.pathDownloadFromLocal( src );
  test.identical( got, '../a/b/c.d/node_modules' );

  test.case = 'local path - relative path, directory';
  var src = '../a/b/c/';
  var got = _.npm.pathDownloadFromLocal( src );
  test.identical( got, '../a/b/c/node_modules' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.npm.pathDownloadFromLocal() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.npm.pathDownloadFromLocal( '/', '/' ) );

  test.case = 'wrong type of localPath';
  test.shouldThrowErrorSync( () => _.npm.pathDownloadFromLocal( [] ) );
}

//

function fileFormat( test )
{
  let self = this;
  let a = test.assetFor( 'format' );

  const version = a.shell({ currentPath : a.path.current(), execPath : 'npm -v', sync : 1 }).output;
  const versionParts = version.match( /^(\d+)\.(\d+)/ );
  if( _.number.from( versionParts[ 1 ] ) >= 7 )
  return test.true( true );

  /* - */

  a.ready.then( () =>
  {
    test.case = 'package.json with only field bundledDependencies';
    a.reflect();
    a.fileProvider.filesReflect({ reflectMap : { [ a.abs( 'bundledDependencies.json' ) ] : a.abs( 'package.json' ) } });
    return null;
  });

  a.ready.then( () =>
  {
    var o = { configPath : a.abs( 'bundledDependencies.json' ) };
    var got = _.npm.fileFormat( o );
    test.true( got === o );
    return null;
  });

  a.shell( 'npm i' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    let npmConfig = a.fileProvider.fileRead( a.abs( 'package.json' ) );
    let npmToolsConfig = a.fileProvider.fileRead( a.abs( 'bundledDependencies.json' ) );
    test.identical( npmToolsConfig, npmConfig );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'package.json with only field dependencies';
    a.reflect();
    a.fileProvider.filesReflect({ reflectMap : { [ a.abs( 'dependencies.json' ) ] : a.abs( 'package.json' ) } });
    return null;
  });

  a.ready.then( () =>
  {
    var o = { configPath : a.abs( 'dependencies.json' ) };
    var got = _.npm.fileFormat( o );
    test.true( got === o );
    return null;
  });

  a.shell( 'npm i' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    let npmConfig = a.fileProvider.fileRead( a.abs( 'package.json' ) );
    let npmToolsConfig = a.fileProvider.fileRead( a.abs( 'dependencies.json' ) );
    test.identical( npmToolsConfig, npmConfig );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'package.json with only field devDependencies';
    a.reflect();
    a.fileProvider.filesReflect({ reflectMap : { [ a.abs( 'devDependencies.json' ) ] : a.abs( 'package.json' ) } });
    return null;
  });

  a.ready.then( () =>
  {
    var o = { configPath : a.abs( 'devDependencies.json' ) };
    var got = _.npm.fileFormat( o );
    test.true( got === o );
    return null;
  });

  a.shell( 'npm i' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    let npmConfig = a.fileProvider.fileRead( a.abs( 'package.json' ) );
    let npmToolsConfig = a.fileProvider.fileRead( a.abs( 'devDependencies.json' ) );
    test.identical( npmToolsConfig, npmConfig );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'package.json with only field peerDependencies';
    a.reflect();
    a.fileProvider.filesReflect({ reflectMap : { [ a.abs( 'peerDependencies.json' ) ] : a.abs( 'package.json' ) } });
    return null;
  });

  a.ready.then( () =>
  {
    var o = { configPath : a.abs( 'peerDependencies.json' ) };
    var got = _.npm.fileFormat( o );
    test.true( got === o );
    return null;
  });

  a.shell( 'npm i' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    let npmConfig = a.fileProvider.fileRead( a.abs( 'package.json' ) );
    let npmToolsConfig = a.fileProvider.fileRead( a.abs( 'peerDependencies.json' ) );
    test.identical( npmToolsConfig, npmConfig );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'package.json with only field peerDependenciesMeta';
    a.reflect();
    a.fileProvider.filesReflect({ reflectMap : { [ a.abs( 'peerDependenciesMeta.json' ) ] : a.abs( 'package.json' ) } });
    return null;
  });

  a.ready.then( () =>
  {
    var o = { configPath : a.abs( 'peerDependenciesMeta.json' ) };
    var got = _.npm.fileFormat( o );
    test.true( got === o );
    return null;
  });

  a.shell( 'npm i' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    let npmConfig = a.fileProvider.fileRead( a.abs( 'package.json' ) );
    let npmToolsConfig = a.fileProvider.fileRead( a.abs( 'peerDependenciesMeta.json' ) );
    test.identical( npmToolsConfig, npmConfig );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'compare full package.json file with many dependencies';
    a.reflect();
    a.fileProvider.filesReflect({ reflectMap : { [ a.abs( 'package.json' ) ] : a.abs( 'package2.json' ) } });
    return null;
  });

  a.ready.then( () =>
  {
    var o = { configPath : a.abs( 'package2.json' ) };
    var got = _.npm.fileFormat( o );
    test.true( got === o );
    return null;
  });

  a.shell( 'npm i' );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    let npmConfig = a.fileProvider.fileRead( a.abs( 'package.json' ) );
    let npmToolsConfig = a.fileProvider.fileRead( a.abs( 'package2.json' ) );
    test.identical( npmToolsConfig, npmConfig );
    return null;
  });

  /* - */

  return a.ready;
}

fileFormat.timeOut = 4e5;

//

function fileFixate( test )
{
  let self = this;
  let a = test.assetFor( 'fixate' ); /* aaa Artem : done. should be single call of assetFor per test routine */

  /* aaa Artem : done. simplify package.json files. remove redundant fields */

  test.open( 'dependency versions are specified' );

  test.case = 'without callback';

  a.reflect(); /* aaa Artem : done. reflect should be inside of test case, not outside */

  var localPath = a.abs( 'fixateNotEmptyVersions' );
  var tag = '=';
  var got = _.npm.fileFixate({ localPath, tag }).config;

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
  };
  /* aaa Artem : done. why fixateNotEmptyVersions is called only without callback onDep? */

  test.identical( got, exp );

  /* */

  test.case = 'with callback';

  a.reflect();

  var localPath = a.abs( 'fixateNotEmptyVersions' );
  var tag = '=';
  var o = { localPath, tag, onDep }
  var got = _.npm.fileFixate( o ).config;
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

  /* */

  test.case = 'check whole "got" map';

  a.reflect();

  var localPath = a.abs( 'fixateNotEmptyVersions' );
  var tag = '=';
  var got = _.npm.fileFixate({ localPath, tag });

  test.true( _.strDefined( got.localPath ) );
  test.true( _.strDefined( got.configPath ) );
  test.identical( got.tag, '=' );
  test.identical( got.onDep, null );
  test.identical( got.dry, 0 );
  test.identical( got.logger, 0 );
  test.identical( got.changed, false );

  /* */

  test.case = 'read written config';

  a.reflect();

  var localPath = a.abs( 'fixateNotEmptyVersions' );
  var tag = '=';
  _.npm.fileFixate({ localPath, tag });
  var got = _.fileProvider.fileReadUnknown({ filePath : a.abs( 'fixateNotEmptyVersions/package.json' ) });
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
  var got = _.npm.fileFixate( { localPath, tag } ).config;
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

  /* */

  test.case = 'read written config';

  a.reflect();

  var localPath = a.abs( 'fixateEmptyVersions' );
  var tag = '=';
  _.npm.fileFixate({ localPath, tag });
  var got = _.fileProvider.fileReadUnknown({ filePath : a.abs( 'fixateEmptyVersions/package.json' ) });
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

  /* */

  test.case = 'with callback';

  a.reflect();

  var localPath = a.abs( 'fixateEmptyVersions' );
  var tag = '=';
  var o = { localPath, tag, onDep }
  var got = _.npm.fileFixate( o ).config;
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

  function onDep( dep )
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

fileFixate.description =
`
Fixates versions of the dependecies in provided package
`;

//

function fileBump( test )
{
  const context = this;
  const a = test.assetFor( 'bump' );

  /* */

  test.case = 'package.json has no version, localPath';
  a.reflect();
  a.fileProvider.fileWriteUnknown( a.abs( 'package.json' ), { name : 'test' } )
  test.identical( a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) ).version, undefined );
  var got = _.npm.fileBump({ localPath : a.abs( '.' ) });
  var exp = [ 'localPath', 'config', 'logger', 'dry', 'configPath', 'nativizing', 'onChange', 'changed' ];
  test.identical( _.props.keys( got ), exp );
  test.identical( got.config, a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) ) );
  test.identical( got.config.version, '0.0.1' );
  test.identical( got.localPath, a.abs( '.' ) );
  test.identical( got.configPath, a.abs( 'package.json' ) );

  /* */

  test.case = 'only localPath';
  a.reflect();
  var got = _.npm.fileBump({ localPath : a.abs( '.' ) });
  var exp = [ 'localPath', 'config', 'logger', 'dry', 'configPath', 'nativizing', 'onChange', 'changed' ];
  test.identical( _.props.keys( got ), exp );
  test.identical( got.config, a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) ) );
  test.identical( got.config.version, '0.0.1' );
  test.identical( got.localPath, a.abs( '.' ) );
  test.identical( got.configPath, a.abs( 'package.json' ) );

  /* */

  test.case = 'only configPath';
  a.reflect();
  var got = _.npm.fileBump({ configPath : a.abs( 'package.json' ) });
  var exp = [ 'configPath', 'config', 'logger', 'dry', 'localPath', 'nativizing', 'onChange', 'changed' ];
  test.identical( _.props.keys( got ), exp );
  test.identical( got.config, a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) ) );
  test.identical( got.config.version, '0.0.1' );
  test.identical( got.localPath, null );
  test.identical( got.configPath, a.abs( 'package.json' ) );

  /* */

  test.case = 'config and localPath';
  a.reflect();
  var got = _.npm.fileBump({ localPath : a.abs( '.' ), config : a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) ) });
  var exp = [ 'localPath', 'config', 'logger', 'dry', 'configPath', 'nativizing', 'onChange', 'changed' ];
  test.identical( _.props.keys( got ), exp );
  test.identical( got.config, a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) ) );
  test.identical( got.config.version, '0.0.1' );
  test.identical( got.localPath, a.abs( '.' ) );
  test.identical( got.configPath, a.abs( 'package.json' ) );

  /* */

  test.case = 'config and configPath';
  a.reflect();
  var got = _.npm.fileBump({ configPath : a.abs( 'package.json' ), config : a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) ) });
  var exp = [ 'configPath', 'config', 'logger', 'dry', 'localPath', 'nativizing', 'onChange', 'changed' ];
  test.identical( _.props.keys( got ), exp );
  test.identical( got.config, a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) ) );
  test.identical( got.config.version, '0.0.1' );
  test.identical( got.localPath, null );
  test.identical( got.configPath, a.abs( 'package.json' ) );

  /* */

  test.case = 'config, localPath and configPath';
  a.reflect();
  var got = _.npm.fileBump
  ({
    localPath : a.abs( '.' ),
    configPath : a.abs( 'package.json' ),
    config : a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) )
  });
  var exp = [ 'localPath', 'configPath', 'config', 'logger', 'dry', 'nativizing', 'onChange', 'changed' ];
  test.identical( _.props.keys( got ), exp );
  test.identical( got.config, a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) ) );
  test.identical( got.config.version, '0.0.1' );
  test.identical( got.localPath, a.abs( '.' ) );
  test.identical( got.configPath, a.abs( 'package.json' ) );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.npm.fileFormat() );

  test.case = 'extra arguments';
  var o = { localPath : a.abs( '.' ) };
  test.shouldThrowErrorSync( () => _.npm.fileFormat( o, o ) );

  test.case = 'wrong type of options map';
  var o = { localPath : a.abs( '.' ) };
  test.shouldThrowErrorSync( () => _.npm.fileFormat([ o ]) );

  test.case = 'options map has unknown field';
  var o = { localPath : a.abs( '.' ), unknown : 1 };
  test.shouldThrowErrorSync( () => _.npm.fileFormat( o ) );

  test.case = 'none configPath and localPath exist';
  var o = { config : { version : '0.0.1' } };
  test.shouldThrowErrorSync( () => _.npm.fileFormat( o ) );

  test.case = 'option onChange, should not overwrite callback';
  var o = { localPath : a.abs( '.' ), onChange : () => null };
  test.shouldThrowErrorSync( () => _.npm.fileFormat( o ) );

  test.case = 'option changed, should not define before execution';
  var o = { localPath : a.abs( '.' ), changed : true };
  test.shouldThrowErrorSync( () => _.npm.fileFormat( o ) );
}

fileBump.description =
`
Bumps package version
`;

//

function fileBumpCheckOptions( test )
{
  const context = this;
  const a = test.assetFor( 'bump' );
  const version = a.shell({ currentPath : a.path.current(), execPath : 'npm -v', sync : 1 }).output;
  let programPath;

  /* - */

  a.ready.then( () =>
  {
    test.case = 'localPath, dry - 1';
    a.reflect();
    var got = _.npm.fileBump({ localPath : a.abs( '.' ), dry : 1 });
    var exp = [ 'localPath', 'dry', 'config', 'logger', 'configPath', 'nativizing', 'onChange', 'changed' ];
    test.identical( _.props.keys( got ), exp );
    var expConfig = a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) );
    test.notIdentical( got.config, expConfig );
    test.identical( got.config.version, '0.0.1' );
    test.identical( expConfig.version, '0.0.0' );
    test.identical( got.localPath, a.abs( '.' ) );
    test.identical( got.configPath, a.abs( 'package.json' ) );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'bump with logger - 0';
    a.reflect();
    programPath = a.program({ entry : testApp, locals : { logger : 0 } }).filePath;
    return null;
  });
  a.shell( `node ${ a.path.nativize( programPath ) }` );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( op.output, '' );
    var exp =
    {
      'name' : 'test',
      'version' : '0.0.1',
      'devDependencies' : { 'wTesting' : '', 'wmodulefortesting1' : 'alpha' },
      'optionalDependencies' : { 'wmodulefortesting2b' : '', 'wmodulefortesting2a' : '' },
      'bundledDependencies' : [ 'wmodulefortesting2', 'wmodulefortesting1b', 'wmodulefortesting1a' ]
    };
    test.identical( a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) ), exp );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'bump with logger - 1';
    a.reflect();
    programPath = a.program({ entry : testApp, locals : { logger : 1 } }).filePath;
    return null;
  });
  a.shell( `node ${ a.path.nativize( programPath ) }` );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var exp = `Rewriting ${ a.abs( a.path.dir( programPath ), 'package.json' ) }`;
    test.contains( op.output, exp );
    var exp =
    {
      'name' : 'test',
      'version' : '0.0.1',
      'devDependencies' : { 'wTesting' : '', 'wmodulefortesting1' : 'alpha' },
      'optionalDependencies' : { 'wmodulefortesting2b' : '', 'wmodulefortesting2a' : '' },
      'bundledDependencies' : [ 'wmodulefortesting2', 'wmodulefortesting1b', 'wmodulefortesting1a' ]
    };
    test.identical( a.fileProvider.fileReadUnknown( a.abs( 'package.json' ) ), exp );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'bump with logger - 3';
    a.reflect();
    programPath = a.program({ entry : testApp, locals : { logger : 3 } }).filePath;
    return null;
  });
  a.shell( `node ${ a.path.nativize( programPath ) }` );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    var exp =
`Rewriting ${ a.abs( a.path.dir( programPath ), 'package.json' ) }
  {
    "name": "test",
    "version": "0.0.1",
    "devDependencies": {
      "wTesting": "",
      "wmodulefortesting1": "alpha"
    },
    "optionalDependencies": {
      "wmodulefortesting2b": "",
      "wmodulefortesting2a": ""
    },
    "bundledDependencies": [
      "wmodulefortesting2",
      "wmodulefortesting1b",
      "wmodulefortesting1a"
    ]
  }`;
    test.contains( op.output, exp );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'nativizing - 0';
    a.reflect();
    _.npm.fileBump({ localPath : a.abs( '.' ), nativizing : 0 });
    a.fileProvider.filesReflect({ reflectMap : { [ a.abs( 'package.json' ) ] : a.abs( 'original.json' ) } });
    return null;
  });
  a.shell( `npm i` );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    let originalConfig = a.fileProvider.fileRead( a.abs( 'original.json' ) );
    let newConfig = a.fileProvider.fileRead( a.abs( 'package.json' ) );
    if( Number( process.versions.node.substring( 0, 2 ) ) <= 15 )
    test.notIdentical( originalConfig, newConfig );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'nativizing - 1';
    a.reflect();
    _.npm.fileBump({ localPath : a.abs( '.' ), nativizing : 1 });
    a.fileProvider.filesReflect({ reflectMap : { [ a.abs( 'package.json' ) ] : a.abs( 'original.json' ) } });
    return null;
  });
  a.shell( `npm i` );
  a.ready.then( ( op ) =>
  {
    const versionParts = version.match( /^(\d+)\.(\d+)/ );
    if( _.number.from( versionParts[ 1 ] ) >= 7 )
    return test.true( true );
    test.identical( op.exitCode, 0 );
    let originalConfig = a.fileProvider.fileRead( a.abs( 'original.json' ) );
    let newConfig = a.fileProvider.fileRead( a.abs( 'package.json' ) );
    test.identical( originalConfig, newConfig );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function testApp()
  {
    const _ = require( toolsPath );
    _.include( 'wNpmTools' );
    _.npm.fileBump({ localPath : __dirname, logger });
  }
}

fileBumpCheckOptions.timeOut = 220000;

//

function depAdd( test )
{
  let self = this;
  let a = test.assetFor( false );

  /* - */

  begin().then( () =>
  {
    test.case = 'as === module.name';
    return null;
  });
  a.ready.then( () =>
  {
    var got = _.npm.depAdd
    ({
      as : 'wmodulefortesting1',
      depPath : `hd://${ a.abs( 'wModuleForTesting1' ) }`,
      localPath : a.abs( '.' ),
      editing : 0,
    });
    test.identical( got, true );
    test.true( a.fileProvider.areSoftLinked( a.abs( 'node_modules/wmodulefortesting1' ), a.abs( 'wModuleForTesting1' ) ) );
    var files = find( 'node_modules' );
    test.identical( files, [ '.', './wmodulefortesting1', './wmodulefortesting2' ] );

    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'as === module.name, dry - 1';
    return null;
  });
  a.ready.then( () =>
  {
    var got = _.npm.depAdd
    ({
      as : 'wmodulefortesting1',
      depPath : `hd://${ a.abs( 'wModuleForTesting1' ) }`,
      localPath : a.abs( '.' ),
      dry : 1,
      editing : 0,
    });
    test.identical( got, true );
    test.false( a.fileProvider.fileExists( a.abs( 'node_modules/wmodulefortesting1' ) ) );
    test.false( a.fileProvider.areSoftLinked( a.abs( 'node_modules/wmodulefortesting1' ), a.abs( 'wModuleForTesting1' ) ) );
    var files = find( 'node_modules' );
    test.identical( files, [ '.', './wmodulefortesting2' ] );

    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'as !== module.name';
    return null;
  });
  a.ready.then( () =>
  {
    var got = _.npm.depAdd
    ({
      as : 'modulefortesting',
      depPath : `hd://${ a.abs( 'wModuleForTesting1' ) }`,
      localPath : a.abs( '.' ),
      editing : 0,
    });
    test.identical( got, true );
    test.true( a.fileProvider.areSoftLinked( a.abs( 'node_modules/modulefortesting' ), a.abs( 'wModuleForTesting1' ) ) );
    var files = find( 'node_modules' );
    test.identical( files, [ '.', './modulefortesting', './wmodulefortesting2' ] );

    return null;
  });

  /* */

  let filesBefore;
  begin().then( () =>
  {
    test.case = 'rewrite soft link to module by another link';
    filesBefore = a.find( a.abs( 'wModuleForTesting1' ) );
    return null;
  });
  a.ready.then( () =>
  {
    var got = _.npm.depAdd
    ({
      as : 'wmodulefortesting1',
      depPath : `hd://${ a.abs( 'wModuleForTesting1' ) }`,
      localPath : a.abs( '.' ),
      editing : 0,
    });
    test.identical( got, true );
    test.true( a.fileProvider.areSoftLinked( a.abs( 'node_modules/wmodulefortesting1' ), a.abs( 'wModuleForTesting1' ) ) );
    var files = find( 'node_modules' );
    test.identical( files, [ '.', './wmodulefortesting1', './wmodulefortesting2' ] );

    return null;
  });
  a.shell( 'git clone https://github.com/Wandalen/wModuleForTesting2.git wModuleForTesting2' );
  a.ready.then( () =>
  {
    var got = _.npm.depAdd
    ({
      as : 'wmodulefortesting1',
      depPath : `hd://${ a.abs( 'wModuleForTesting2' ) }`,
      localPath : a.abs( '.' ),
      editing : 0,
    });
    test.identical( got, true );
    test.false( a.fileProvider.areSoftLinked( a.abs( 'node_modules/wmodulefortesting1' ), a.abs( 'wModuleForTesting1' ) ) );
    test.true( a.fileProvider.areSoftLinked( a.abs( 'node_modules/wmodulefortesting1' ), a.abs( 'wModuleForTesting2' ) ) );
    var files = find( 'node_modules' )
    test.identical( files, [ '.', './wmodulefortesting1', './wmodulefortesting2' ] );
    var filesAfter = a.find( a.abs( 'wModuleForTesting1' ) );
    test.identical( filesBefore, filesAfter );

    return null;
  });

  /* */

  if( Config.debug )
  begin().then( () =>
  {
    test.case = 'without arguments';
    test.shouldThrowErrorSync( () => _.npm.depAdd() );

    test.case = 'extra arguments';
    var o = { as : 'wmodulefortesting1', depPath : `hd://${ a.abs( 'wmodulefortesting1' ) }`, localPath : a.abs( '.' ) };
    test.shouldThrowErrorSync( () => _.npm.depAdd( o, o ) );

    test.case = 'wrong type of options map o';
    test.shouldThrowErrorSync( () => _.npm.depAdd( 'wrong' ) );

    test.case = 'unknown option in options map o';
    var o =
    {
      as : 'wmodulefortesting1',
      depPath : `hd://${ a.abs( 'wmodulefortesting1' ) }`,
      localPath : a.abs( '.' ),
      unknown : 1,
    };
    test.shouldThrowErrorSync( () => _.npm.depAdd( o ) );

    test.case = 'o.depPath is not defined string';
    var o = { as : 'wmodulefortesting1', depPath : '', localPath : a.abs( '.' ) };
    test.shouldThrowErrorSync( () => _.npm.depAdd( o ) );

    test.case = 'o.localPath does not exists';
    var o = { as : 'wmodulefortesting1', depPath : `hd://${ a.abs( 'wmodulefortesting1' ) }`, localPath : a.abs( 'not_existed' ) };
    test.shouldThrowErrorSync( () => _.npm.depAdd( o) );

    test.case = 'o.depPath does not exists';
    var o = { as : 'wmodulefortesting1', depPath : `hd://${ a.abs( 'not_existed' ) }`, localPath : a.abs( '.' ) };
    test.shouldThrowErrorSync( () => _.npm.depAdd( o) );

    test.case = 'o.as is not defined string';
    var o = { as : '', depPath : `hd://${ a.abs( 'wmodulefortesting1' ) }`, localPath : a.abs( '.' ) };
    test.shouldThrowErrorSync( () => _.npm.depAdd( o) );

    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.filesDelete( a.abs( '.' ) ); return null });
    a.ready.then( () =>
    {
      a.fileProvider.dirMake( a.abs( 'node_modules' ) );
      a.fileProvider.dirMake( a.abs( 'node_modules/wmodulefortesting2' ) );
      return null
    });
    a.shell( 'git clone https://github.com/Wandalen/wModuleForTesting1.git wModuleForTesting1' );
    return a.ready;
  }

  /* */

  function find( filePath )
  {
    return a.fileProvider.filesFind
    ({
      filePath : a.abs( filePath ),
      filter : { recursive : 1 },
      outputFormat : 'relative',
      withDirs : 1,
    });
  }
}

//

function install( test )
{
  let self = this;
  let a = test.assetFor( 'install' );

  /* - */

  begin().then( () =>
  {
    test.case = 'default options, package-lock.json exists';
    var got = _.npm.install({ localPath : a.abs( '.' ) });
    test.identical( got, true );
    var files = find( 'node_modules' );
    var exp = [ '.', './test', './wmodulefortesting1', './wmodulefortesting12', './wmodulefortesting2' ];
    if( files.length === 6 )
    var exp = [ '.', './.package-lock.json', './test', './wmodulefortesting1', './wmodulefortesting12', './wmodulefortesting2' ];
    test.identical( files, exp );
    test.identical( versionGet( 'wmodulefortesting1' ), '0.0.134' );
    test.identical( versionGet( 'wmodulefortesting2' ), '0.0.125' );
    test.identical( versionGet( 'wmodulefortesting12' ), '0.0.125' );

    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'default options directly, package-lock.json exists';
    var got = _.npm.install
    ({
      localPath : a.abs( '.' ),
      locked : null,
      linkingSelf : null,
      logger : 0,
      dry : 0,
      sync : 1,
    });
    test.identical( got, true );
    var files = find( 'node_modules' );
    var exp = [ '.', './test', './wmodulefortesting1', './wmodulefortesting12', './wmodulefortesting2' ];
    if( files.length === 6 )
    var exp = [ '.', './.package-lock.json', './test', './wmodulefortesting1', './wmodulefortesting12', './wmodulefortesting2' ];
    test.identical( files, exp );
    test.identical( versionGet( 'wmodulefortesting1' ), '0.0.134' );
    test.identical( versionGet( 'wmodulefortesting2' ), '0.0.125' );
    test.identical( versionGet( 'wmodulefortesting12' ), '0.0.125' );

    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'locked - 0, package-lock.json exists';
    var got = _.npm.install
    ({
      localPath : a.abs( '.' ),
      locked : 0,
      linkingSelf : null,
      logger : 0,
      dry : 0,
      sync : 1,
    });
    test.identical( got, true );
    var files = find( 'node_modules' );
    var exp = [ '.', './test', './wmodulefortesting1', './wmodulefortesting12', './wmodulefortesting2' ];
    if( files.length === 6 )
    var exp = [ '.', './.package-lock.json', './test', './wmodulefortesting1', './wmodulefortesting12', './wmodulefortesting2' ];
    test.identical( files, exp );
    test.notIdentical( versionGet( 'wmodulefortesting1' ), '0.0.134' );
    test.notIdentical( versionGet( 'wmodulefortesting2' ), '0.0.125' );
    test.notIdentical( versionGet( 'wmodulefortesting12' ), '0.0.125' );

    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'locked - 0, package-lock.json not exists';
    a.fileProvider.filesDelete( a.abs( 'package-lock.json' ) );
    var got = _.npm.install
    ({
      localPath : a.abs( '.' ),
      locked : 0,
      linkingSelf : null,
      logger : 0,
      dry : 0,
      sync : 1,
    });
    test.identical( got, true );
    var files = find( 'node_modules' );
    var exp = [ '.', './test', './wmodulefortesting1', './wmodulefortesting12', './wmodulefortesting2' ];
    if( files.length === 6 )
    var exp = [ '.', './.package-lock.json', './test', './wmodulefortesting1', './wmodulefortesting12', './wmodulefortesting2' ];
    test.identical( files, exp );
    test.notIdentical( versionGet( 'wmodulefortesting1' ), '0.0.134' );
    test.notIdentical( versionGet( 'wmodulefortesting2' ), '0.0.125' );
    test.notIdentical( versionGet( 'wmodulefortesting12' ), '0.0.125' );

    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'locked - 1, package-lock.json exists';
    var got = _.npm.install
    ({
      localPath : a.abs( '.' ),
      locked : 1,
      linkingSelf : null,
      logger : 0,
      dry : 0,
      sync : 1,
    });
    test.identical( got, true );
    var files = find( 'node_modules' );
    var exp = [ '.', './test', './wmodulefortesting1', './wmodulefortesting12', './wmodulefortesting2' ];
    if( files.length === 6 )
    var exp = [ '.', './.package-lock.json', './test', './wmodulefortesting1', './wmodulefortesting12', './wmodulefortesting2' ];
    test.identical( files, exp );
    test.identical( versionGet( 'wmodulefortesting1' ), '0.0.134' );
    test.identical( versionGet( 'wmodulefortesting2' ), '0.0.125' );
    test.identical( versionGet( 'wmodulefortesting12' ), '0.0.125' );

    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'linkingSelf - 0';
    var got = _.npm.install
    ({
      localPath : a.abs( '.' ),
      locked : 1,
      linkingSelf : 0,
      logger : 0,
      dry : 0,
      sync : 1,
    });
    test.identical( got, null );
    var files = find( 'node_modules' );
    var exp = [ '.', './wmodulefortesting1', './wmodulefortesting12', './wmodulefortesting2' ];
    if( files.length === 5 )
    var exp = [ '.', './.package-lock.json', './wmodulefortesting1', './wmodulefortesting12', './wmodulefortesting2' ];
    test.identical( files, exp );

    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'linkingSelf - 1';
    var got = _.npm.install
    ({
      localPath : a.abs( '.' ),
      locked : 1,
      linkingSelf : 1,
      logger : 0,
      dry : 0,
      sync : 1,
    });
    test.identical( got, true );
    var files = find( 'node_modules' );
    var exp = [ '.', './test', './wmodulefortesting1', './wmodulefortesting12', './wmodulefortesting2' ];
    if( files.length === 6 )
    var exp = [ '.', './.package-lock.json', './test', './wmodulefortesting1', './wmodulefortesting12', './wmodulefortesting2' ];
    test.identical( files, exp );

    return null;
  });

  /* */

  begin().then( () =>
  {
    test.case = 'dry - 1';
    var got = _.npm.install
    ({
      localPath : a.abs( '.' ),
      locked : 1,
      linkingSelf : 1,
      logger : 0,
      dry : 1,
      sync : 1,
    });
    test.identical( got, true );
    var files = find( 'node_modules' );
    test.identical( files, [] );

    return null;
  });

  /* */

  if( Config.debug )
  {
    begin().then( () =>
    {
      test.case = 'without arguments';
      test.shouldThrowErrorSync( () => _.npm.install() );

      test.case = 'extra arguments';
      var o = { localPath : a.abs( '.' ) };
      test.shouldThrowErrorSync( () => _.npm.install( o, o ) );

      test.case = 'wrong type of options map o';
      test.shouldThrowErrorSync( () => _.npm.install( 'wrong' ) );

      test.case = 'unknown option in options map o';
      var o = { localPath : a.abs( '.' ), unknown : 1 };
      test.shouldThrowErrorSync( () => _.npm.install( o ) );

      test.case = 'o.localPath is not defined string';
      var o = { localPath : '' };
      test.shouldThrowErrorSync( () => _.npm.install( o ) );

      test.case = 'o.localPath is not a directory';
      var o = { localPath : a.abs( 'package.json' ) };
      test.shouldThrowErrorSync( () => _.npm.install( o ) );

      return null;
    });

    /* */

    begin().then( () =>
    {
      test.case = 'locked - 1, package-lock.json not exists';
      a.fileProvider.filesDelete( a.abs( 'package-lock.json' ) );
      var o = { localPath : a.abs( '.' ), locked : 1 };
      test.shouldThrowErrorSync( () => _.npm.install( o ) );
      return null;
    });
  }

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => a.reflect() );
    return a.ready;
  }

  /* */

  function find( filePath )
  {
    return a.fileProvider.filesFind
    ({
      filePath : a.abs( filePath ),
      filter : { recursive : 1 },
      outputFormat : 'relative',
      withDirs : 1,
    });
  }

  /* */

  function versionGet( dirName )
  {
    return a.fileProvider.configRead
    ({
      filePath : a.abs( 'node_modules', dirName, 'package.json' ),
      encoding : 'json',
    }).version;
  }
}

install.timeOut = 60000;

//

function installCheckOptionLinkingSelf( test )
{
  let self = this;
  let a = test.assetFor( false );

  let packageData =
  {
    dependencies :
    {
      wmodulefortesting1 : '',
      wmodulefortesting12 : '',
    }
  };

  /* - */

  begin( packageData );
  a.ready.then( () =>
  {
    test.case = 'linkingSelf - 0, name does not exists';
    var got = _.npm.install
    ({
      localPath : a.abs( '.' ),
      linkingSelf : 0,
      sync : 1,
    });
    test.identical( got, null );
    var files = find( 'node_modules' );
    var exp = [ '.', './wmodulefortesting1', './wmodulefortesting12', './wmodulefortesting2' ];
    if( files.length === 5 )
    var exp = [ '.', './.package-lock.json', './wmodulefortesting1', './wmodulefortesting12', './wmodulefortesting2' ];
    test.identical( files, exp );

    return null;
  });

  /* */

  begin( _.map.extend( null, packageData, { name : 'test' } ) );
  a.ready.then( () =>
  {
    test.case = 'linkingSelf - 0, name exists';
    var got = _.npm.install
    ({
      localPath : a.abs( '.' ),
      linkingSelf : 0,
      sync : 1,
    });
    test.identical( got, null );
    var files = find( 'node_modules' );
    var exp = [ '.', './wmodulefortesting1', './wmodulefortesting12', './wmodulefortesting2' ];
    if( files.length === 5 )
    var exp = [ '.', './.package-lock.json', './wmodulefortesting1', './wmodulefortesting12', './wmodulefortesting2' ];
    test.identical( files, exp );

    return null;
  });

  /* */

  begin( packageData );
  a.ready.then( () =>
  {
    test.case = 'linkingSelf - 1, name does not exists';
    return test.shouldThrowErrorSync( () =>
    {
      return _.npm.install
      ({
        localPath : a.abs( '.' ),
        linkingSelf : 1,
        sync : 1,
      });
    });
  });

  /* */

  begin( _.map.extend( null, packageData, { name : 'test' } ) );
  a.ready.then( () =>
  {
    test.case = 'linkingSelf - 1, name exists';
    var got = _.npm.install
    ({
      localPath : a.abs( '.' ),
      linkingSelf : 1,
      sync : 1,
    });
    test.identical( got, true );
    var files = find( 'node_modules' );
    var exp = [ '.', './test', './wmodulefortesting1', './wmodulefortesting12', './wmodulefortesting2' ];
    if( files.length === 6 )
    var exp = [ '.', './.package-lock.json', './test', './wmodulefortesting1', './wmodulefortesting12', './wmodulefortesting2' ];
    test.identical( files, exp );

    return null;
  });

  /* */

  begin( packageData );
  a.ready.then( () =>
  {
    test.case = 'linkingSelf - null, name does not exists';
    var got = _.npm.install
    ({
      localPath : a.abs( '.' ),
      linkingSelf : null,
      sync : 1,
    });
    test.identical( got, null );
    var files = find( 'node_modules' );
    var exp = [ '.', './wmodulefortesting1', './wmodulefortesting12', './wmodulefortesting2' ];
    if( files.length === 5 )
    var exp = [ '.', './.package-lock.json', './wmodulefortesting1', './wmodulefortesting12', './wmodulefortesting2' ];
    test.identical( files, exp );

    return null;
  });

  /* */

  begin( _.map.extend( null, packageData, { name : 'test' } ) );
  a.ready.then( () =>
  {
    test.case = 'linkingSelf - null, name exists';
    var got = _.npm.install
    ({
      localPath : a.abs( '.' ),
      linkingSelf : null,
      sync : 1,
    });
    test.identical( got, true );
    var files = find( 'node_modules' );
    var exp = [ '.', './test', './wmodulefortesting1', './wmodulefortesting12', './wmodulefortesting2' ];
    if( files.length === 6 )
    var exp = [ '.', './.package-lock.json', './test', './wmodulefortesting1', './wmodulefortesting12', './wmodulefortesting2' ];
    test.identical( files, exp );

    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin( data )
  {
    a.ready.then( () =>
    {
      a.fileProvider.filesDelete( a.abs( '.' ) );
      a.fileProvider.fileWriteUnknown({ filePath : a.abs( 'package.json' ), data });
      return null;
    });
    return a.ready;
  }

  /* */

  function find( filePath )
  {
    return a.fileProvider.filesFind
    ({
      filePath : a.abs( filePath ),
      filter : { recursive : 1 },
      outputFormat : 'relative',
      withDirs : 1,
    });
  }
}

installCheckOptionLinkingSelf.timeOut = 60000;

//

function installLocalPathIsSoftLink( test )
{
  let self = this;
  let a = test.assetFor( 'install' );

  if( !Config.debug )
  return test.true( true );

  /* - */

  begin().then( () =>
  {
    test.case = 'o.localPath - soft link';
    var o =
    {
      localPath : a.abs( 'module/soft' ),
      locked : 1,
      linkingSelf : 1,
      logger : 0,
      dry : 0,
      sync : 1,
    };
    test.shouldThrowErrorSync( () => _.npm.install( o ) );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () =>
    {
      let srcPath = a.abs( 'soft' );
      a.fileProvider.dirMake( srcPath );
      a.fileProvider.filesReflect({ reflectMap : { [ a.originalAssetPath ] : srcPath } });
      a.fileProvider.dirMake( a.abs( 'module' ) );
      a.fileProvider.softLink
      ({
        dstPath : a.abs( 'module/soft' ),
        srcPath,
        makingDirectory : 1,
        rewritingDirs : 1,
      });
      return null;
    });
    return a.ready;
  }
}

//

function versionLog( test )
{
  let self = this;
  let a = test.assetFor( false );
  begin();

  /* - */

  a.ready.then( () =>
  {
    test.case = 'default options, localPath and remotePath';
    return _.npm.versionLog
    ({
      localPath : a.abs( '.' ),
      remotePath : 'wmodulefortesting1',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( _.strCount( op, 'Latest version of wmodulefortesting1 : ' ), 1 );
    test.identical( _.strCount( op, 'Stable version of wmodulefortesting1 :' ), 0 );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'tags - latest';
    return _.npm.versionLog
    ({
      localPath : a.abs( '.' ),
      remotePath : 'wmodulefortesting1',
      tags : [ 'latest' ],
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( _.strCount( op, 'Current version :' ), 1 );
    test.identical( _.strCount( op, 'Latest version of wmodulefortesting1 :' ), 1 );
    test.identical( _.strCount( op, 'Stable version of wmodulefortesting1 :' ), 0 );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'tags - stable';
    return _.npm.versionLog
    ({
      localPath : a.abs( '.' ),
      remotePath : 'wmodulefortesting1',
      tags : [ 'stable' ],
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( _.strCount( op, 'Current version :' ), 1 );
    test.identical( _.strCount( op, 'Latest version of wmodulefortesting1 :' ), 0 );
    test.identical( _.strCount( op, 'Stable version of wmodulefortesting1 :' ), 1 );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'tags - latest, stable, alpha, all exist';
    return _.npm.versionLog
    ({
      localPath : a.abs( '.' ),
      remotePath : 'wmodulefortesting1',
      tags : [ 'latest', 'stable', 'alpha' ],
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( _.strCount( op, 'Current version :' ), 1 );
    test.identical( _.strCount( op, 'Latest version of wmodulefortesting1 :' ), 1 );
    test.identical( _.strCount( op, 'Stable version of wmodulefortesting1 :' ), 1 );
    test.identical( _.strCount( op, 'alpha version of wmodulefortesting1 :' ), 1 );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'tags - latest, stable, abcd, not all exist';
    return _.npm.versionLog
    ({
      localPath : a.abs( '.' ),
      remotePath : 'wmodulefortesting1',
      tags : [ 'latest', 'stable', 'abcd' ],
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( _.strCount( op, 'Current version :' ), 1 );
    test.identical( _.strCount( op, 'Latest version of wmodulefortesting1 :' ), 1 );
    test.identical( _.strCount( op, 'Stable version of wmodulefortesting1 :' ), 1 );
    test.identical( _.strCount( op, 'abcd version of wmodulefortesting1 : -no-' ), 1 );
    return null;
  });

  /* */

  if( Config.debug )
  {
    a.ready.then( () =>
    {
      test.case = 'without arguments';
      test.shouldThrowErrorSync( () => _.npm.versionLog() );

      test.case = 'extra arguments';
      var o = { configPath : a.abs( 'package.json' ), remotePath : 'wmodulefortesting1' };
      test.shouldThrowErrorSync( () => _.npm.versionLog( o, o ) );

      test.case = 'unknown option in options map';
      var o = { configPath : a.abs( 'package.json' ), remotePath : 'wmodulefortesting1', unknown : 1 };
      test.shouldThrowErrorSync( () => _.npm.versionLog( o ) );

      test.case = 'o.tags has invalid value';
      var o = { configPath : a.abs( 'package.json' ), remotePath : '', tags : [ 'stable', 1 ] };
      test.shouldThrowErrorSync( () => _.npm.versionLog( o ) );

      test.case = 'wrong type of o.tags';
      var o = { configPath : a.abs( 'package.json' ), remotePath : '', tags : { a : 'b' } };
      test.shouldThrowErrorSync( () => _.npm.versionLog( o ) );

      test.case = 'o.remotePath - undefined and o.localPath not path to module';
      var o = { configPath : a.abs( 'package.json' ), localPath : a.abs( '../unknown' ) };
      test.shouldThrowErrorSync( () => _.npm.versionLog( o ) );

      test.case = 'o.remotePath is not defined';
      var o = { configPath : a.abs( 'package.json' ), remotePath : '' };
      test.shouldThrowErrorSync( () => _.npm.versionLog( o ) );

      return null;
    });
  }

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( 'git clone https://github.com/Wandalen/wModuleForTesting1.git ./' );
    return a.ready;
  }
}

//

function versionLogWithOptions( test )
{
  const self = this;
  const a = test.assetFor( false );
  let filePath/*programPath*/;
  begin();

  const programShell = _.process.starter
  ({
    currentPath : a.abs( '.' ),
    mode : 'shell',
    throwingExitCode : 1,
    outputCollecting : 1,
  });

  /* - */

  a.ready.then( () =>
  {
    test.case = 'configPath and remotePath';
    return _.npm.versionLog
    ({
      configPath : a.abs( 'package.json' ),
      remotePath : 'wmodulefortesting1',
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( _.strCount( op, 'Latest version of wmodulefortesting1 : ' ), 1 );
    test.identical( _.strCount( op, 'Stable version of wmodulefortesting1 :' ), 0 );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'logger - 5';
    const o =
    {
      configPath : a.abs( 'package.json' ),
      remotePath : 'wmodulefortesting1',
      tags : [ 'latest', 'stable' ],
      logger : 5,
    };
    filePath/*programPath*/ = programMake( o );
    return null;
  });

  a.ready.then( () => programShell( `node ${ filePath/*programPath*/ }`) );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Latest version of wmodulefortesting1 : ' ), 1 );
    test.identical( _.strCount( op.output, 'Stable version of wmodulefortesting1 :' ), 1 );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'logger - 0';
    const o =
    {
      configPath : a.abs( 'package.json' ),
      remotePath : 'wmodulefortesting1',
      tags : [ 'latest', 'stable' ],
      logger : 0,
    };
    filePath/*programPath*/ = programMake( o );
    return null;
  });

  a.ready.then( () => programShell( `node ${ filePath/*programPath*/ }`) );
  a.ready.then( ( op ) =>
  {
    test.identical( op.exitCode, 0 );
    test.identical( _.strCount( op.output, 'Latest version of wmodulefortesting1 : ' ), 0 );
    test.identical( _.strCount( op.output, 'Stable version of wmodulefortesting1 :' ), 0 );
    return null;
  });

  /* - */

  return a.ready;

  /* */

  function begin()
  {
    a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
    a.shell( 'git clone https://github.com/Wandalen/wModuleForTesting1.git ./' );
    return a.ready;
  }

  /* */

  function programMake( options )
  {
    const locals = { toolsPath : _.module.resolve( 'wTools' ), o : options };
    const program = a.program({ entry : testApp, locals });
    return a.path.nativize( program.filePath/*programPath*/ );
  }

  /* */

  function testApp()
  {
    const _ = require( toolsPath );
    _.include( 'wNpmTools' );
    return _.npm.versionLog( o );
  }
}

//

function versionLogWithNoConnection( test )
{
  if( process.platform !== 'linux' || !_.process.insideTestContainer() )
  return test.true( true );

  const a = test.assetFor( false );
  a.ready.then( () => { a.fileProvider.dirMake( a.abs( '.' ) ); return null });
  a.shell( 'git clone https://github.com/Wandalen/wModuleForTesting1.git ./' );

  /* - */

  const netInterfaces = __.test.netInterfacesGet({ activeInterfaces : 1, sync : 1 });
  a.ready.then( () => __.test.netInterfacesDown({ interfaces : netInterfaces }) );

  /* */

  a.ready.then( () =>
  {
    test.case = 'several tags';
    return _.npm.versionLog
    ({
      localPath : a.abs( '.' ),
      remotePath : 'wmodulefortesting1',
      tags : [ 'latest', 'stable' ],
    });
  });
  a.ready.then( ( op ) =>
  {
    test.identical( _.strCount( op, 'Current version :' ), 1 );
    test.identical( _.strCount( op, 'Latest version of wmodulefortesting1 :' ), 1 );
    test.identical( _.strCount( op, 'Stable version of wmodulefortesting1 :' ), 1 );
    return null;
  });

  /* */

  a.ready.finally( () => __.test.netInterfacesUp({ interfaces : netInterfaces }) );

  /* - */

  return a.ready;
}

//

function remoteAbout( test )
{
  let ready = _.take( null );

  ready.then( () =>
  {
    test.case = 'only name';
    var got = _.npm.remoteAbout( 'wmodulefortesting1' );
    test.identical( got.name, 'wmodulefortesting1' );
    test.identical( got.license, 'MIT' );
    return null;
  });

  ready.then( () =>
  {
    test.case = 'only name in map';
    var o = { name : 'wmodulefortesting1' };
    var got = _.npm.remoteAbout( o );
    test.identical( got.name, 'wmodulefortesting1' );
    test.identical( got.license, 'MIT' );
    return null;
  });

  ready.then( () =>
  {
    test.case = 'package not exists, throwing - 0';
    var o = { name : 'notexists', throwing : 0 };
    var got = _.npm.remoteAbout( o );
    test.identical( got, null );
    return null;
  });

  /* */

  ready.then( () =>
  {
    test.case = 'only name with tag ( dist version )';
    var got = _.npm.remoteAbout( 'wmodulefortesting1!alpha' );
    test.identical( got.name, 'wmodulefortesting1' );
    test.identical( got.license, 'MIT' );
    var exp = 'Module for testing. This module is a test asset and not intended to be used with another purpose.';
    test.identical( got.description, exp );
    return null;
  });

  ready.then( () =>
  {
    test.case = 'only name with tag ( dist version ) in map';
    var o = { name : 'wmodulefortesting1!alpha' };
    var got = _.npm.remoteAbout( o );
    test.identical( got.name, 'wmodulefortesting1' );
    test.identical( got.license, 'MIT' );
    var exp = 'Module for testing. This module is a test asset and not intended to be used with another purpose.';
    test.identical( got.description, exp );
    return null;
  });

  ready.then( () =>
  {
    test.case = 'package not exists, name with tag ( dist version ), throwing - 0';
    var o = { name : 'notexists!alpha', throwing : 0 };
    var got = _.npm.remoteAbout( o );
    test.identical( got, null );
    return null;
  });

  /* */

  ready.then( () =>
  {
    test.case = 'only name with tag ( version )';
    var got = _.npm.remoteAbout( 'wmodulefortesting1!0.0.109' );
    test.identical( got.name, 'wmodulefortesting1' );
    test.identical( got.license, 'MIT' );
    var exp = 'Module for testing. This module is a test asset and not intended to be used with another purpose.';
    test.identical( got.description, exp );
    return null;
  });

  ready.then( () =>
  {
    test.case = 'only name with tag ( version ) in map';
    var o = { name : 'wmodulefortesting1!0.0.109' };
    var got = _.npm.remoteAbout( o );
    test.identical( got.name, 'wmodulefortesting1' );
    test.identical( got.license, 'MIT' );
    var exp = 'Module for testing. This module is a test asset and not intended to be used with another purpose.';
    test.identical( got.description, exp );
    return null;
  });

  ready.then( () =>
  {
    test.case = 'package not exists, name with tag ( version ), throwing - 0';
    var o = { name : 'notexists!0.0.109', throwing : 0 };
    var got = _.npm.remoteAbout( o );
    test.identical( got, null );
    return null;
  });

  /* - */

  if( Config.debug )
  {
    ready.then( () =>
    {
      test.case = 'unknown option in options map';
      var o = { name : 'notexists', unknown : 1 };
      test.shouldThrowErrorSync( () => _.npm.remoteAbout( o ) );
      return null;
    });

    ready.then( () =>
    {
      test.case = 'package not exists, throwing - 1';
      var o = { name : 'notexists', throwing : 1 };
      var errCallback = ( err, arg ) =>
      {
        test.identical( arg, undefined );
        test.identical( _.strCount( err.message, 'Failed to get information about remote module "notexists"' ), 1 );
      };
      test.shouldThrowErrorSync( () => _.npm.remoteAbout( o ), errCallback );
      return null;
    });

    ready.then( () =>
    {
      test.case = 'package exists, wrong version, throwing - 1';
      var o = { name : 'wmodulefortesting1!notexists', throwing : 1 };
      var errCallback = ( err, arg ) =>
      {
        test.identical( arg, undefined );
        test.identical( _.strCount( err.message, 'Wrong version tag "notexists"' ), 1 );
      };
      test.shouldThrowErrorSync( () => _.npm.remoteAbout( o ), errCallback );
      return null;
    });
  }

  return ready;
}

//

function remoteAboutWithOptionAttemptDelay( test )
{
  const a = test.assetFor( false );

  if( process.platform !== 'linux' || !_.process.insideTestContainer() )
  return test.true( true );

  /* - */

  const netInterfaces = __.test.netInterfacesGet({ activeInterfaces : 1, sync : 1 });
  a.ready.then( () => __.test.netInterfacesDown({ interfaces : netInterfaces }) );

  /* */

  a.ready.then( () =>
  {
    test.case = 'default attemptDelay';
    let start;
    const errCallback = ( err, arg ) =>
    {
      const end = _.time.now();
      const spent = end - start;
      test.ge( spent, 500 );
      test.le( spent, 3000 );

      test.true( _.error.is( err ) );
      test.identical( arg, undefined );
    }
    start = _.time.now();
    test.shouldThrowErrorSync( () => _.npm.remoteAbout( 'wmodulefortesting1' ), errCallback );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'not default attemptDelay';
    let start;
    const errCallback = ( err, arg ) =>
    {
      const end = _.time.now();
      const spent = end - start;
      console.log( spent );
      test.ge( spent, 2500 );
      test.le( spent, 15000 );

      test.true( _.error.is( err ) );
      test.identical( arg, undefined );
    }
    start = _.time.now();
    test.shouldThrowErrorSync( () => _.npm.remoteAbout({ name : 'wmodulefortesting1', attemptDelay : 500 }), errCallback );
    return null;
  });

  /* */

  a.ready.finally( () => __.test.netInterfacesUp({ interfaces : netInterfaces }) );

  /* - */

  return a.ready;
}

//

function remoteAboutWithOptionAttemptDelayMultiplier( test )
{
  const a = test.assetFor( false );

  if( process.platform !== 'linux' || !_.process.insideTestContainer() )
  return test.true( true );

  /* - */

  const netInterfaces = __.test.netInterfacesGet({ activeInterfaces : 1, sync : 1 });
  a.ready.then( () => __.test.netInterfacesDown({ interfaces : netInterfaces }) );

  /* */

  a.ready.then( () =>
  {
    test.case = 'default attemptDelayMultiplier';
    let start;
    const errCallback = ( err, arg ) =>
    {
      const end = _.time.now();
      const spent = end - start;
      console.log( spent );
      console.log( err.originalMessage );
      test.ge( spent, 2500 );
      test.le( spent, 15000 );

      test.true( _.error.is( err ) );
      test.identical( arg, undefined );
    }
    start = _.time.now();
    test.shouldThrowErrorSync( () =>
    {
      return _.npm.remoteAbout
      ({
        name : 'wmodulefortesting1',
        attemptLimit : 3,
        attemptDelay : 500,
        attemptDelayMultiplier : 4,
      });
    }, errCallback );
    return null;
  });

  /* */

  a.ready.then( () =>
  {
    test.case = 'not default attemptDelayMultiplier';
    let start;
    const errCallback = ( err, arg ) =>
    {
      const end = _.time.now();
      const spent = end - start;
      test.ge( spent, 1000 );
      test.le( spent, 6000 );

      test.true( _.error.is( err ) );
      test.identical( arg, undefined );
    }
    start = _.time.now();
    test.shouldThrowErrorSync( () =>
    {
      return _.npm.remoteAbout
      ({
        name : 'wmodulefortesting1',
        attemptLimit : 3,
        attemptDelay : 500,
        attemptDelayMultiplier : 1,
      });
    }, errCallback );
    return null;
  });

  /* */

  a.ready.finally( () => __.test.netInterfacesUp({ interfaces : netInterfaces }) );

  /* - */

  return a.ready;
}

//

function remoteDependants( test )
{
  const a = test.assetFor( false );

  /*
    the matrix of test runs is restricted to njs v16 because test routines in all runs can exhaust request limit
    https://github.com/Wandalen/wNpmTools/runs/3879185779?check_suite_focus=true#step:12:342
  */
  if( Config.interpreter === 'njs' )
  if( !_.str.begins( process.versions.node, '16' ) )
  return test.true( true );

  /* - */

  a.ready.then( () =>
  {
    test.open( 'string as a parameter' );
    return null;
  });

  a.ready.then( async () =>
  {
    test.case = '0 dependants, local relative';
    var got = await _.npm.remoteDependants( 'wmodulefortesting12ab' );
    var exp = 0;
    test.identical( got, exp );

    test.case = '0 dependants, global relative';
    var got = await _.npm.remoteDependants( 'npm://wmodulefortesting12ab' );
    var exp = 0;
    test.identical( got, exp );

    test.case = '0 dependants, global absolute';
    var got = await _.npm.remoteDependants( 'npm:///wmodulefortesting12ab' );
    var exp = 0;
    test.identical( got, exp );

    /* */

    test.case = 'not 0 dependants, local relative';
    var got = await _.npm.remoteDependants( 'wmodulefortesting1a' );
    var exp = 1;
    test.identical( got, exp );

    test.case = 'not 0 dependants, global relative';
    var got = await _.npm.remoteDependants( 'npm://wmodulefortesting1a' );
    var exp = 1;
    test.identical( got, exp );

    test.case = 'not 0 dependants, global absolute';
    var got = await _.npm.remoteDependants( 'npm:///wmodulefortesting1a' );
    var exp = 1;
    test.identical( got, exp );

    /* */

    test.case = 'pakage name has "/", local relative';
    var got = await _.npm.remoteDependants( '@tensorflow/tfjs' );
    test.gt( got, 100 );

    test.case = 'pakage name has "/", global relative';
    var got = await _.npm.remoteDependants( 'npm://@tensorflow/tfjs' );
    test.gt( got, 100 );

    test.case = 'pakage name has "/", global absolute';
    var got = await _.npm.remoteDependants( 'npm:///@tensorflow/tfjs' );
    test.gt( got, 100 );

    /* */

    test.case = 'dependants > 999, local relative';
    var got = await _.npm.remoteDependants( 'express' );
    test.true( _.numberIs( got ) );
    test.gt( got, 10000 );

    test.case = 'dependants > 999, global relative';
    var got = await _.npm.remoteDependants( 'npm://express' );
    test.true( _.numberIs( got ) );
    test.gt( got, 10000 );

    test.case = 'dependants > 999, global absolute';
    var got = await _.npm.remoteDependants( 'npm:///express' );
    test.true( _.numberIs( got ) );
    test.gt( got, 10000 );

    /* */

    test.case = 'nonexistent package name, local relative';
    var got = await _.npm.remoteDependants( 'nonexistentPackageName' );
    var exp = NaN;
    test.identical( got, exp );

    test.case = 'nonexistent package name, global relative';
    var got = await _.npm.remoteDependants( 'npm://nonexistentPackageName' );
    var exp = NaN;
    test.identical( got, exp );

    test.case = 'nonexistent package name, global absolute';
    var got = await _.npm.remoteDependants( 'npm:///nonexistentPackageName' );
    var exp = NaN;
    test.identical( got, exp );

    return null;
  });

  a.ready.then( () =>
  {
    test.close( 'string as a parameter' );
    return null;
  }).delay( 20000 );

  /* - */

  a.ready.then( () =>
  {
    test.open( 'map as a parameter' );
    return null;
  });

  a.ready.then( async () =>
  {
    test.case = '0 dependants, local relative';
    var got = await _.npm.remoteDependants( { remotePath : 'wmodulefortesting12ab' } );
    var exp = 0;
    test.identical( got, exp );

    test.case = '0 dependants, global relative';
    var got = await _.npm.remoteDependants( { remotePath : 'npm://wmodulefortesting12ab' } );
    var exp = 0;
    test.identical( got, exp );

    test.case = '0 dependants, global absolute';
    var got = await _.npm.remoteDependants( { remotePath : 'npm:///wmodulefortesting12ab' } );
    var exp = 0;
    test.identical( got, exp );

    /* */

    test.case = 'not 0 dependants, local relative';
    var got = await _.npm.remoteDependants( { remotePath : 'wmodulefortesting1a' } );
    var exp = 1;
    test.identical( got, exp );

    test.case = 'not 0 dependants, global relative';
    var got = await _.npm.remoteDependants( { remotePath : 'npm://wmodulefortesting1a' } );
    var exp = 1;
    test.identical( got, exp );

    test.case = 'not 0 dependants, global absolute';
    var got = await _.npm.remoteDependants( { remotePath : 'npm:///wmodulefortesting1a' } );
    var exp = 1;
    test.identical( got, exp );

    /* */

    test.case = 'pakage name has "/", local relative';
    var got = await _.npm.remoteDependants( { remotePath : '@tensorflow/tfjs' } );
    test.gt( got, 100 );

    test.case = 'pakage name has "/", global relative';
    var got = await _.npm.remoteDependants( { remotePath : 'npm://@tensorflow/tfjs' } );
    test.gt( got, 100 );

    test.case = 'pakage name has "/", global absolute';
    var got = await _.npm.remoteDependants( { remotePath : 'npm:///@tensorflow/tfjs' } );
    test.gt( got, 100 );

    /* */

    test.case = 'dependants > 999, local relative';
    var got = await _.npm.remoteDependants( { remotePath : 'express' } );
    test.true( _.numberIs( got ) );
    test.gt( got, 10000 );

    test.case = 'dependants > 999, global relative';
    var got = await _.npm.remoteDependants( { remotePath : 'npm://express' } );
    test.true( _.numberIs( got ) );
    test.gt( got, 10000 );

    test.case = 'dependants > 999, global absolute';
    var got = await _.npm.remoteDependants( { remotePath : 'npm:///express' } );
    test.true( _.numberIs( got ) );
    test.gt( got, 10000 );

    /* */

    test.case = 'nonexistent package name, local relative';
    var got = await _.npm.remoteDependants( { remotePath : 'nonexistentPackageName' } );
    var exp = NaN;
    test.identical( got, exp );

    test.case = 'nonexistent package name, global relative';
    var got = await _.npm.remoteDependants( { remotePath : 'npm://nonexistentPackageName' } );
    var exp = NaN;
    test.identical( got, exp );

    test.case = 'nonexistent package name, global absolute';
    var got = await _.npm.remoteDependants( { remotePath : 'npm:///nonexistentPackageName' } );
    var exp = NaN;
    test.identical( got, exp );
    return null;
  });

  a.ready.then( () =>
  {
    test.close( 'map as a parameter' );
    return null;
  });

  /* - */

  return a.ready;
}

remoteDependants.timeOut = 90000;
remoteDependants.description =
`
Retrieves the number of dependent packages
`;

//

function remoteDependantsWithOptionAttemptDelayMultiplier( test )
{
  let context = this;
  let a = test.assetFor( false );

  if( process.platform !== 'linux' || !_.process.insideTestContainer() )
  return test.true( true );

  /* - */

  let netInterfaces = __.test.netInterfacesGet({ activeInterfaces : 1, sync : 1 });
  a.ready.then( () => __.test.netInterfacesDown({ interfaces : netInterfaces }) );

  var start;
  a.ready.then( () =>
  {
    test.case = 'not existed package';
    start = _.time.now();
    return _.npm.remoteDependants
    ({
      remotePath : 'npm:///nonexistentPackageName',
      attemptLimit : 4,
      attemptDelay : 250,
      attemptDelayMultiplier : 3,
      sync : 1,
    });
  });
  a.ready.finally( ( err, arg ) =>
  {
    var spent = _.time.now() - start;
    test.ge( spent, 3250 );

    test.true( _.error.is( err ) );
    _.error.attend( err );
    test.true( _.strHas( err.originalMessage, 'Attempts exhausted, made 4 attempts' ) );
    test.identical( arg, undefined );

    return null;
  });

  a.ready.finally( () => __.test.netInterfacesUp({ interfaces : netInterfaces }) );

  /* - */

  return a.ready;
}

//

function dependantsRetrieveMultipleRequests( test )
{
  let ready = _.take( null );

  /* */

  ready.then( () =>
  {
    test.case = 'array as a parameter';
    var names =
    [
      'wmodulefortesting1', 'wmodulefortesting1a', 'wmodulefortesting1b',
      'wmodulefortesting12', 'wmodulefortesting12ab', 'nonexistentPackageName',
      'wmodulefortesting1', 'wmodulefortesting1a', 'wmodulefortesting1b',
      'wmodulefortesting12', 'wmodulefortesting12ab', 'nonexistentPackageName',
      'wmodulefortesting1', 'wmodulefortesting1a', 'wmodulefortesting1b',
      'wmodulefortesting12', 'wmodulefortesting12ab', 'nonexistentPackageName',
      'wmodulefortesting1', 'wmodulefortesting1a', 'wmodulefortesting1b',
      'wmodulefortesting12', 'wmodulefortesting12ab', 'nonexistentPackageName',
    ];
    return _.npm.remoteDependants( names )
    .then( ( got ) =>
    {
      var exp =
      [
        5, 1, 1,
        1, 0, NaN,
        5, 1, 1,
        1, 0, NaN,
        5, 1, 1,
        1, 0, NaN,
        5, 1, 1,
        1, 0, NaN,
      ];
      test.identical( got, exp );
      return null;
    });
  });

  /* */

  ready.then( () =>
  {
    test.case = 'map as a parameter';
    var names =
    [
      'wmodulefortesting1', 'wmodulefortesting1a', 'wmodulefortesting1b',
      'wmodulefortesting12', 'wmodulefortesting12ab', 'nonexistentPackageName',
      'wmodulefortesting1', 'wmodulefortesting1a', 'wmodulefortesting1b',
      'wmodulefortesting12', 'wmodulefortesting12ab', 'nonexistentPackageName',
      'wmodulefortesting1', 'wmodulefortesting1a', 'wmodulefortesting1b',
      'wmodulefortesting12', 'wmodulefortesting12ab', 'nonexistentPackageName',
      'wmodulefortesting1', 'wmodulefortesting1a', 'wmodulefortesting1b',
      'wmodulefortesting12', 'wmodulefortesting12ab', 'nonexistentPackageName',
    ];
    return _.npm.remoteDependants({ remotePath : names, attemptLimit : 20, attemptDelay : 500 })
    .then( ( got ) =>
    {
      var exp =
      [
        5, 1, 1,
        1, 0, NaN,
        5, 1, 1,
        1, 0, NaN,
        5, 1, 1,
        1, 0, NaN,
        5, 1, 1,
        1, 0, NaN,
      ];
      test.identical( got, exp );
      return null;
    });
  });

  /* */

  ready.then( () =>
  {
    test.case = 'map as a parameter, not existed packages';
    var wrongNames =
    [
      'nonexistentName', 'nonexistentName1', 'nonexistentName2', 'nonexistentName', 'nonexistentName1', 'nonexistentName2',
      'nonexistentName', 'nonexistentName1', 'nonexistentName2', 'nonexistentName', 'nonexistentName1', 'nonexistentName2',
      'nonexistentName', 'nonexistentName1', 'nonexistentName2', 'nonexistentName', 'nonexistentName1', 'nonexistentName2',
      'nonexistentName', 'nonexistentName1', 'nonexistentName2', 'nonexistentName', 'nonexistentName1', 'nonexistentName2',
    ];
    return _.npm.remoteDependants({ remotePath : wrongNames, attemptLimit : 20, attemptDelay : 500 })
    .then( ( got ) =>
    {
      var exp =
      [
        NaN, NaN, NaN, NaN, NaN, NaN,
        NaN, NaN, NaN, NaN, NaN, NaN,
        NaN, NaN, NaN, NaN, NaN, NaN,
        NaN, NaN, NaN, NaN, NaN, NaN,
      ];
      test.identical( got, exp );
      return null;
    });
  });

  /* */

  return ready;
}

dependantsRetrieveMultipleRequests.rapidity = -4; /* xxx : investigate and improve behavior */
dependantsRetrieveMultipleRequests.timeOut = 120000;
dependantsRetrieveMultipleRequests.description =
`
Retrieves dependants of each package in array
Depends on remote server, should be tested manually.
`;

//

async function dependantsRetrieveStress( test )
{
  const temp =
  [
    'wmodulefortesting1', 'wmodulefortesting1a', 'wmodulefortesting1b',
    'wmodulefortesting12', 'nonexistentPackageName', 'nonexistentPackageName',
  ];
  const remotePath = [];
  const exp = [];
  const l = 100;

  for( let i = 0; i < l; i++ )
  {
    remotePath.push( ... temp );
    exp.push( 5, 1, 1, 1, NaN, NaN );
  }

  test.case = `${remotePath.length} packages`;
  let got = await _.npm.remoteDependants({ remotePath, logger : 3, attemptLimit : 20, attemptDelay : 500 });
  test.identical( got, exp );
}

dependantsRetrieveStress.rapidity = -4; /* xxx : investigate and improve behavior */
dependantsRetrieveStress.timeOut = 300000;
dependantsRetrieveStress.description =
`
Stress testing.
Depends on remote server, should be tested manually.
`;

//

function localVersion( test )
{
  let self = this;
  let a = test.assetFor( false );
  let testPath = a.abs( '.' );
  let filePath = a.abs( 'package.json' );
  /* aaa Artem : done. avoid using _.path.* in tests, use a.abs() instead please */

  test.case = 'path doesn`t exist'
  var got = _.npm.localVersion({ localPath : testPath })
  test.identical( got, '' );

  _.fileProvider.dirMake( testPath );

  test.case = 'no package'
  var got = _.npm.localVersion({ localPath : testPath })
  test.identical( got, '' );

  test.case = 'after init'
  var data = { version : '1.0.0' }
  _.fileProvider.fileWrite({ filePath, data, encoding : 'json' })
  var got = _.npm.localVersion({ localPath : testPath })
  test.identical( got, '1.0.0' );

  test.case = 'after init'
  var data = { version : null }
  _.fileProvider.fileWrite({ filePath, data, encoding : 'json' })
  var got = _.npm.localVersion({ localPath : testPath })
  test.identical( got, null );
}

localVersion.timeOut = 300000;

//

function remoteVersionLatest( test )
{

  /* aaa Artem : done. use modules for testing instead of production modules here and everywhere */
  var remotePath = 'npm:///wmodulefortesting1';
  var got = _.npm.remoteVersionLatest( remotePath );
  test.true( _.strDefined( got ) );

  var remotePath = 'npm:///wmodulefortesting1@latest';
  var got = _.npm.remoteVersionLatest( remotePath );
  test.true( _.strDefined( got ) );

  var remotePath = 'npm:///wmodulefortesting1@beta';
  var got = _.npm.remoteVersionLatest( remotePath );
  test.true( _.strDefined( got ) );

  var remotePath = 'npm:///wmodulefortesting1#0.0.3';
  var got = _.npm.remoteVersionLatest( remotePath );
  test.true( _.strDefined( got ) );

  test.shouldThrowErrorSync( () => _.npm.remoteVersionLatest( 'npm:///wmodulefortestinggg1' ))
  test.shouldThrowErrorSync( () => _.npm.remoteVersionLatest( 'npm:///wmodulefortestinggg1@beta' ))
  test.shouldThrowErrorSync( () => _.npm.remoteVersionLatest( 'npm:///wmodulefortestinggg1#0.0.3' ))

}

remoteVersionLatest.timeOut = 30000;

//

function remoteVersionCurrent( test )
{
  var remotePath = 'npm:///wmodulefortesting1'
  var got = _.npm.remoteVersionCurrent( remotePath );
  test.true( _.strDefined( got ) );

  var remotePath = 'npm:///wmodulefortesting1@latest'
  var got = _.npm.remoteVersionCurrent( remotePath );
  test.true( _.strDefined( got ) );
  test.notIdentical( got, remotePath );

  var remotePath = 'npm:///wmodulefortesting1@beta'
  var got = _.npm.remoteVersionCurrent( remotePath );
  test.true( _.strDefined( got ) );
  test.notIdentical( got, remotePath );

  var remotePath = 'npm:///wmodulefortesting1#0.0.3'
  var got = _.npm.remoteVersionCurrent( remotePath );
  test.true( _.strDefined( got ) );
  test.identical( got, '0.0.3' );
}

remoteVersionCurrent.timeOut = 30000;

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
    let remotePath = 'npm:///wmodulefortesting1!beta'
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
    let remotePath = 'npm:///wmodulefortesting1!beta'
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

isUpToDate.timeOut = 120000;

//

function isUpToDateDetailing( test )
{
  let self = this;
  let a = test.assetFor( false );
  let testPath = a.abs( '.' );
  let localPath = a.abs( 'node_modules/wmodulefortesting1' );
  let detailing = true;
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
    var got = _.npm.isUpToDate({ localPath, remotePath, detailing });
    let exp =
    {
      isRepository : false,
      hasRemoteVersion : null,
      hasLatestVersion : null,
      result : false
    }
    test.contains( got, exp );
    test.true( _.strDefined( got.reason ) );
    return null;
  })

  install( 'wmodulefortesting1' )
  .then( () =>
  {
    test.case = 'installed latest, remote points to latest'
    let remotePath = 'npm:///wmodulefortesting1'
    var got = _.npm.isUpToDate({ localPath, remotePath, detailing });
    let exp =
    {
      isRepository : true,
      hasRemoteVersion : false,
      hasLatestVersion : true,
      result : true
    }
    test.contains( got, exp );
    return null;
  })

  install( 'wmodulefortesting1@beta' )
  .then( () =>
  {
    test.case = 'installed beta, remote points to latest'
    let remotePath = 'npm:///wmodulefortesting1'
    var got = _.npm.isUpToDate({ localPath, remotePath, detailing });
    let exp =
    {
      isRepository : true,
      hasRemoteVersion : false,
      hasLatestVersion : false,
      result : false
    }
    test.contains( got, exp );
    test.true( _.strDefined( got.reason ) );
    return null;
  })

  install( 'wmodulefortesting1@beta' )
  .then( () =>
  {
    test.case = 'installed beta, remote points to latest'
    let remotePath = 'npm:///wmodulefortesting1!beta'
    var got = _.npm.isUpToDate({ localPath, remotePath, detailing });
    let exp =
    {
      isRepository : true,
      hasRemoteVersion : false,
      hasLatestVersion : true,
      result : true
    }
    test.contains( got, exp );
    return null;
  })

  install( 'wmodulefortesting1@latest' )
  .then( () =>
  {
    test.case = 'installed latest, remote points to latest'
    let remotePath = 'npm:///wmodulefortesting1'
    var got = _.npm.isUpToDate({ localPath, remotePath, detailing });
    let exp =
    {
      isRepository : true,
      hasRemoteVersion : false,
      hasLatestVersion : true,
      result : true
    }
    test.contains( got, exp );
    return null;
  })

  install( 'wmodulefortesting1@0.0.5' )
  .then( () =>
  {
    test.case = 'installed version, remote points to latest'
    let remotePath = 'npm:///wmodulefortesting1'
    var got = _.npm.isUpToDate({ localPath, remotePath, detailing });
    let exp =
    {
      isRepository : true,
      hasRemoteVersion : false,
      hasLatestVersion : false,
      result : false
    }
    test.contains( got, exp );
    test.true( _.strDefined( got.reason ) );
    return null;
  })

  install( 'wmodulefortesting1@0.0.3' )
  .then( () =>
  {
    test.case = 'installed version, remote points to beta'
    let remotePath = 'npm:///wmodulefortesting1!beta'
    var got = _.npm.isUpToDate({ localPath, remotePath, detailing });
    let exp =
    {
      isRepository : true,
      hasRemoteVersion : false,
      hasLatestVersion : false,
      result : false
    }
    test.contains( got, exp );
    test.true( _.strDefined( got.reason ) );
    return null;
  })

  install( 'wmodulefortesting1@0.0.3' )
  .then( () =>
  {
    test.case = 'installed version, remote points to beta'
    let remotePath = 'npm:///wmodulefortesting1#0.0.3'
    var got = _.npm.isUpToDate({ localPath, remotePath, detailing });
    let exp =
    {
      isRepository : true,
      hasRemoteVersion : true,
      hasLatestVersion : null,
      result : true
    }
    test.contains( got, exp );
    return null;
  })

  return ready;
}

isUpToDateDetailing.timeOut = 120000;

//

function isRepository( test )
{
  let self = this;
  let a = test.assetFor( false );
  let testPath = a.abs( '.' );
  let localPath = a.abs( 'node_modules/wmodulefortesting1' );
  let ready = new _.Consequence().take( null );

  a.fileProvider.dirMake( testPath )

  let install = _.process.starter
  ({
    execPath : 'npm install --no-package-lock --legacy-bundling --prefix ' + _.fileProvider.path.nativize( testPath ),
    currentPath : testPath,
    ready
  });

  ready.then( () =>
  {
    test.case = 'no package'
    var got = _.npm.isRepository({ localPath });
    test.identical( got, false );
    return null;
  });

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

isRepository.timeOut = 40000;

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
    let remotePath = 'npm:///wmodulefortesting1!beta'
    var got = _.npm.hasRemote({ localPath, remotePath });
    test.identical( got.downloaded, true );
    test.identical( got.remoteIsValid, true );
    return null;
  })

  return ready;
}

hasRemote.timeOut = 60000;

// --
// declare
// --

const Proto =
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

    pathParse,
    pathIsFixated,
    pathFixate,
    pathDownloadFromLocal,

    /* */

    fileFormat,

    /* */

    fileFixate,
    fileBump,
    fileBumpCheckOptions,

    depAdd,

    install,
    installCheckOptionLinkingSelf,
    installLocalPathIsSoftLink,

    versionLog,
    versionLogWithOptions,
    versionLogWithNoConnection,

    remoteAbout,
    remoteAboutWithOptionAttemptDelay,
    remoteAboutWithOptionAttemptDelayMultiplier,
    remoteDependants,
    remoteDependantsWithOptionAttemptDelayMultiplier,
    dependantsRetrieveMultipleRequests,
    dependantsRetrieveStress,

    localVersion,
    remoteVersionLatest,
    remoteVersionCurrent,

    isUpToDate,
    isUpToDateDetailing,
    isRepository,
    hasRemote,
  },

}

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
