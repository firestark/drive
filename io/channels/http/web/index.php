<?php

use Firestark\Http\Router;
use Psr\Http\Message\ResponseInterface;
use Psr\Http\Message\ServerRequestInterface;
use Relay\Relay;

require __DIR__ . '/../../vendor/autoload.php';
require __DIR__ . '/../../tools/helpers.php';

$app = new Firestark\App;
$app->instance('app', $app);
$app->instance('router', new Router);
$app->instance('response', new Firestark\Http\Response(Laminas\Diactoros\Response\HtmlResponse::class));
$app->instance('status', new Firestark\Status);

Facade::setFacadeApplication($app);


including(__DIR__ . '/../../bindings');
including(__DIR__ . '/bindings');
including(__DIR__ . '/routes');
including(__DIR__ . '/statuses');
including(__DIR__ . '/../../app/procedures');


$app->instance('request', Laminas\Diactoros\ServerRequestFactory::fromGlobals());

$relay = new Relay([
    new \Firestark\Middlewares\RequestHandler($app['router'], $app['status']),
]);
    
$response = $relay->handle($app['request']);
(new Laminas\HttpHandlerRunner\Emitter\SapiEmitter)->emit($response);
