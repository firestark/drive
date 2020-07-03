<?php

class Quest implements JsonSerializable 
{
    private $title = ''; 
    private $description = '';
    private $category = '';
    private $timeEstimate = ''; 
    private $moreInfo = '';

    public function __construct(string $title, string $description, string $category, string $timeEstimate, string $moreInfo)
    {
        $this->title = $title;
        $this->description = $description;
        $this->category = $category;
        $this->timeEstimate = $timeEstimate;
        $this->moreInfo = $moreInfo;
    }

    public function __get(string $property)
    {
        if (isset($this->{$property}))
            return $this->{$property};
    }

    public function jsonSerialize(): array
    {
        return [
            'title'         => $this->title,
            'description'   => $this->description,
            'category'      => $this->category,
            'timeEstimate'  => $this->timeEstimate,
            'moreInfo'      => $this->moreInfo
        ];
    }
}