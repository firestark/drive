<?php

class Quest
{
    public $title = ''; 
    public $description = '';
    public $category = '';
    public $timeEstimate = ''; 
    public $moreInfo = '';

    public function __construct(string $title, string $description, string $category, string $timeEstimate, string $moreInfo)
    {
        $this->title = $title;
        $this->description = $description;
        $this->category = $category;
        $this->timeEstimate = $timeEstimate;
        $this->moreInfo = $moreInfo;
    }
}