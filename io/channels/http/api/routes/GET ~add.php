<?php

use Psr\Http\Message\ResponseInterface;

Route::post('/add', function(): ResponseInterface {
    $response = App::make('i want to add a quest', [
        App::make(Quest::class),
        App::make(QuestManager::class)
    ]);

    list($status, $payload) = $response;
    return call_user_func_array(Status::match($status), $payload);
});