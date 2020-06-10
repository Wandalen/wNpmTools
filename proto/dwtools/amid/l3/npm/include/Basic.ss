( function _Basic_ss_( )
{

'use strict';

/* npm */

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../../dwtools/Tools.s' );
  _.include( 'wHttp' );
  _.include( 'wProcess' );
  _.include( 'wFiles' );
  module[ 'exports' ] = _global_.wTools;
}

})();
