<?php

declare(strict_types=1);

namespace App\User\Transport\AutoMapper\UserGroup;

use App\General\Transport\AutoMapper\RestAutoMapperConfiguration;
use App\User\Application\DTO\UserGroup\UserGroupCreate;
use App\User\Application\DTO\UserGroup\UserGroupPatch;
use App\User\Application\DTO\UserGroup\UserGroupUpdate;

/**
 * Class AutoMapperConfiguration
 *
 * @package App\User
 */
class AutoMapperConfiguration extends RestAutoMapperConfiguration
{
    /**
     * Classes to use specified request mapper.
     *
     * @var array<int, class-string>
     */
    protected static array $requestMapperClasses = [
        UserGroupCreate::class,
        UserGroupUpdate::class,
        UserGroupPatch::class,
    ];

    public function __construct(
        protected readonly RequestMapper $requestMapper,
    ) {
    }
}
