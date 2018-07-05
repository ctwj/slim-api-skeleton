<?php

/*
 * This file is part of the Slim API skeleton package
 *
 * Copyright (c) 2016-2017 Mika Tuupola
 *
 * Licensed under the MIT license:
 *   http://www.opensource.org/licenses/mit-license.php
 *
 * Project home:
 *   https://github.com/tuupola/slim-api-skeleton
 *
 */

date_default_timezone_set("UTC");
// error_reporting(E_ALL);
// ini_set("display_errors", 1);

// To help the built-in PHP dev server, check if the request was actually for
// something which should probably be served as a static file
if (PHP_SAPI === 'cli-server' && $_SERVER['SCRIPT_FILENAME'] !== __FILE__) {
    return false;
}

require __DIR__ . "/vendor/autoload.php";

$dotenv = new Dotenv\Dotenv(__DIR__);
$dotenv->load();

$app = new \Slim\App([
    "settings" => [
        "displayErrorDetails" => true,
        "addContentLengthHeader" => false,
    ]
]);

// Set up dependencies
require __DIR__ . "/config/dependencies.php";

require __DIR__ . "/config/handlers.php";

// Register middleware
require __DIR__ . "/config/middleware.php";

// Register routes
require __DIR__ . "/routes/index.php";
require __DIR__ . "/routes/token.php";
require __DIR__ . "/routes/todos.php";

// Run!
$app->run();
