<?php

App::bind(Quest::class, function() {
    return new Quest(
        'PBR introduction', 
        'A short introduction to PBR', 
        'Texturing', '3 - 5 min', 
        'PBR is a new improved workflow for texturing. Get to know PBR with this tutorial: https://www.youtube.com/watch?v=7NjGETJMZvY&t=85s'
    );
});