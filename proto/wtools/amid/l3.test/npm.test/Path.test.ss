( function _Path_test_ss_()
{

'use strict';

if( typeof module !== 'undefined' )
{
  const _ = require( '../../../../node_modules/Tools' );
  _.include( 'wTesting' );
  require( '../../l3/npm/include/Mid.ss' );
}

const _ = _global_.wTools;
const __ = _globals_.testing.wTools;

// --
// tests
// --

function parseFull( test )
{
  test.open( 'paths without protocol' );

  test.case = 'simple remotePath';
  var remotePath = 'wmodulefortesting1';
  var exp =
  {
    'protocols' : [],
    'tag' : 'latest',
    'longPath' : 'wmodulefortesting1',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : '',
    'isFixated' : false,
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'with hash';
  var remotePath = 'wmodulefortesting1#1.0.0';
  var exp =
  {
    'protocols' : [],
    'hash' : '1.0.0',
    'longPath' : 'wmodulefortesting1',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : '',
    'isFixated' : true,
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'with tag';
  var remotePath = 'wmodulefortesting1!beta';
  var exp =
  {
    'protocols' : [],
    'tag' : 'beta',
    'longPath' : 'wmodulefortesting1',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : '',
    'isFixated' : false,
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'only hash';
  var remotePath = '#1.0.0';
  var exp =
  {
    'protocols' : [],
    'hash' : '1.0.0',
    'longPath' : '',
    'host' : '',
    'localVcsPath' : '',
    'isFixated' : true,
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'only tag';
  var remotePath = '!beta';
  var exp =
  {
    'protocols' : [],
    'tag' : 'beta',
    'longPath' : '',
    'host' : '',
    'localVcsPath' : '',
    'isFixated' : false,
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.close( 'paths without protocol' );

  /* - */

  test.open( 'global' );

  test.case = 'simple remotePath';
  var remotePath = 'npm:///wmodulefortesting1';
  var exp =
  {
    'protocol' : 'npm',
    'protocols' : [ 'npm' ],
    'tag' : 'latest',
    'longPath' : '/wmodulefortesting1',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : '',
    'isFixated' : false
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'with hash';
  var remotePath = 'npm:///wmodulefortesting1#1.0.0';
  var exp =
  {
    'protocol' : 'npm',
    'protocols' : [ 'npm' ],
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
    'protocols' : [ 'npm' ],
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
    'protocols' : [ 'npm' ],
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
    'protocols' : [ 'npm' ],
    'hash' : '0.3.100',
    'longPath' : '/wmodulefortesting1/out/wmodulefortesting1',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : 'out/wmodulefortesting1',
    'isFixated' : true,
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'simple path with local and tag';
  var remotePath = 'npm:///wmodulefortesting1/out/wmodulefortesting1!delta';
  var exp =
  {
    'protocol' : 'npm',
    'protocols' : [ 'npm' ],
    'tag' : 'delta',
    'longPath' : '/wmodulefortesting1/out/wmodulefortesting1',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : 'out/wmodulefortesting1',
    'isFixated' : false
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'only protocol';
  var remotePath = 'npm:///';
  var exp =
  {
    'protocol' : 'npm',
    'protocols' : [ 'npm' ],
    'tag' : 'latest',
    'longPath' : '/',
    'host' : '',
    'localVcsPath' : '',
    'isFixated' : false,
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'protocol and tag';
  var remotePath = 'npm:///!some tag';
  var exp =
  {
    'protocol' : 'npm',
    'protocols' : [ 'npm' ],
    'tag' : 'some tag',
    'longPath' : '/',
    'host' : '',
    'localVcsPath' : '',
    'isFixated' : false,
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'protocol and hash';
  var remotePath = 'npm:///#0.3.201';
  var exp =
  {
    'protocol' : 'npm',
    'protocols' : [ 'npm' ],
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
  var remotePath = 'npm://wmodulefortesting1';
  var exp =
  {
    'protocol' : 'npm',
    'protocols' : [ 'npm' ],
    'tag' : 'latest',
    'longPath' : 'wmodulefortesting1',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : '',
    'isFixated' : false
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'with hash';
  var remotePath = 'npm://wmodulefortesting1#1.0.0';
  var exp =
  {
    'protocol' : 'npm',
    'protocols' : [ 'npm' ],
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
    'protocols' : [ 'npm' ],
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
    'protocols' : [ 'npm' ],
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
    'protocols' : [ 'npm' ],
    'hash' : '0.3.100',
    'longPath' : 'wmodulefortesting1/out/wmodulefortesting1',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : 'out/wmodulefortesting1',
    'isFixated' : true,
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'simple path with local and tag';
  var remotePath = 'npm://wmodulefortesting1/out/wmodulefortesting1!delta';
  var exp =
  {
    'protocol' : 'npm',
    'protocols' : [ 'npm' ],
    'tag' : 'delta',
    'longPath' : 'wmodulefortesting1/out/wmodulefortesting1',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : 'out/wmodulefortesting1',
    'isFixated' : false
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'only protocol';
  var remotePath = 'npm://';
  var exp =
  {
    'protocol' : 'npm',
    'protocols' : [ 'npm' ],
    'tag' : 'latest',
    'longPath' : '',
    'host' : '',
    'localVcsPath' : '',
    'isFixated' : false,
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'protocol and tag';
  var remotePath = 'npm://!some tag';
  var exp =
  {
    'protocol' : 'npm',
    'protocols' : [ 'npm' ],
    'tag' : 'some tag',
    'longPath' : '',
    'host' : '',
    'localVcsPath' : '',
    'isFixated' : false,
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'protocol and hash';
  var remotePath = 'npm://#0.3.201';
  var exp =
  {
    'protocol' : 'npm',
    'protocols' : [ 'npm' ],
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

  test.open( 'not npm paths' );

  test.case = 'git path';
  var remotePath = 'git://git@github.com:user/repo';
  var exp =
  {
    'protocol' : 'git',
    'protocols' : [ 'git' ],
    'tag' : 'latest',
    'longPath' : 'git@github.com:user/repo',
    'host' : 'git@github.com:user',
    'localVcsPath' : 'repo',
    'isFixated' : false,
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'ssh git path';
  var remotePath = 'ssh://git@github.com/user/repo';
  var exp =
  {
    'protocol' : 'ssh',
    'protocols' : [ 'ssh' ],
    'tag' : 'latest',
    'longPath' : 'git@github.com/user/repo',
    'host' : 'git@github.com',
    'localVcsPath' : 'user/repo',
    'isFixated' : false,
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'https git path';
  var remotePath = 'https://github.com/user/repo';
  var exp =
  {
    'protocol' : 'https',
    'protocols' : [ 'https' ],
    'tag' : 'latest',
    'longPath' : 'github.com/user/repo',
    'host' : 'github.com',
    'localVcsPath' : 'user/repo',
    'isFixated' : false,
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.case = 'https git path';
  var remotePath = 'file://local/repo';
  var exp =
  {
    'protocol' : 'file',
    'protocols' : [ 'file' ],
    'tag' : 'latest',
    'longPath' : 'local/repo',
    'host' : 'local',
    'localVcsPath' : 'repo',
    'isFixated' : false,
  };
  var got = _.npm.path.parse( remotePath );
  test.identical( got, exp );

  test.close( 'not npm paths' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.npm.path.parse() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.npm.path.parse( 'npm:///wmodulefortesting1', 'npm://wmodulefortesting1' ) );

  test.case = 'wrong type of remotePath';
  test.shouldThrowErrorSync( () => _.npm.path.parse([ 'npm:///wmodulefortesting1' ]) );

  test.case = 'remotePath with hash and tag';
  var remotePath = 'npm:///wmodulefortesting1#1.0.0!beta';
  test.shouldThrowErrorSync( () => _.npm.path.parse( remotePath ) );

  test.case = 'unknown option in options map';
  test.shouldThrowErrorSync( () => _.npm.path.parse({ remotePath : 'npm:///wmodulefortesting1', unknown : 1 }) );

  test.case = 'o.full and o.atomic';
  test.shouldThrowErrorSync( () => _.npm.path.parse({ remotePath : 'npm:///wmodulefortesting1', full : 1, atomic : 1 }) );

  test.case = 'no settled options';
  test.shouldThrowErrorSync( () =>
  {
    return _.npm.path.parse({ remotePath : 'npm:///wmodulefortesting1', full : 0, atomic : 0, objects : 0 });
  });

  test.case = 'parsing objects for not npm path';
  test.shouldThrowErrorSync( () =>
  {
    return _.npm.path.parse({ remotePath : 'https://github.com/usser/repo.git', full : 0, atomic : 0, objects : 1 });
  });
}

//

function parseAtomic( test )
{
  test.open( 'paths without protocol' );

  test.case = 'simple remotePath';
  var remotePath = 'wmodulefortesting1';
  var exp =
  {
    'tag' : 'latest',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : '',
    'isGlobal' : false,
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 1 });
  test.identical( got, exp );

  test.case = 'with hash';
  var remotePath = 'wmodulefortesting1#1.0.0';
  var exp =
  {
    'hash' : '1.0.0',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : '',
    'isGlobal' : false,
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 1 });
  test.identical( got, exp );

  test.case = 'with tag';
  var remotePath = 'wmodulefortesting1!beta';
  var exp =
  {
    'tag' : 'beta',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : '',
    'isGlobal' : false,
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 1 });
  test.identical( got, exp );

  test.case = 'only hash';
  var remotePath = '#1.0.0';
  var exp =
  {
    'hash' : '1.0.0',
    'host' : '',
    'localVcsPath' : '',
    'isGlobal' : false,
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 1 });
  test.identical( got, exp );

  test.case = 'only tag';
  var remotePath = '!beta';
  var exp =
  {
    'tag' : 'beta',
    'host' : '',
    'localVcsPath' : '',
    'isGlobal' : false,
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 1 });
  test.identical( got, exp );

  test.close( 'paths without protocol' );

  /* - */

  test.open( 'global' );

  test.case = 'simple remotePath';
  var remotePath = 'npm:///wmodulefortesting1';
  var exp =
  {
    'protocol' : 'npm',
    'tag' : 'latest',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : '',
    'isGlobal' : true,
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 1 });
  test.identical( got, exp );

  test.case = 'with hash';
  var remotePath = 'npm:///wmodulefortesting1#1.0.0';
  var exp =
  {
    'protocol' : 'npm',
    'hash' : '1.0.0',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : '',
    'isGlobal' : true,
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 1 });
  test.identical( got, exp );

  test.case = 'with tag';
  var remotePath = 'npm:///wmodulefortesting1!beta';
  var exp =
  {
    'protocol' : 'npm',
    'tag' : 'beta',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : '',
    'isGlobal' : true,
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 1 });
  test.identical( got, exp );

  test.case = 'simple path with local';
  var remotePath = 'npm:///wmodulefortesting1/out/wmodulefortesting1';
  var exp =
  {
    'protocol' : 'npm',
    'tag' : 'latest',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : 'out/wmodulefortesting1',
    'isGlobal' : true,
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 1 });
  test.identical( got, exp );

  test.case = 'simple path with local and hash';
  var remotePath = 'npm:///wmodulefortesting1/out/wmodulefortesting1#0.3.100';
  var exp =
  {
    'protocol' : 'npm',
    'hash' : '0.3.100',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : 'out/wmodulefortesting1',
    'isGlobal' : true,
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 1 });
  test.identical( got, exp );

  test.case = 'simple path with local and tag';
  var remotePath = 'npm:///wmodulefortesting1/out/wmodulefortesting1!delta';
  var exp =
  {
    'protocol' : 'npm',
    'tag' : 'delta',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : 'out/wmodulefortesting1',
    'isGlobal' : true,
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 1 });
  test.identical( got, exp );

  test.case = 'only protocol';
  var remotePath = 'npm:///';
  var exp =
  {
    'protocol' : 'npm',
    'tag' : 'latest',
    'host' : '',
    'localVcsPath' : '',
    'isGlobal' : true,
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 1 });
  test.identical( got, exp );

  test.case = 'protocol and tag';
  var remotePath = 'npm:///!some tag';
  var exp =
  {
    'protocol' : 'npm',
    'tag' : 'some tag',
    'host' : '',
    'localVcsPath' : '',
    'isGlobal' : true,
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 1 });
  test.identical( got, exp );

  test.case = 'protocol and hash';
  var remotePath = 'npm:///#0.3.201';
  var exp =
  {
    'protocol' : 'npm',
    'hash' : '0.3.201',
    'host' : '',
    'localVcsPath' : '',
    'isGlobal' : true,
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 1 });
  test.identical( got, exp );

  test.close( 'global' );

  /* - */

  test.open( 'local' );

  test.case = 'simple remotePath';
  var remotePath = 'npm://wmodulefortesting1';
  var exp =
  {
    'protocol' : 'npm',
    'tag' : 'latest',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : '',
    'isGlobal' : false,
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 1 });
  test.identical( got, exp );

  test.case = 'with hash';
  var remotePath = 'npm://wmodulefortesting1#1.0.0';
  var exp =
  {
    'protocol' : 'npm',
    'hash' : '1.0.0',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : '',
    'isGlobal' : false,
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 1 });
  test.identical( got, exp );

  test.case = 'with tag';
  var remotePath = 'npm://wmodulefortesting1!beta';
  var exp =
  {
    'protocol' : 'npm',
    'tag' : 'beta',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : '',
    'isGlobal' : false,
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 1 });
  test.identical( got, exp );

  test.case = 'simple path with local';
  var remotePath = 'npm://wmodulefortesting1/out/wmodulefortesting1';
  var exp =
  {
    'protocol' : 'npm',
    'tag' : 'latest',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : 'out/wmodulefortesting1',
    'isGlobal' : false,
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 1 });
  test.identical( got, exp );

  test.case = 'simple path with local and hash';
  var remotePath = 'npm://wmodulefortesting1/out/wmodulefortesting1#0.3.100';
  var exp =
  {
    'protocol' : 'npm',
    'hash' : '0.3.100',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : 'out/wmodulefortesting1',
    'isGlobal' : false,
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 1 });
  test.identical( got, exp );

  test.case = 'simple path with local and tag';
  var remotePath = 'npm://wmodulefortesting1/out/wmodulefortesting1!delta';
  var exp =
  {
    'protocol' : 'npm',
    'tag' : 'delta',
    'host' : 'wmodulefortesting1',
    'localVcsPath' : 'out/wmodulefortesting1',
    'isGlobal' : false,
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 1 });
  test.identical( got, exp );

  test.case = 'only protocol';
  var remotePath = 'npm://';
  var exp =
  {
    'protocol' : 'npm',
    'tag' : 'latest',
    'host' : '',
    'localVcsPath' : '',
    'isGlobal' : false,
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 1 });
  test.identical( got, exp );

  test.case = 'protocol and tag';
  var remotePath = 'npm://!some tag';
  var exp =
  {
    'protocol' : 'npm',
    'tag' : 'some tag',
    'host' : '',
    'localVcsPath' : '',
    'isGlobal' : false,
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 1 });
  test.identical( got, exp );

  test.case = 'protocol and hash';
  var remotePath = 'npm://#0.3.201';
  var exp =
  {
    'protocol' : 'npm',
    'hash' : '0.3.201',
    'host' : '',
    'localVcsPath' : '',
    'isGlobal' : false,
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 1 });
  test.identical( got, exp );

  test.close( 'local' );

  /* - */

  test.open( 'not npm paths' );

  test.case = 'git path';
  var remotePath = 'git://git@github.com:user/repo';
  var exp =
  {
    'protocol' : 'git',
    'tag' : 'latest',
    'host' : 'git@github.com:user',
    'localVcsPath' : 'repo',
    'isGlobal' : false,
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 1 });
  test.identical( got, exp );

  test.case = 'ssh git path';
  var remotePath = 'ssh://git@github.com/user/repo';
  var exp =
  {
    'protocol' : 'ssh',
    'tag' : 'latest',
    'host' : 'git@github.com',
    'localVcsPath' : 'user/repo',
    'isGlobal' : false,
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 1 });
  test.identical( got, exp );

  test.case = 'https git path';
  var remotePath = 'https://github.com/user/repo';
  var exp =
  {
    'protocol' : 'https',
    'tag' : 'latest',
    'host' : 'github.com',
    'localVcsPath' : 'user/repo',
    'isGlobal' : false,
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 1 });
  test.identical( got, exp );

  test.case = 'https git path';
  var remotePath = 'file://local/repo';
  var exp =
  {
    'protocol' : 'file',
    'tag' : 'latest',
    'host' : 'local',
    'localVcsPath' : 'repo',
    'isGlobal' : false,
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 1 });
  test.identical( got, exp );

  test.close( 'not npm paths' );
}

