( function _Basic_ss_()
{

'use strict';

/* npm */

if( typeof module !== 'undefined' )
{
  let _ = require( '../../../../../node_modules/Tools' );
  _.include( 'wHttp' );
  _.include( 'wProcess' );
  _.include( 'wFiles' );
  module[ 'exports' ] = _global_.wTools;
}

})();
