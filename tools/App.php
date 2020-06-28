<?php

class App
{
    private static $bindings = [];

    public static function bind(string $key, closure $action)
    {
        self::$bindings[$key] = $action;
    }

    public static function make(string $key, array $parameters)
    {
        return call_user_func_array(self::$bindings[$key], $parameters);
    }
}