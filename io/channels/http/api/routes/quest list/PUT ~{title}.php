<?php

use Psr\Http\Message\ResponseInterface;

Route::put('/{title}', function($request, array $parameters): ResponseInterface {
    list($status, $payload) = App::make('i want to change a quest', [
        urldecode($parameters['title']),
        app::make(Quest::class, Input::all()),
        App::make(QuestManager::class)
    ]);

    return call_user_func_array(Status::match($status), $payload);
});