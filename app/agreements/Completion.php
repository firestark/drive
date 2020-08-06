<?php

class Completion implements JsonSerializable
{
    private $title = '';
    private $completedAt = 0;

    public function __construct(string $title)
    {
        $this->title = $title;
        $this->completedAt = time();
    }

    public function isToday(): bool
    {
        $beginOfToday = strtotime('today', time());
        $endOfToday = strtotime('tomorrow', time()) -1;

        return $this->completedAt >= $beginOfToday && $this->completedAt <= $endOfToday;
    }

    public function jsonSerialize(): array
    {
        return [
            'title'         => $this->title,
            'completedAt'   => $this->completedAt,
        ];
    }
}