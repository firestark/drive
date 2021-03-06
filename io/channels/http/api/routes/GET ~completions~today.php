<?php

use Services\Guard;
use Psr\Http\Message\ServerRequestInterface;

Route::get('/completions/today', function(ServerRequestInterface $request, array $parameters) {
    $response = App::make('i want to see my completions for today', [
        App::make(Guard::class)->current($request->getHeaderLine('Authorization')),
    ]);

    list($status, $payload) = $response;
    return call_user_func_array(Status::match($status), $payload);
});