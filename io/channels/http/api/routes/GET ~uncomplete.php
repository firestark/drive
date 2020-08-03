<?php

use Services\Guard;

Route::get('/uncomplete/{title}', function($request, array $parameters) {
    $response = App::make('i want to uncomplete a quest', [
        App::make(Guard::class)->current($request->getHeaderLine('Authorization')),
        App::make(ArtDirectorManager::class),
        App::make(QuestManager::class)->find(urldecode($parameters['title'])),
    ]);

    list($status, $payload) = $response;
    return call_user_func_array(Status::match($status), $payload);
});