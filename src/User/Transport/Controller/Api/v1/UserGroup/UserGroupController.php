<?php

declare(strict_types=1);

namespace App\User\Transport\Controller\Api\v1\UserGroup;

use App\General\Transport\Rest\Controller;
use App\General\Transport\Rest\ResponseHandler;
use App\General\Transport\Rest\Traits\Actions;
use App\User\Application\DTO\UserGroup\UserGroupCreate;
use App\User\Application\DTO\UserGroup\UserGroupPatch;
use App\User\Application\DTO\UserGroup\UserGroupUpdate;
use App\User\Application\Resource\UserGroupResource;
use OpenApi\Annotations as OA;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\IsGranted;
use Symfony\Component\Routing\Annotation\Route;
use Symfony\Component\Security\Core\Authorization\Voter\AuthenticatedVoter;

/**
 * Class UserGroupController
 *
 * @OA\Tag(name="UserGroup Management")
 *
 * @package App\User
 *
 * @method UserGroupResource getResource()
 * @method ResponseHandler getResponseHandler()
 */
#[Route(
    path: '/v1/user_group',
)]
#[IsGranted(AuthenticatedVoter::IS_AUTHENTICATED_FULLY)]
class UserGroupController extends Controller
{
    use Actions\Admin\CountAction;
    use Actions\Admin\FindAction;
    use Actions\Admin\FindOneAction;
    use Actions\Admin\IdsAction;
    use Actions\Root\CreateAction;
    use Actions\Root\DeleteAction;
    use Actions\Root\PatchAction;
    use Actions\Root\UpdateAction;

    /**
     * @var array<string, string>
     */
    protected static array $dtoClasses = [
        Controller::METHOD_CREATE => UserGroupCreate::class,
        Controller::METHOD_UPDATE => UserGroupUpdate::class,
        Controller::METHOD_PATCH => UserGroupPatch::class,
    ];

    public function __construct(
        protected UserGroupResource $resource,
    ) {
    }
}
