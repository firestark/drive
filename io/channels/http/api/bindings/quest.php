<?php

App::bind(Quest::class, 

function(string $title, string $description, string $category, string $timeEstimate, string $moreInfo) {
    return new Quest(
        $title,
        $description,
        $category,
        $timeEstimate,
        $moreInfo
    );
});