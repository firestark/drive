<?php

class Input
{
    private static $data = [];

    public static function set(string $key, $value)
    {
        self::$data[$key] = $value;
    }

    public static function get(string $key)
    {
        return self::$data[$key];
    }

    public static function all(): array
    {
        return self::$data;
    }
}