//

function parseObjects( test )
{
  test.open( 'paths without protocol' );

  test.case = 'simple remotePath';
  var remotePath = 'wmodulefortesting1';
  var exp =
  {
    'tag' : 'latest',
    'host' : 'wmodulefortesting1',
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 0, objects : 1 });
  test.identical( got, exp );

  test.case = 'with hash';
  var remotePath = 'wmodulefortesting1#1.0.0';
  var exp =
  {
    'hash' : '1.0.0',
    'host' : 'wmodulefortesting1',
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 0, objects : 1 });
  test.identical( got, exp );

  test.case = 'with tag';
  var remotePath = 'wmodulefortesting1!beta';
  var exp =
  {
    'tag' : 'beta',
    'host' : 'wmodulefortesting1',
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 0, objects : 1 });
  test.identical( got, exp );

  test.case = 'only hash';
  var remotePath = '#1.0.0';
  var exp =
  {
    'hash' : '1.0.0',
    'host' : '',
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 0, objects : 1 });
  test.identical( got, exp );

  test.case = 'only tag';
  var remotePath = '!beta';
  var exp =
  {
    'tag' : 'beta',
    'host' : '',
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 0, objects : 1 });
  test.identical( got, exp );

  test.close( 'paths without protocol' );

  /* - */

  test.open( 'global' );

  test.case = 'simple remotePath';
  var remotePath = 'npm:///wmodulefortesting1';
  var exp =
  {
    'tag' : 'latest',
    'host' : 'wmodulefortesting1',
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 0, objects : 1 });
  test.identical( got, exp );

  test.case = 'with hash';
  var remotePath = 'npm:///wmodulefortesting1#1.0.0';
  var exp =
  {
    'hash' : '1.0.0',
    'host' : 'wmodulefortesting1',
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 0, objects : 1 });
  test.identical( got, exp );

  test.case = 'with tag';
  var remotePath = 'npm:///wmodulefortesting1!beta';
  var exp =
  {
    'tag' : 'beta',
    'host' : 'wmodulefortesting1',
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 0, objects : 1 });
  test.identical( got, exp );

  test.case = 'simple path with local';
  var remotePath = 'npm:///wmodulefortesting1/out/wmodulefortesting1';
  var exp =
  {
    'tag' : 'latest',
    'host' : 'wmodulefortesting1',
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 0, objects : 1 });
  test.identical( got, exp );

  test.case = 'simple path with local and hash';
  var remotePath = 'npm:///wmodulefortesting1/out/wmodulefortesting1#0.3.100';
  var exp =
  {
    'hash' : '0.3.100',
    'host' : 'wmodulefortesting1',
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 0, objects : 1 });
  test.identical( got, exp );

  test.case = 'simple path with local and tag';
  var remotePath = 'npm:///wmodulefortesting1/out/wmodulefortesting1!delta';
  var exp =
  {
    'tag' : 'delta',
    'host' : 'wmodulefortesting1',
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 0, objects : 1 });
  test.identical( got, exp );

  test.case = 'only protocol';
  var remotePath = 'npm:///';
  var exp =
  {
    'tag' : 'latest',
    'host' : '',
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 0, objects : 1 });
  test.identical( got, exp );

  test.case = 'protocol and tag';
  var remotePath = 'npm:///!some tag';
  var exp =
  {
    'tag' : 'some tag',
    'host' : '',
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 0, objects : 1 });
  test.identical( got, exp );

  test.case = 'protocol and hash';
  var remotePath = 'npm:///#0.3.201';
  var exp =
  {
    'hash' : '0.3.201',
    'host' : '',
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 0, objects : 1 });
  test.identical( got, exp );

  test.close( 'global' );

  /* - */

  test.open( 'local' );

  test.case = 'simple remotePath';
  var remotePath = 'npm://wmodulefortesting1';
  var exp =
  {
    'tag' : 'latest',
    'host' : 'wmodulefortesting1',
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 0, objects : 1 });
  test.identical( got, exp );

  test.case = 'with hash';
  var remotePath = 'npm://wmodulefortesting1#1.0.0';
  var exp =
  {
    'hash' : '1.0.0',
    'host' : 'wmodulefortesting1',
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 0, objects : 1 });
  test.identical( got, exp );

  test.case = 'with tag';
  var remotePath = 'npm://wmodulefortesting1!beta';
  var exp =
  {
    'tag' : 'beta',
    'host' : 'wmodulefortesting1',
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 0, objects : 1 });
  test.identical( got, exp );

  test.case = 'simple path with local';
  var remotePath = 'npm://wmodulefortesting1/out/wmodulefortesting1';
  var exp =
  {
    'tag' : 'latest',
    'host' : 'wmodulefortesting1',
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 0, objects : 1 });
  test.identical( got, exp );

  test.case = 'simple path with local and hash';
  var remotePath = 'npm://wmodulefortesting1/out/wmodulefortesting1#0.3.100';
  var exp =
  {
    'hash' : '0.3.100',
    'host' : 'wmodulefortesting1',
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 0, objects : 1 });
  test.identical( got, exp );

  test.case = 'simple path with local and tag';
  var remotePath = 'npm://wmodulefortesting1/out/wmodulefortesting1!delta';
  var exp =
  {
    'tag' : 'delta',
    'host' : 'wmodulefortesting1',
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 0, objects : 1 });
  test.identical( got, exp );

  test.case = 'only protocol';
  var remotePath = 'npm://';
  var exp =
  {
    'tag' : 'latest',
    'host' : '',
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 0, objects : 1 });
  test.identical( got, exp );

  test.case = 'protocol and tag';
  var remotePath = 'npm://!some tag';
  var exp =
  {
    'tag' : 'some tag',
    'host' : '',
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 0, objects : 1 });
  test.identical( got, exp );

  test.case = 'protocol and hash';
  var remotePath = 'npm://#0.3.201';
  var exp =
  {
    'hash' : '0.3.201',
    'host' : '',
  };
  var got = _.npm.path.parse({ remotePath, full : 0, atomic : 0, objects : 1 });
  test.identical( got, exp );

  test.close( 'local' );
}

