<?php
/**
 * Laravel 5.x 之 SSDB SESSION驱动。
 * 因为原本的 SessionHandler 类不满足 Laravel 5.x的要求，只能通过重写来满足框架的要求。
 */

namespace SSDB;

class LaravelSessionHandler extends SessionHandler {

    /**
     * @param Client $ssdb
     * @param int $ttl
     */
    public function __construct($save_path, $ttl = null, $prefix = 'sess_') {
        $this->_ttl = $ttl ?: ini_get('session.gc_maxlifetime');
        $this->_prefix = $prefix;

        $components = parse_url($save_path);
        
        if ($components === false || 
                !isset($components['scheme'], $components['host'], $components['port']) 
                || strtolower($components['scheme']) !== 'tcp') {
            throw new Exception('Invalid session.save_path: ' . $save_path);
        }
        
        $this->_client = new Client($components['host'], $components['port']);

        if (isset($components['query'])) {
            parse_str($components['query'], $query);
            if (isset($query['auth'])) {
                $this->_client->auth($query['auth']);
            }
        }
    }

    /**
     * @param string $save_path
     * @param string $name
     * @return boolean
     */
    public function open($save_path, $name) {
        return true;
    }
}
