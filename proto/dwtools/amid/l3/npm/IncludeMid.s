( function _IncludeMid_s_( ) {

'use strict';

/**
 * Collection of tools to use npm programmatically.
  @module Tools/mid/NpmTools
*/

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../../dwtools/Tools.s' );

  require( './IncludeBase.s' );
  require( './l1/Tools.s' );

}

if( typeof module !== 'undefined' )
module[ 'exports' ] = _global_.wTools;

})();
