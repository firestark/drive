<?php

class Route
{
    private static $router = null;

    public static function router(League\Route\Router $router)
    {
        self::$router = $router;
    }

    public static function get(string $route, closure $callback)
    {
        self::$router->map('GET', $route, $callback);
    }

    public static function post(string $route, closure $callback)
    {
        self::$router->map('POST', $route, $callback);
    }

    public static function put(string $route, closure $callback)
    {
        self::$router->map('PUT', $route, $callback);
    }

    public static function patch(string $route, closure $callback)
    {
        self::$router->map('PATCH', $route, $callback);
    }

    public static function delete(string $route, closure $callback)
    {
        self::$router->map('DELETE', $route, $callback);
    }
}