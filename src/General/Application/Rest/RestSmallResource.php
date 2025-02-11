<?php

declare(strict_types=1);

namespace App\General\Application\Rest;

use App\General\Application\Rest\Interfaces\RestSmallResourceInterface;
use App\General\Application\Rest\Traits\RestResourceBaseMethods;

/**
 * Class RestSmallResource
 *
 * @package App\General
 */
abstract class RestSmallResource implements RestSmallResourceInterface
{
    use RestResourceBaseMethods;
}