//

function strFull( test )
{
  test.open( 'paths without protocol' );

  test.case = 'simple remotePath';
  var parsed = _.npm.path.parse( 'wmodulefortesting1' );
  var exp = 'wmodulefortesting1';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'with hash';
  var parsed = _.npm.path.parse( 'wmodulefortesting1#1.0.0' );
  var exp = 'wmodulefortesting1#1.0.0';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'with tag';
  var parsed = _.npm.path.parse( 'wmodulefortesting1!beta' );
  var exp = 'wmodulefortesting1!beta';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'only hash';
  var parsed = _.npm.path.parse( '#1.0.0' );
  var exp = '#1.0.0';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'only tag';
  var parsed = _.npm.path.parse( '!beta' );
  var exp = '!beta';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.close( 'paths without protocol' );

  /* - */

  test.open( 'global' );

  test.case = 'simple remotePath';
  var parsed = _.npm.path.parse( 'npm:///wmodulefortesting1' );
  var exp = 'npm:///wmodulefortesting1';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'with hash';
  var parsed = _.npm.path.parse( 'npm:///wmodulefortesting1#1.0.0' );
  var exp = 'npm:///wmodulefortesting1#1.0.0';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'with tag';
  var parsed = _.npm.path.parse( 'npm:///wmodulefortesting1!beta' );
  var exp = 'npm:///wmodulefortesting1!beta';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'simple path with local';
  var parsed = _.npm.path.parse( 'npm:///wmodulefortesting1/out/wmodulefortesting1' );
  var exp = 'npm:///wmodulefortesting1/out/wmodulefortesting1';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'simple path with local and hash';
  var parsed = _.npm.path.parse( 'npm:///wmodulefortesting1/out/wmodulefortesting1#0.3.100' );
  var exp = 'npm:///wmodulefortesting1/out/wmodulefortesting1#0.3.100';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'simple path with local and tag';
  var parsed = _.npm.path.parse( 'npm:///wmodulefortesting1/out/wmodulefortesting1!delta' );
  var exp = 'npm:///wmodulefortesting1/out/wmodulefortesting1!delta';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'only protocol';
  var parsed = _.npm.path.parse( 'npm:///' );
  var exp = 'npm:///';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'protocol and tag';
  var parsed = _.npm.path.parse( 'npm:///!some tag' );
  var exp = 'npm:///!some tag';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'protocol and hash';
  var parsed = _.npm.path.parse( 'npm:///#0.3.201' );
  var exp = 'npm:///#0.3.201';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.close( 'global' );

  /* - */

  test.open( 'local' );

  test.case = 'simple remotePath';
  var parsed = _.npm.path.parse( 'npm://wmodulefortesting1' );
  var exp = 'npm://wmodulefortesting1';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'with hash';
  var parsed = _.npm.path.parse( 'npm://wmodulefortesting1#1.0.0' );
  var exp = 'npm://wmodulefortesting1#1.0.0';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'with tag';
  var parsed = _.npm.path.parse( 'npm://wmodulefortesting1!beta' );
  var exp = 'npm://wmodulefortesting1!beta';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'simple path with local';
  var parsed = _.npm.path.parse( 'npm://wmodulefortesting1/out/wmodulefortesting1' );
  var exp = 'npm://wmodulefortesting1/out/wmodulefortesting1';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'simple path with local and hash';
  var parsed = _.npm.path.parse( 'npm://wmodulefortesting1/out/wmodulefortesting1#0.3.100' );
  var exp = 'npm://wmodulefortesting1/out/wmodulefortesting1#0.3.100';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'simple path with local and tag';
  var parsed = _.npm.path.parse( 'npm://wmodulefortesting1/out/wmodulefortesting1!delta' );
  var exp = 'npm://wmodulefortesting1/out/wmodulefortesting1!delta';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'only protocol';
  var parsed = _.npm.path.parse( 'npm://' );
  var exp = 'npm://';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'protocol and tag';
  var parsed = _.npm.path.parse( 'npm://!some tag' );
  var exp = 'npm://!some tag';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'protocol and hash';
  var parsed = _.npm.path.parse( 'npm://#0.3.201' );
  var exp = 'npm://#0.3.201';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.close( 'local' );

  /* - */

  test.open( 'not npm paths' );

  test.case = 'git path';
  var parsed = _.npm.path.parse( 'git://git@github.com:user/repo' );
  var exp = 'git://git@github.com:user/repo';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'ssh git path';
  var parsed = _.npm.path.parse( 'ssh://git@github.com/user/repo' );
  var exp = 'ssh://git@github.com/user/repo';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'https git path';
  var parsed = _.npm.path.parse( 'https://github.com/user/repo' );
  var exp = 'https://github.com/user/repo';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'https git path';
  var parsed = _.npm.path.parse( 'file://local/repo' );
  var exp = 'file://local/repo';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.close( 'not npm paths' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.npm.path.str() );

  test.case = 'extra arguments';
  var src = _.npm.path.parse( 'npm:///wmodulefortesting1' );
  test.shouldThrowErrorSync( () => _.npm.path.str( src, src ) );

  test.case = 'not valid srcPath';
  var src = { tag : 'delta' };
  test.shouldThrowErrorSync( () => _.npm.path.str( src ) );

  test.case = 'tag and hash in path';
  var src = _.npm.path.parse( 'npm:///wmodulefortesting1!beta' );
  src.hash = '0.3.100';
  test.shouldThrowErrorSync( () => _.npm.path.str( src ) );
}

