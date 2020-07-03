<?php

namespace Services;

use ArtDirector;
use ArtDirectorManager;
use Firebase\JWT\JWT;

class Guard
{
    private $key = '3}?(G<f<4@&m3,SR';
    private $artDirectorManager = null;

    public function __construct(ArtDirectorManager $artDirectorManager)
    {
        $this->artDirectorManager = $artDirectorManager;
    }

    public function validate(string $token): bool
    {
        try {
            JWT::decode($token, $this->key, array('HS256'));
            return true;
        } catch (\Exception $e) {
            return false;
        }
    }

    public function authenticates(ArtDirector $artDirector): bool
    {
        return $this->artDirectorManager->identifies($artDirector);
    }

    public function stamp(ArtDirector $artDirector): string
    {
        return JWT::encode(['artDirector' => $artDirector], $this->key);
    }
}