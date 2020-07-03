<?php

class Guard
{
    private static $guard = null;

    public static function instance(Services\Guard $guard)
    {
        self::$guard = $guard;
    }

    public static function authenticates(ArtDirector $artDirector): bool
    {
        return self::$guard->authenticates($artDirector);
    }

    public static function stamp(ArtDirector $artDirector): string
    {
        return self::$guard->stamp($artDirector);
    }
}