//

function strAtomic( test )
{
  test.open( 'paths without protocol' );

  test.case = 'simple remotePath';
  var parsed = _.npm.path.parse({ remotePath : 'wmodulefortesting1', full : 0, atomic : 1 });
  var exp = 'wmodulefortesting1';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'with hash';
  var parsed = _.npm.path.parse({ remotePath : 'wmodulefortesting1#1.0.0', full : 0, atomic : 1 });
  var exp = 'wmodulefortesting1#1.0.0';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'with tag';
  var parsed = _.npm.path.parse({ remotePath : 'wmodulefortesting1!beta', full : 0, atomic : 1 });
  var exp = 'wmodulefortesting1!beta';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'only hash';
  var parsed = _.npm.path.parse({ remotePath : '#1.0.0', full : 0, atomic : 1 });
  var exp = '#1.0.0';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'only tag';
  var parsed = _.npm.path.parse({ remotePath : '!beta', full : 0, atomic : 1 });
  var exp = '!beta';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.close( 'paths without protocol' );

  /* - */

  test.open( 'global' );

  test.case = 'simple remotePath';
  var parsed = _.npm.path.parse({ remotePath : 'npm:///wmodulefortesting1', full : 0, atomic : 1 });
  var exp = 'npm:///wmodulefortesting1';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'with hash';
  var parsed = _.npm.path.parse({ remotePath : 'npm:///wmodulefortesting1#1.0.0', full : 0, atomic : 1 });
  var exp = 'npm:///wmodulefortesting1#1.0.0';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'with tag';
  var parsed = _.npm.path.parse({ remotePath : 'npm:///wmodulefortesting1!beta', full : 0, atomic : 1 });
  var exp = 'npm:///wmodulefortesting1!beta';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'simple path with local';
  var parsed = _.npm.path.parse({ remotePath : 'npm:///wmodulefortesting1/out/wmodulefortesting1', full : 0, atomic : 1 });
  var exp = 'npm:///wmodulefortesting1/out/wmodulefortesting1';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'simple path with local and hash';
  var parsed = _.npm.path.parse({ remotePath : 'npm:///wmodulefortesting1/out/wmodulefortesting1#0.3.100', full : 0, atomic : 1 });
  var exp = 'npm:///wmodulefortesting1/out/wmodulefortesting1#0.3.100';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'simple path with local and tag';
  var parsed = _.npm.path.parse({ remotePath : 'npm:///wmodulefortesting1/out/wmodulefortesting1!delta', full : 0, atomic : 1 });
  var exp = 'npm:///wmodulefortesting1/out/wmodulefortesting1!delta';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'only protocol';
  var parsed = _.npm.path.parse({ remotePath : 'npm:///', full : 0, atomic : 1 });
  var exp = 'npm:///';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'protocol and tag';
  var parsed = _.npm.path.parse({ remotePath : 'npm:///!some tag', full : 0, atomic : 1 });
  var exp = 'npm:///!some tag';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'protocol and hash';
  var parsed = _.npm.path.parse({ remotePath : 'npm:///#0.3.201', full : 0, atomic : 1 });
  var exp = 'npm:///#0.3.201';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.close( 'global' );

  /* - */

  test.open( 'local' );

  test.case = 'simple remotePath';
  var parsed = _.npm.path.parse({ remotePath : 'npm://wmodulefortesting1', full : 0, atomic : 1 });
  var exp = 'npm://wmodulefortesting1';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'with hash';
  var parsed = _.npm.path.parse({ remotePath : 'npm://wmodulefortesting1#1.0.0', full : 0, atomic : 1 });
  var exp = 'npm://wmodulefortesting1#1.0.0';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'with tag';
  var parsed = _.npm.path.parse({ remotePath : 'npm://wmodulefortesting1!beta', full : 0, atomic : 1 });
  var exp = 'npm://wmodulefortesting1!beta';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'simple path with local';
  var parsed = _.npm.path.parse({ remotePath : 'npm://wmodulefortesting1/out/wmodulefortesting1', full : 0, atomic : 1 });
  var exp = 'npm://wmodulefortesting1/out/wmodulefortesting1';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'simple path with local and hash';
  var parsed = _.npm.path.parse({ remotePath : 'npm://wmodulefortesting1/out/wmodulefortesting1#0.3.100', full : 0, atomic : 1 });
  var exp = 'npm://wmodulefortesting1/out/wmodulefortesting1#0.3.100';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'simple path with local and tag';
  var parsed = _.npm.path.parse({ remotePath : 'npm://wmodulefortesting1/out/wmodulefortesting1!delta', full : 0, atomic : 1 });
  var exp = 'npm://wmodulefortesting1/out/wmodulefortesting1!delta';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'only protocol';
  var parsed = _.npm.path.parse({ remotePath : 'npm://', full : 0, atomic : 1 });
  var exp = 'npm://';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'protocol and tag';
  var parsed = _.npm.path.parse({ remotePath : 'npm://!some tag', full : 0, atomic : 1 });
  var exp = 'npm://!some tag';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'protocol and hash';
  var parsed = _.npm.path.parse({ remotePath : 'npm://#0.3.201', full : 0, atomic : 1 });
  var exp = 'npm://#0.3.201';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.close( 'local' );

  /* - */

  test.open( 'not npm paths' );

  test.case = 'git path';
  var parsed = _.npm.path.parse({ remotePath : 'git://git@github.com:user/repo', full : 0, atomic : 1 });
  var exp = 'git://git@github.com:user/repo';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'ssh git path';
  var parsed = _.npm.path.parse({ remotePath : 'ssh://git@github.com/user/repo', full : 0, atomic : 1 });
  var exp = 'ssh://git@github.com/user/repo';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'https git path';
  var parsed = _.npm.path.parse({ remotePath : 'https://github.com/user/repo', full : 0, atomic : 1 });
  var exp = 'https://github.com/user/repo';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'https git path';
  var parsed = _.npm.path.parse({ remotePath : 'file://local/repo', full : 0, atomic : 1 });
  var exp = 'file://local/repo';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.close( 'not npm paths' );
}

