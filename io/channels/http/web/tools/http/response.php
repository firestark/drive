<?php

namespace Firestark\Http;

use Psr\Http\Message\ResponseInterface;
use Laminas\Diactoros\ResponseFactory;

class Response extends ResponseFactory
{
	protected $headers = [
        'Access-Control-Allow-Origin'       => '*',
		'Access-Control-Allow-Headers'      => 'Origin, Accept, Content-Type, Authorization, X-Requested-With, Content-Range, Content-Disposition',
		'X-Firestark-Status'				=> 0
    ];

	public function __construct(string $class)
	{
		$this->response = $class;
    }

    public function status(int $number)
	{
		$this->headers [ 'X-Firestark-Status' ] = $number;
	}

	function createResponse(int $code = 200, string $reasonPhrase = ''): ResponseInterface
    {
        $response = (new \Laminas\Diactoros\Response())
			->withStatus($code, $reasonPhrase);

		foreach($this->headers as $key => $value)
			$response = $response->withHeader($key, $value);

		return $response;
    }
	
	function ok($content): ResponseInterface
	{
		return $this->respond(200, $content);
	}

	function created($content): ResponseInterface
	{
		return $this->respond(201, $content);
	}

	function conflict($content): ResponseInterface
	{
		return $this->respond(409, $content);
	}

	function unauthorized($content = ''): ResponseInterface
	{
		return $this->respond(401, $content);
	}

	protected function respond(int $status, $content): ResponseInterface
	{
		$class = $this->response;
		return new $class($content, $status, $this->headers);
	}
}