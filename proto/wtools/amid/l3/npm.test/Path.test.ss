( function _Path_test_ss_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../wtools/Tools.s' );
  _.include( 'wTesting' );
  require( '../npm/Include.ss' );
}

let _ = _globals_.testing.wTools;

// --
// tests
// --

function parse( test )
{
  test.open( 'global' );

  test.case = 'simple remotePath';
  var remotePath = 'npm:///wmodulefortesting1'
  var exp =
  {
    'protocol' : 'npm',
    'tag' : 'latest',
    'longPath' : '/wmodulefortesting1',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : '',
    'isFixated' : false
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'with hash';
  var remotePath = 'npm:///wmodulefortesting1#1.0.0'
  var exp =
  {
    'protocol' : 'npm',
    'hash' : '1.0.0',
    'longPath' : '/wmodulefortesting1',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : '',
    'isFixated' : true
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'with tag';
  var remotePath = 'npm:///wmodulefortesting1!beta';
  var exp =
  {
    'protocol' : 'npm',
    'tag' : 'beta',
    'longPath' : '/wmodulefortesting1',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : '',
    'isFixated' : false
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'simple path with local';
  var remotePath = 'npm:///wmodulefortesting1/out/wmodulefortesting1';
  var exp =
  {
    'protocol' : 'npm',
    'tag' : 'latest',
    'longPath' : '/wmodulefortesting1/out/wmodulefortesting1',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : 'out/wmodulefortesting1',
    'isFixated' : false,
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'simple path with local and hash';
  var remotePath = 'npm:///wmodulefortesting1/out/wmodulefortesting1#0.3.100';
  var exp =
  {
    'protocol' : 'npm',
    'hash' : '0.3.100',
    'longPath' : '/wmodulefortesting1/out/wmodulefortesting1',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : 'out/wmodulefortesting1',
    'isFixated' : true,
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'simple path with local and tag';
  var remotePath = 'npm:///wmodulefortesting1/out/wmodulefortesting1!alpha';
  var exp =
  {
    'protocol' : 'npm',
    'tag' : 'alpha',
    'longPath' : '/wmodulefortesting1/out/wmodulefortesting1',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : 'out/wmodulefortesting1',
    'isFixated' : false
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'only protocol';
  var remotePath = 'npm:///'
  var exp =
  {
    'protocol' : 'npm',
    'tag' : 'latest',
    'longPath' : '/',
    'host' : '',
    'localVcsPath' : '',
    'isFixated' : false,
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'protocol and tag';
  var remotePath = 'npm:///!some tag'
  var exp =
  {
    'protocol' : 'npm',
    'tag' : 'some tag',
    'longPath' : '/',
    'host' : '',
    'localVcsPath' : '',
    'isFixated' : false,
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'protocol and hash';
  var remotePath = 'npm:///#0.3.201'
  var exp =
  {
    'protocol' : 'npm',
    'hash' : '0.3.201',
    'longPath' : '/',
    'host' : '',
    'localVcsPath' : '',
    'isFixated' : true,
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.close( 'global' );

  /* - */

  test.open( 'local' );

  test.case = 'simple remotePath';
  var remotePath = 'npm://wmodulefortesting1'
  var exp =
  {
    'protocol' : 'npm',
    'tag' : 'latest',
    'longPath' : 'wmodulefortesting1',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : '',
    'isFixated' : false
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'with hash';
  var remotePath = 'npm://wmodulefortesting1#1.0.0'
  var exp =
  {
    'protocol' : 'npm',
    'hash' : '1.0.0',
    'longPath' : 'wmodulefortesting1',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : '',
    'isFixated' : true
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'with tag';
  var remotePath = 'npm://wmodulefortesting1!beta';
  var exp =
  {
    'protocol' : 'npm',
    'tag' : 'beta',
    'longPath' : 'wmodulefortesting1',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : '',
    'isFixated' : false
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'simple path with local';
  var remotePath = 'npm://wmodulefortesting1/out/wmodulefortesting1';
  var exp =
  {
    'protocol' : 'npm',
    'tag' : 'latest',
    'longPath' : 'wmodulefortesting1/out/wmodulefortesting1',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : 'out/wmodulefortesting1',
    'isFixated' : false,
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'simple path with local and hash';
  var remotePath = 'npm://wmodulefortesting1/out/wmodulefortesting1#0.3.100';
  var exp =
  {
    'protocol' : 'npm',
    'hash' : '0.3.100',
    'longPath' : 'wmodulefortesting1/out/wmodulefortesting1',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : 'out/wmodulefortesting1',
    'isFixated' : true,
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'simple path with local and tag';
  var remotePath = 'npm://wmodulefortesting1/out/wmodulefortesting1!alpha';
  var exp =
  {
    'protocol' : 'npm',
    'tag' : 'alpha',
    'longPath' : 'wmodulefortesting1/out/wmodulefortesting1',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : 'out/wmodulefortesting1',
    'isFixated' : false
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'only protocol';
  var remotePath = 'npm://'
  var exp =
  {
    'protocol' : 'npm',
    'tag' : 'latest',
    'longPath' : '',
    'host' : '',
    'localVcsPath' : '',
    'isFixated' : false,
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'protocol and tag';
  var remotePath = 'npm://!some tag'
  var exp =
  {
    'protocol' : 'npm',
    'tag' : 'some tag',
    'longPath' : '',
    'host' : '',
    'localVcsPath' : '',
    'isFixated' : false,
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'protocol and hash';
  var remotePath = 'npm://#0.3.201'
  var exp =
  {
    'protocol' : 'npm',
    'hash' : '0.3.201',
    'longPath' : '',
    'host' : '',
    'localVcsPath' : '',
    'isFixated' : true,
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.close( 'local' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.npm.path.parse() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.npm.path.parse( 'npm:///wmodulefortesting1', 'npm://wmodulefortesting1' ) );

  test.case = 'wrong format of remotePath';
  test.shouldThrowErrorSync( () => _.npm.path.parse( '/wmodulefortesting1' ) );

  test.case = 'wrong type of remotePath';
  test.shouldThrowErrorSync( () => _.npm.path.parse([ 'npm:///wmodulefortesting1' ]) );

  test.case = 'unknown option in options map';
  test.shouldThrowErrorSync( () => _.npm.path.parse({ remotePath : 'npm:///wmodulefortesting1', unknown : 1 }) );

  test.case = 'remotePath with hash and tag';
  var remotePath = 'npm:///wmodulefortesting1#1.0.0!beta';
  test.shouldThrowErrorSync( () => _.npm.path.parse( remotePath ) );
}

//

function nativize( test )
{
  test.open( 'global' );

  test.case = 'simple remotePath';
  var remotePath = 'npm:///wmodulefortesting1'
  var exp = 'wmodulefortesting1';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'with hash';
  var remotePath = 'npm:///wmodulefortesting1#1.0.0'
  var exp = 'wmodulefortesting1@1.0.0';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'with tag';
  var remotePath = 'npm:///wmodulefortesting1!beta';
  var exp = 'wmodulefortesting1@beta';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'simple path with local';
  var remotePath = 'npm:///wmodulefortesting1/out/wmodulefortesting1';
  var exp = 'wmodulefortesting1';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'simple path with local and hash';
  var remotePath = 'npm:///wmodulefortesting1/out/wmodulefortesting1#0.3.100';
  var exp = 'wmodulefortesting1@0.3.100';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'simple path with local and tag';
  var remotePath = 'npm:///wmodulefortesting1/out/wmodulefortesting1!alpha';
  var exp = 'wmodulefortesting1@alpha';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'only protocol';
  var remotePath = 'npm:///'
  var exp = '';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'protocol and tag';
  var remotePath = 'npm:///!some tag'
  var exp = '@some tag';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'protocol and hash';
  var remotePath = 'npm:///#0.3.201'
  var exp = '@0.3.201';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.close( 'global' );

  /* - */

  test.open( 'local' );

  test.case = 'simple remotePath';
  var remotePath = 'npm://wmodulefortesting1'
  var exp = 'wmodulefortesting1';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'with hash';
  var remotePath = 'npm://wmodulefortesting1#1.0.0'
  var exp = 'wmodulefortesting1@1.0.0';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'with tag';
  var remotePath = 'npm://wmodulefortesting1!beta';
  var exp = 'wmodulefortesting1@beta';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'simple path with local';
  var remotePath = 'npm://wmodulefortesting1/out/wmodulefortesting1';
  var exp = 'wmodulefortesting1';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'simple path with local and hash';
  var remotePath = 'npm://wmodulefortesting1/out/wmodulefortesting1#0.3.100';
  var exp = 'wmodulefortesting1@0.3.100';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'simple path with local and tag';
  var remotePath = 'npm://wmodulefortesting1/out/wmodulefortesting1!alpha';
  var exp = 'wmodulefortesting1@alpha';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'only protocol';
  var remotePath = 'npm://'
  var exp = '';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'protocol and tag';
  var remotePath = 'npm://!some tag'
  var exp = '@some tag';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'protocol and hash';
  var remotePath = 'npm://#0.3.201'
  var exp = '@0.3.201';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.close( 'local' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.npm.path.nativize() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.npm.path.nativize( 'npm:///wmodulefortesting1', 'npm://wmodulefortesting1' ) );

  test.case = 'wrong format of remotePath';
  test.shouldThrowErrorSync( () => _.npm.path.nativize( '/wmodulefortesting1' ) );

  test.case = 'wrong type of remotePath';
  test.shouldThrowErrorSync( () => _.npm.path.nativize([ 'npm:///wmodulefortesting1' ]) );

  test.case = 'unknown option in options map';
  test.shouldThrowErrorSync( () => _.npm.path.nativize({ remotePath : 'npm:///wmodulefortesting1', unknown : 1 }) );

  test.case = 'remotePath with hash and tag';
  var remotePath = 'npm:///wmodulefortesting1#1.0.0!beta';
  test.shouldThrowErrorSync( () => _.npm.path.nativize( remotePath ) );
}

//

function isFixated( test )
{
  test.case = 'simple path';
  var remotePath = 'npm:///wmodulefortesting1'
  var got = _.npm.path.isFixated( remotePath );
  test.identical( got, false );

  test.case = 'path hash';
  var remotePath = 'npm:///wmodulefortesting1#1.0.0'
  var got = _.npm.path.isFixated( remotePath );
  test.identical( got, true );

  test.case = 'path with tag';
  var remotePath = 'npm:///wmodulefortesting1!beta'
  var got = _.npm.path.isFixated( remotePath );
  test.identical( got, false );

  /* */

  test.case = 'simple path';
  var remotePath = 'npm://wmodulefortesting1'
  var got = _.npm.path.isFixated( remotePath );
  test.identical( got, false );

  test.case = 'path hash';
  var remotePath = 'npm://wmodulefortesting1#1.0.0'
  var got = _.npm.path.isFixated( remotePath );
  test.identical( got, true );

  test.case = 'path with tag';
  var remotePath = 'npm://wmodulefortesting1!beta'
  var got = _.npm.path.isFixated( remotePath );
  test.identical( got, false );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.npm.path.isFixated() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.npm.path.isFixated( 'npm:///wmodulefortesting1', 'npm://wmodulefortesting1' ) );

  test.case = 'wrong format of remotePath';
  test.shouldThrowErrorSync( () => _.npm.path.isFixated( '/wmodulefortesting1' ) );

  test.case = 'wrong type of remotePath';
  test.shouldThrowErrorSync( () => _.npm.path.isFixated([ 'npm:///wmodulefortesting1' ]) );

  test.case = 'remotePath with hash and tag';
  var remotePath = 'npm:///wmodulefortesting1#1.0.0!beta';
  test.shouldThrowErrorSync( () => _.npm.path.isFixated( remotePath ) );
}

// --
// declare
// --

let Proto =
{

  name : 'Tools.mid.NpmTools.path',
  silencing : 1,

  tests :
  {

    parse,

    nativize,

    isFixated,

  },

}

//

let Self = new wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
