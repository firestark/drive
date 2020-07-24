<?php

namespace Services;

use ArtDirector;
use ArtDirectorManager;
use Firebase\JWT\JWT;
use Psr\Http\Message\ServerRequestInterface as Request;

class Guard
{
    private $key = '3}?(G<f<4@&m3,SR';
    private $artDirectorManager = null;

    /**
     * @var $public
     * All the publicly accessible routes.
     */
    private $public = [
        'OPTIONS' => ['/authenticate'],
        'GET' => [],
        'POST' => ['/authenticate'],
        'PUT' => [],
        'PATCH' => [],
        'DELETE' => []
    ];

    public function __construct(ArtDirectorManager $artDirectorManager)
    {
        $this->artDirectorManager = $artDirectorManager;
    }

    /**
     * Check if the guard allows access to a given request.
     * @param string $request       The application feature request.
     * @param string $token         The token to access the application with. 
     */
    public function allows(Request $request, string $token): bool
    {
        if ($this->validate($token))
            return true;

        if ($request->getMethod() === 'OPTIONS')
            return true;

        if (in_array($request->getUri()->getPath(), $this->public[$request->getMethod()]))
            return true;
        
        return false;
    }

    public function authenticates(ArtDirector $artDirector): bool
    {
        return $this->artDirectorManager->identifies($artDirector);
    }

    /**
     * Generate and store a token for given art director.
     * @param Artdirector   The art director to generate a token from.
     * @return string       The generated token.
     */
    public function stamp(ArtDirector $artDirector): string
    {
        return JWT::encode(['artDirector' => $artDirector], $this->key);
    }

    private function validate(string $token): bool
    {
        try {
            JWT::decode($token, $this->key, array('HS256'));
            return true;
        } catch (\Exception $e) {
            return false;
        }
    }
}