<?php
namespace SSDB;

/**
 * All methods(except *exists) returns false on error,
 * so one should use Identical(if($ret === false)) to test the return value.
 */
class SimpleClient extends Client
{
	public function __construct($host, $port, $timeout_ms=2000){
		parent::__construct($host, $port, $timeout_ms);
		$this->easy();
	}
}
