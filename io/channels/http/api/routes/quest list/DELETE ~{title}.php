<?php

use Psr\Http\Message\ResponseInterface;

Route::delete('/{title}', function($request, array $parameters): ResponseInterface {
    list($status, $payload) = App::make('i want to remove a quest', [
        urldecode($parameters['title']),
        App::make(QuestManager::class)
    ]);

    return call_user_func_array(Status::match($status), $payload);
});