//

function strObjects( test )
{
  test.open( 'paths without protocol' );

  test.case = 'simple remotePath';
  var parsed = _.npm.path.parse({ remotePath : 'wmodulefortesting1', full : 0, atomic : 0, objects : 1 });
  var exp = 'wmodulefortesting1';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'with hash';
  var parsed = _.npm.path.parse({ remotePath : 'wmodulefortesting1#1.0.0', full : 0, atomic : 0, objects : 1 });
  var exp = 'wmodulefortesting1#1.0.0';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'with tag';
  var parsed = _.npm.path.parse({ remotePath : 'wmodulefortesting1!beta', full : 0, atomic : 0, objects : 1 });
  var exp = 'wmodulefortesting1!beta';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'only hash';
  var parsed = _.npm.path.parse({ remotePath : '#1.0.0', full : 0, atomic : 0, objects : 1 });
  var exp = '#1.0.0';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'only tag';
  var parsed = _.npm.path.parse({ remotePath : '!beta', full : 0, atomic : 0, objects : 1 });
  var exp = '!beta';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.close( 'paths without protocol' );

  /* - */

  test.open( 'global' );

  test.case = 'simple remotePath';
  var parsed = _.npm.path.parse({ remotePath : 'npm:///wmodulefortesting1', full : 0, atomic : 0, objects : 1 });
  var exp = 'wmodulefortesting1';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'with hash';
  var parsed = _.npm.path.parse({ remotePath : 'npm:///wmodulefortesting1#1.0.0', full : 0, atomic : 0, objects : 1 });
  var exp = 'wmodulefortesting1#1.0.0';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'with tag';
  var parsed = _.npm.path.parse({ remotePath : 'npm:///wmodulefortesting1!beta', full : 0, atomic : 0, objects : 1 });
  var exp = 'wmodulefortesting1!beta';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'simple path with local';
  var parsed = _.npm.path.parse({ remotePath : 'npm:///wmodulefortesting1/out/wmodulefortesting1', full : 0, atomic : 0, objects : 1 });
  var exp = 'wmodulefortesting1';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'simple path with local and hash';
  var parsed = _.npm.path.parse({ remotePath : 'npm:///wmodulefortesting1/out/wmodulefortesting1#0.3.100', full : 0, atomic : 0, objects : 1 });
  var exp = 'wmodulefortesting1#0.3.100';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'simple path with local and tag';
  var parsed = _.npm.path.parse({ remotePath : 'npm:///wmodulefortesting1/out/wmodulefortesting1!delta', full : 0, atomic : 0, objects : 1 });
  var exp = 'wmodulefortesting1!delta';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'only protocol';
  var parsed = _.npm.path.parse({ remotePath : 'npm:///', full : 0, atomic : 0, objects : 1 });
  var exp = '';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'protocol and tag';
  var parsed = _.npm.path.parse({ remotePath : 'npm:///!some tag', full : 0, atomic : 0, objects : 1 });
  var exp = '!some tag';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'protocol and hash';
  var parsed = _.npm.path.parse({ remotePath : 'npm:///#0.3.201', full : 0, atomic : 0, objects : 1 });
  var exp = '#0.3.201';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.close( 'global' );

  /* - */

  test.open( 'local' );

  test.case = 'simple remotePath';
  var parsed = _.npm.path.parse({ remotePath : 'npm://wmodulefortesting1', full : 0, atomic : 0, objects : 1 });
  var exp = 'wmodulefortesting1';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'with hash';
  var parsed = _.npm.path.parse({ remotePath : 'npm://wmodulefortesting1#1.0.0', full : 0, atomic : 0, objects : 1 });
  var exp = 'wmodulefortesting1#1.0.0';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'with tag';
  var parsed = _.npm.path.parse({ remotePath : 'npm://wmodulefortesting1!beta', full : 0, atomic : 0, objects : 1 });
  var exp = 'wmodulefortesting1!beta';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'simple path with local';
  var parsed = _.npm.path.parse({ remotePath : 'npm://wmodulefortesting1/out/wmodulefortesting1', full : 0, atomic : 0, objects : 1 });
  var exp = 'wmodulefortesting1';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'simple path with local and hash';
  var parsed = _.npm.path.parse({ remotePath : 'npm://wmodulefortesting1/out/wmodulefortesting1#0.3.100', full : 0, atomic : 0, objects : 1 });
  var exp = 'wmodulefortesting1#0.3.100';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'simple path with local and tag';
  var parsed = _.npm.path.parse({ remotePath : 'npm://wmodulefortesting1/out/wmodulefortesting1!delta', full : 0, atomic : 0, objects : 1 });
  var exp = 'wmodulefortesting1!delta';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'only protocol';
  var parsed = _.npm.path.parse({ remotePath : 'npm://', full : 0, atomic : 0, objects : 1 });
  var exp = '';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'protocol and tag';
  var parsed = _.npm.path.parse({ remotePath : 'npm://!some tag', full : 0, atomic : 0, objects : 1 });
  var exp = '!some tag';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.case = 'protocol and hash';
  var parsed = _.npm.path.parse({ remotePath : 'npm://#0.3.201', full : 0, atomic : 0, objects : 1 });
  var exp = '#0.3.201';
  var got = _.npm.path.str( parsed );
  test.identical( got, exp );

  test.close( 'local' );
}

