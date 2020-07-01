<?php

use Psr\Http\Message\ResponseInterface;

Route::get('/', function(): ResponseInterface {
    $response = App::make('i want to see the quest list', [
        App::make(QuestManager::class)
    ]);

    list($status, $payload) = $response;
    return call_user_func_array(Status::match($status), $payload);
});