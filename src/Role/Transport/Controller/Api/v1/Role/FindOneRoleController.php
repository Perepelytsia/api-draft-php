<?php

declare(strict_types=1);

namespace App\Role\Transport\Controller\Api\v1\Role;

use App\General\Transport\Rest\Controller;
use App\General\Transport\Rest\Traits\Methods;
use App\Role\Application\Resource\RoleResource;
use App\Role\Domain\Entity\Role;
use Nelmio\ApiDocBundle\Annotation\Model;
use OpenApi\Annotations as OA;
use Sensio\Bundle\FrameworkExtraBundle\Configuration\IsGranted;
use Symfony\Component\HttpFoundation\Request;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\Routing\Annotation\Route;
use Throwable;

/**
 * Class FindOneRoleController
 *
 * @OA\Tag(name="Role Management")
 *
 * @package App\Role
 */
class FindOneRoleController extends Controller
{
    use Methods\FindOneMethod;

    public function __construct(
        protected RoleResource $resource,
    ) {
    }

    /**
     * Find role entity, accessible for 'ROLE_ADMIN' users.
     *
     * @OA\Response(
     *     response=200,
     *     description="success",
     *     @OA\JsonContent(
     *         example={"id": "ROLE_ROOT", "description": "role root description"},
     *         ref=@Model(
     *             type=Role::class,
     *             groups={"Role"},
     *         ),
     *     ),
     * )
     * @OA\Response(
     *     response=403,
     *     description="Access denied",
     *     @OA\JsonContent(
     *         type="object",
     *         example={"code": 403, "message": "Access denied"},
     *         @OA\Property(property="code", type="integer", description="Error code"),
     *         @OA\Property(property="message", type="string", description="Error description"),
     *     ),
     *  )
     *
     * @throws Throwable
     */
    #[Route(
        path: '/v1/role/{role}',
        requirements: [
            'role' => '^ROLE_\w+$',
        ],
        methods: [Request::METHOD_GET],
    )]
    #[IsGranted(Role::ROLE_ADMIN)]
    public function __invoke(Request $request, string $role): Response
    {
        return $this->findOneMethod($request, $role);
    }
}
