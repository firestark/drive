<?php

namespace Firestark;

use Closure;

class Status
{
    private $codes = [];
    private $matched = 0;

    public function match($status): Closure
    {        
        if (! $this->matches($status))
            throw new \RuntimeException("The status code: {$status} has not been matched.");

        $this->matched = $status;
        return $this->codes[$status];
    }

    public function matching($status, Closure $callback)
    {        
        if ($this->matches($status))
            throw new \RuntimeException("The status code: {$status} has already been matched.");

        $this->codes[$status] = $callback;
    }

    public function matches($status): bool
    {
        return array_key_exists($status, $this->codes);
    }

    public function matched(): int 
    {
        return $this->matched;
    }
}
