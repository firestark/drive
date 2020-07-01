<?php

class Status
{
    private static $matched = 0;
    private static $list = [];

    public static function match(int $status): closure
    {        
        if (! self::matches($status))
            throw new \runtimeException ( "The status code: {$status} has not been matched." );

        self::$matched = $status;
        return self::$list[$status];
    }

    public static function matching(int $status, closure $callback)
    {        
        if (self::matches($status))
            throw new \runtimeException("The status code: {$status} has already been matched.");

        self::$list[$status] = $callback;
    }

    public function matches($status): bool
    {
        return array_key_exists ($status, self::$list);
    }

    public static function matched(): int
    {
        return self::$matched;
    }
}