<?php

use Psr\Http\Message\ResponseInterface;

Route::post('/authenticate', function(): ResponseInterface {
    $artDirector = App::make(ArtDirector::class, Input::all());

    if (Guard::authenticates($artDirector))
        return Response::ok([])->withHeader('Authorization', Guard::stamp($artDirector));

    return Response::unauthorized([]);
});