<?php

use Relay\Relay;
use Laminas\Diactoros\Response\JsonResponse as json;
use Laminas\Diactoros\ServerRequestFactory as request;

require __DIR__ . '/../../vendor/autoload.php';

$app = new firestark\app;
$app->instance ( 'app', $app );
$app->instance ( 'statuses', new firestark\statuses );
$app->instance ( 'request', request::fromGlobals ( ) );
$app->instance ( 'response', new firestark\http\response ( json::class ) );
$app->instance ( 'router', new firestark\http\router );

facade::setFacadeApplication ( $app );

including ( __DIR__ . '/../../bindings' );
including ( __DIR__ . '/bindings' );
including ( __DIR__ . '/routes' );
including ( __DIR__ . '/statuses' );
including ( __DIR__ . '/../../app/procedures' );

$dispatcher = new firestark\http\dispatcher ( $app [ 'router' ]->routes );

$relay = new Relay ( [
    ( new Middlewares\Debugbar ( null, $app [ 'response' ] ) )->inline ( ),
    ( new Middlewares\Whoops ( null, $app [ 'response' ] ) )->catchErrors ( true ),
    // function ( $request, $handler ) use ( $app ) {
    //     $app [ 'request' ] = $request->withHeader ( 'Authorization', 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJjcmVkZW50aWFscyI6Ik86MTY6XCJ1c2VyXFxjcmVkZW50aWFsc1wiOjI6e3M6ODpcInVzZXJuYW1lXCI7czo1OlwiYWRtaW5cIjtzOjg6XCJwYXNzd29yZFwiO3M6NjQ6XCI4YzY5NzZlNWI1NDEwNDE1YmRlOTA4YmQ0ZGVlMTVkZmIxNjdhOWM4NzNmYzRiYjhhODFmNmYyYWI0NDhhOTE4XCI7fSJ9.L7-3oTxyqvQHlxD3W5oRaTFkgR92JbQRUOsFY6mDNrY' );
    //     return $handler->handle ( $app [ 'request' ] );
    // },
    new \firestark\middlewares\input ( $app ),
    new \firestark\middlewares\requestHandler ( $dispatcher ),
] );


$response = $relay->handle ( $app [ 'request' ] );
( new Laminas\HttpHandlerRunner\Emitter\SapiEmitter )->emit ( $response );