//

function normalize( test )
{
  test.open( 'normalized npm paths' );

  test.case = 'simple remotePath';
  var remotePath = 'wmodulefortesting1';
  var exp = 'npm:///wmodulefortesting1';
  var got = _.npm.path.normalize( remotePath );
  test.identical( got, exp );

  test.case = 'with hash';
  var remotePath = 'wmodulefortesting1#1.0.0';
  var exp = 'npm:///wmodulefortesting1#1.0.0';
  var got = _.npm.path.normalize( remotePath );
  test.identical( got, exp );

  test.case = 'with tag';
  var remotePath = 'wmodulefortesting1!beta';
  var exp = 'npm:///wmodulefortesting1!beta';
  var got = _.npm.path.normalize( remotePath );
  test.identical( got, exp );

  test.case = 'only hash';
  var remotePath = '#1.0.0';
  var exp = 'npm:///#1.0.0';
  var got = _.npm.path.normalize( remotePath );
  test.identical( got, exp );

  test.case = 'only tag';
  var remotePath = '!beta';
  var exp = 'npm:///!beta';
  var got = _.npm.path.normalize( remotePath );
  test.identical( got, exp );

  test.close( 'normalized npm paths' );

  /* - */

  test.open( 'global npm paths' );

  test.case = 'simple remotePath';
  var remotePath = 'npm:///wmodulefortesting1';
  var exp = 'npm:///wmodulefortesting1';
  var got = _.npm.path.normalize( remotePath );
  test.identical( got, exp );

  test.case = 'with hash';
  var remotePath = 'npm:///wmodulefortesting1#1.0.0';
  var exp = 'npm:///wmodulefortesting1#1.0.0';
  var got = _.npm.path.normalize( remotePath );
  test.identical( got, exp );

  test.case = 'with tag';
  var remotePath = 'npm:///wmodulefortesting1!beta';
  var exp = 'npm:///wmodulefortesting1!beta';
  var got = _.npm.path.normalize( remotePath );
  test.identical( got, exp );

  test.case = 'simple path with local';
  var remotePath = 'npm:///wmodulefortesting1/out/wmodulefortesting1';
  var exp = 'npm:///wmodulefortesting1/out/wmodulefortesting1';
  var got = _.npm.path.normalize( remotePath );
  test.identical( got, exp );

  test.case = 'simple path with local and hash';
  var remotePath = 'npm:///wmodulefortesting1/out/wmodulefortesting1#0.3.100';
  var exp = 'npm:///wmodulefortesting1/out/wmodulefortesting1#0.3.100';
  var got = _.npm.path.normalize( remotePath );
  test.identical( got, exp );

  test.case = 'simple path with local and tag';
  var remotePath = 'npm:///wmodulefortesting1/out/wmodulefortesting1!delta';
  var exp = 'npm:///wmodulefortesting1/out/wmodulefortesting1!delta';
  var got = _.npm.path.normalize( remotePath );
  test.identical( got, exp );

  test.case = 'only protocol';
  var remotePath = 'npm:///';
  var exp = 'npm:///';
  var got = _.npm.path.normalize( remotePath );
  test.identical( got, exp );

  test.case = 'protocol and tag';
  var remotePath = 'npm:///!some tag';
  var exp = 'npm:///!some tag';
  var got = _.npm.path.normalize( remotePath );
  test.identical( got, exp );

  test.case = 'protocol and hash';
  var remotePath = 'npm:///#0.3.201';
  var exp = 'npm:///#0.3.201';
  var got = _.npm.path.normalize( remotePath );
  test.identical( got, exp );

  test.close( 'global npm paths' );

  /* - */

  test.open( 'local npm paths' );

  test.case = 'simple remotePath';
  var remotePath = 'npm://wmodulefortesting1';
  var exp = 'npm:///wmodulefortesting1';
  var got = _.npm.path.normalize( remotePath );
  test.identical( got, exp );

  test.case = 'with hash';
  var remotePath = 'npm://wmodulefortesting1#1.0.0';
  var exp = 'npm:///wmodulefortesting1#1.0.0';
  var got = _.npm.path.normalize( remotePath );
  test.identical( got, exp );

  test.case = 'with tag';
  var remotePath = 'npm://wmodulefortesting1!beta';
  var exp = 'npm:///wmodulefortesting1!beta';
  var got = _.npm.path.normalize( remotePath );
  test.identical( got, exp );

  test.case = 'simple path with local';
  var remotePath = 'npm://wmodulefortesting1/out/wmodulefortesting1';
  var exp = 'npm:///wmodulefortesting1/out/wmodulefortesting1';
  var got = _.npm.path.normalize( remotePath );
  test.identical( got, exp );

  test.case = 'simple path with local and hash';
  var remotePath = 'npm://wmodulefortesting1/out/wmodulefortesting1#0.3.100';
  var exp = 'npm:///wmodulefortesting1/out/wmodulefortesting1#0.3.100';
  var got = _.npm.path.normalize( remotePath );
  test.identical( got, exp );

  test.case = 'simple path with local and tag';
  var remotePath = 'npm://wmodulefortesting1/out/wmodulefortesting1!delta';
  var exp = 'npm:///wmodulefortesting1/out/wmodulefortesting1!delta';
  var got = _.npm.path.normalize( remotePath );
  test.identical( got, exp );

  test.case = 'only protocol';
  var remotePath = 'npm://';
  var exp = 'npm:///';
  var got = _.npm.path.normalize( remotePath );
  test.identical( got, exp );

  test.case = 'protocol and tag';
  var remotePath = 'npm://!some tag';
  var exp = 'npm:///!some tag';
  var got = _.npm.path.normalize( remotePath );
  test.identical( got, exp );

  test.case = 'protocol and hash';
  var remotePath = 'npm://#0.3.201';
  var exp = 'npm:///#0.3.201';
  var got = _.npm.path.normalize( remotePath );
  test.identical( got, exp );

  test.close( 'local npm paths' );

  /* - */

  test.open( 'not npm paths' );

  test.case = 'git path';
  var remotePath = 'git://git@github.com:user/repo';
  var exp = 'git:///git@github.com:user/repo';
  var got = _.npm.path.normalize( remotePath );
  test.identical( got, exp );

  test.case = 'ssh git path';
  var remotePath = 'ssh://git@github.com/user/repo';
  var exp = 'ssh:///git@github.com/user/repo';
  var got = _.npm.path.normalize( remotePath );
  test.identical( got, exp );

  test.case = 'https git path';
  var remotePath = 'https://github.com/user/repo';
  var exp = 'https:///github.com/user/repo';
  var got = _.npm.path.normalize( remotePath );
  test.identical( got, exp );

  test.case = 'https git path';
  var remotePath = 'file://local/repo';
  var exp = 'file:///local/repo';
  var got = _.npm.path.normalize( remotePath );
  test.identical( got, exp );

  test.close( 'not npm paths' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.npm.path.normalize() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.npm.path.normalize( 'npm:///wmodulefortesting1', 'npm://wmodulefortesting1' ) );

  test.case = 'remotePath is not defined string';
  test.shouldThrowErrorSync( () => _.npm.path.normalize( '' ) );

  test.case = 'remotePath with git repo';
  test.shouldThrowErrorSync( () => _.npm.path.normalize( 'user/repo.git' ) );
  test.shouldThrowErrorSync( () => _.npm.path.normalize( 'git@github.com:user/repo.git' ) );

  test.case = 'wrong type of remotePath';
  test.shouldThrowErrorSync( () => _.npm.path.normalize([ 'npm:///wmodulefortesting1' ]) );

  test.case = 'unknown option in options map';
  test.shouldThrowErrorSync( () => _.npm.path.normalize({ remotePath : 'npm:///wmodulefortesting1', unknown : 1 }) );

  test.case = 'remotePath with hash and tag';
  var remotePath = 'npm:///wmodulefortesting1#1.0.0!beta';
  test.shouldThrowErrorSync( () => _.npm.path.normalize( remotePath ) );
}

