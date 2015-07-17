<?php
namespace SSDB;

class Response
{
	public $cmd;
	public $code;
	public $data = null;
	public $message;

	public function __construct($code='ok', $data_or_message=null){
		$this->code = $code;
		if($code == 'ok'){
			$this->data = $data_or_message;
		}else{
			$this->message = $data_or_message;
		}
	}

	public function __toString(){
		if($this->code == 'ok'){
			$s = $this->data === null? '' : json_encode($this->data);
		}else{
			$s = $this->message;
		}
		return sprintf('%-13s %12s %s', $this->cmd, $this->code, $s);
	}

	public function ok(){
		return $this->code == 'ok';
	}

	public function not_found(){
		return $this->code == 'not_found';
	}
}
