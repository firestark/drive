<?php

/**
 * These functions are mainly used inside the business logic
 * and provide a human readable api. This way we try to make
 * our code more understandable for non programmers.
 */


function when(string $feature, Closure $action)
{
	App::bind($feature, $action);
}

function then($a)
{
	return $a;
}

function apply($a)
{
	return $a;
}

function a($a)
{
	return $a;
}

function readable($a)
{
	return $a;
}
