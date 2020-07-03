<?php

App::bind(ArtDirectorFromInput::class, function(): ArtDirector {
    return new ArtDirector(Input::get('name'), Input::get('password'));
});