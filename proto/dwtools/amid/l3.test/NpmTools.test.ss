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
    pathIsFixated
  },

}

//

var Self = new wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
