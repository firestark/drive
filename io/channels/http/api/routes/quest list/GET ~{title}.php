<?php

Route::get('/{title}', function($request, array $parameters) {
    $title = urldecode($parameters['title']);
    return Response::ok(! App::make(QuestManager::class)->has($title));
});