//

function nativize( test )
{
  test.open( 'nativized npm paths' );

  test.case = 'simple remotePath';
  var remotePath = 'wmodulefortesting1';
  var exp = 'wmodulefortesting1';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'with hash';
  var remotePath = 'wmodulefortesting1#1.0.0';
  var exp = 'wmodulefortesting1@1.0.0';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'with tag';
  var remotePath = 'wmodulefortesting1!beta';
  var exp = 'wmodulefortesting1@beta';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'only hash';
  var remotePath = '#1.0.0';
  var exp = '@1.0.0';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'only tag';
  var remotePath = '!beta';
  var exp = '@beta';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.close( 'nativized npm paths' );

  /* - */

  test.open( 'global npm paths' );

  test.case = 'simple remotePath';
  var remotePath = 'npm:///wmodulefortesting1';
  var exp = 'wmodulefortesting1';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'with hash';
  var remotePath = 'npm:///wmodulefortesting1#1.0.0';
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
  var exp = 'wmodulefortesting1/out/wmodulefortesting1';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'simple path with local and hash';
  var remotePath = 'npm:///wmodulefortesting1/out/wmodulefortesting1#0.3.100';
  var exp = 'wmodulefortesting1/out/wmodulefortesting1@0.3.100';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'simple path with local and tag';
  var remotePath = 'npm:///wmodulefortesting1/out/wmodulefortesting1!delta';
  var exp = 'wmodulefortesting1/out/wmodulefortesting1@delta';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'only protocol';
  var remotePath = 'npm:///';
  var exp = '';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'protocol and tag';
  var remotePath = 'npm:///!some tag';
  var exp = '@some tag';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'protocol and hash';
  var remotePath = 'npm:///#0.3.201';
  var exp = '@0.3.201';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.close( 'global npm paths' );

  /* - */

  test.open( 'local npm paths' );

  test.case = 'simple remotePath';
  var remotePath = 'npm://wmodulefortesting1';
  var exp = 'wmodulefortesting1';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'with hash';
  var remotePath = 'npm://wmodulefortesting1#1.0.0';
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
  var exp = 'wmodulefortesting1/out/wmodulefortesting1';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'simple path with local and hash';
  var remotePath = 'npm://wmodulefortesting1/out/wmodulefortesting1#0.3.100';
  var exp = 'wmodulefortesting1/out/wmodulefortesting1@0.3.100';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'simple path with local and tag';
  var remotePath = 'npm://wmodulefortesting1/out/wmodulefortesting1!delta';
  var exp = 'wmodulefortesting1/out/wmodulefortesting1@delta';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'only protocol';
  var remotePath = 'npm://';
  var exp = '';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'protocol and tag';
  var remotePath = 'npm://!some tag';
  var exp = '@some tag';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'protocol and hash';
  var remotePath = 'npm://#0.3.201';
  var exp = '@0.3.201';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.close( 'local npm paths' );

  /* - */

  test.open( 'not npm paths' );

  test.case = 'git path';
  var remotePath = 'git://git@github.com:user/repo';
  var exp = 'git://git@github.com:user/repo';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'ssh git path';
  var remotePath = 'ssh://git@github.com/user/repo';
  var exp = 'ssh://git@github.com/user/repo';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'https git path';
  var remotePath = 'https://github.com/user/repo';
  var exp = 'https://github.com/user/repo';
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.case = 'https git path';
  var remotePath = 'file://local/repo';
  var exp = _.uri.nativize( 'file://local/repo' );
  var got = _.npm.path.nativize( remotePath );
  test.identical( got, exp );

  test.close( 'not npm paths' );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.npm.path.nativize() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.npm.path.nativize( 'npm:///wmodulefortesting1', 'npm://wmodulefortesting1' ) );

  test.case = 'remotePath is not defined string';
  test.shouldThrowErrorSync( () => _.npm.path.nativize( '' ) );

  test.case = 'remotePath with git repo';
  test.shouldThrowErrorSync( () => _.npm.path.nativize( 'user/repo.git' ) );
  test.shouldThrowErrorSync( () => _.npm.path.nativize( 'git@github.com:user/repo.git' ) );

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
  var remotePath = 'npm:///wmodulefortesting1';
  var got = _.npm.path.isFixated( remotePath );
  test.identical( got, false );

  test.case = 'path hash';
  var remotePath = 'npm:///wmodulefortesting1#1.0.0';
  var got = _.npm.path.isFixated( remotePath );
  test.identical( got, true );

  test.case = 'path with tag';
  var remotePath = 'npm:///wmodulefortesting1!beta';
  var got = _.npm.path.isFixated( remotePath );
  test.identical( got, false );

  /* */

  test.case = 'simple path';
  var remotePath = 'npm://wmodulefortesting1';
  var got = _.npm.path.isFixated( remotePath );
  test.identical( got, false );

  test.case = 'path hash';
  var remotePath = 'npm://wmodulefortesting1#1.0.0';
  var got = _.npm.path.isFixated( remotePath );
  test.identical( got, true );

  test.case = 'path with tag';
  var remotePath = 'npm://wmodulefortesting1!beta';
  var got = _.npm.path.isFixated( remotePath );
  test.identical( got, false );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.npm.path.isFixated() );

  test.case = 'extra arguments';
  test.shouldThrowErrorSync( () => _.npm.path.isFixated( 'npm:///wmodulefortesting1', 'npm://wmodulefortesting1' ) );

  test.case = 'wrong type of remotePath';
  test.shouldThrowErrorSync( () => _.npm.path.isFixated([ 'npm:///wmodulefortesting1' ]) );

  test.case = 'remotePath with hash and tag';
  var remotePath = 'npm:///wmodulefortesting1#1.0.0!beta';
  test.shouldThrowErrorSync( () => _.npm.path.isFixated( remotePath ) );
}

