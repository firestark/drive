<?php

require __DIR__ . '/vendor/autoload.php';
require __DIR__ . '/../../../../tools/helpers.php';


$router = new \League\Route\Router;
\Route::router($router);

including(__DIR__ . '/../../../../app/procedures');
including(__DIR__ . '/bindings');
including(__DIR__ . '/statuses');
including(__DIR__ . '/routes');

$request = \Laminas\Diactoros\ServerRequestFactory::fromGlobals();

Guard::instance(\App::make(\Services\Guard::class));

$relay = new \Relay\Relay([
    new \Middlewares\AuthenticationMiddleware(\App::make(\Services\Guard::class)),
    new \Middlewares\InputMiddleware,
    new \Middlewares\RequestHandlerMiddleware($router),
]);

$response = $relay->handle($request);

(new \Laminas\HttpHandlerRunner\Emitter\SapiEmitter)->emit($response);