//

function fixate( test )
{
  test.case = 'simple path';
  var remotePath = 'npm:///wmodulefortesting1';
  var got = _.npm.path.fixate( remotePath );
  test.true( _.strHas( got, /npm:\/\/\/wmodulefortesting1#\d\.\d\.\d+/ ) );
  var gotVersion = got.replace( /.*(\d\.\d\.\d+)/, '$1' );
  var got = _.npm.remoteVersionLatest( 'npm:///wmodulefortesting1' );
  test.identical( got, gotVersion );

  test.case = 'path hash';
  var remotePath = 'npm:///wmodulefortesting1#1.0.0';
  var got = _.npm.path.fixate( remotePath );
  test.true( _.strHas( got, /npm:\/\/\/wmodulefortesting1#\d\.\d\.\d+/ ) );
  test.notIdentical( got, remotePath );
  var gotVersion = got.replace( /.*(\d\.\d\.\d+)/, '$1' );
  var got = _.npm.remoteVersionLatest( 'npm:///wmodulefortesting1' );
  test.identical( got, gotVersion );

  test.case = 'simple tag';
  var remotePath = 'npm:///wmodulefortesting1!beta';
  var got = _.npm.path.fixate( remotePath );
  test.true( _.strHas( got, /npm:\/\/\/wmodulefortesting1#\d\.\d\.\d+/ ) );
  test.notIdentical( got, remotePath );
  var gotVersion = got.replace( /.*(\d\.\d\.\d+)/, '$1' );
  var got = _.npm.remoteVersionLatest( 'npm:///wmodulefortesting1' );
  test.identical( got, gotVersion );

  /* */

  test.case = 'simple path';
  var remotePath = 'npm:///wmodulefortesting1';
  var got = _.npm.path.fixate({ remotePath });
  test.true( _.strHas( got, /npm:\/\/\/wmodulefortesting1#\d\.\d\.\d+/ ) );
  var gotVersion = got.replace( /.*(\d\.\d\.\d+)/, '$1' );
  var got = _.npm.remoteVersionLatest( 'npm:///wmodulefortesting1' );
  test.identical( got, gotVersion );

  test.case = 'path hash';
  var remotePath = 'npm:///wmodulefortesting1#1.0.0';
  var got = _.npm.path.fixate({ remotePath });
  test.true( _.strHas( got, /npm:\/\/\/wmodulefortesting1#\d\.\d\.\d+/ ) );
  test.notIdentical( got, remotePath );
  var gotVersion = got.replace( /.*(\d\.\d\.\d+)/, '$1' );
  var got = _.npm.remoteVersionLatest( 'npm:///wmodulefortesting1' );
  test.identical( got, gotVersion );

  test.case = 'simple tag';
  var remotePath = 'npm:///wmodulefortesting1!beta';
  var got = _.npm.path.fixate({ remotePath });
  test.true( _.strHas( got, /npm:\/\/\/wmodulefortesting1#\d\.\d\.\d+/ ) );
  test.notIdentical( got, remotePath );
  var gotVersion = got.replace( /.*(\d\.\d\.\d+)/, '$1' );
  var got = _.npm.remoteVersionLatest( 'npm:///wmodulefortesting1' );
  test.identical( got, gotVersion );

  /* */

  test.case = 'simple path, verbosity - 5';
  var remotePath = 'npm:///wmodulefortesting1';
  var got = _.npm.path.fixate({ remotePath, logger : 5 });
  test.true( _.strHas( got, /npm:\/\/\/wmodulefortesting1#\d\.\d\.\d+/ ) );
  var gotVersion = got.replace( /.*(\d\.\d\.\d+)/, '$1' );
  var got = _.npm.remoteVersionLatest( 'npm:///wmodulefortesting1' );
  test.identical( got, gotVersion );

  /* - */

  if( !Config.debug )
  return;

  test.case = 'without arguments';
  test.shouldThrowErrorSync( () => _.npm.path.fixate() );

  test.case = 'extra arguments';
  var remotePath = 'npm:///wmodulefortesting1#1.0.0!beta';
  test.shouldThrowErrorSync( () => _.npm.path.fixate( remotePath, remotePath ) );

  test.case = 'wrong type of remotePath';
  var remotePath = 'npm:///wmodulefortesting1';
  test.shouldThrowErrorSync( () => _.npm.path.fixate([ remotePath ]) );

  test.case = 'remote path has hash and tag';
  var remotePath = 'npm:///wmodulefortesting1#1.0.0!beta';
  test.shouldThrowErrorSync( () => _.npm.path.fixate( remotePath ) );

  test.case = 'unknown option in options map';
  var remotePath = 'npm:///wmodulefortesting1#1.0.0!beta';
  test.shouldThrowErrorSync( () => _.npm.path.fixate({ remotePath, unknown : 1 }) );
}

fixate.timeOut = 60000;

// --
// declare
// --

let Proto =
{

  name : 'Tools.mid.NpmTools.path',
  silencing : 1,
  enabled : 1,

  tests :
  {

    parseFull,
    parseAtomic,
    parseObjects,

    strFull,
    strAtomic,
    strObjects,

    normalize,
    nativize,

    isFixated,
    fixate,

  },

}

//

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
