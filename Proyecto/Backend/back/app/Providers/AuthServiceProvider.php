<?php

namespace App\Providers;

use Illuminate\Foundation\Support\Providers\AuthServiceProvider as ServiceProvider;
use Illuminate\Support\Facades\Gate;

class AuthServiceProvider extends ServiceProvider
{
    /**
     * The policy mappings for the application.
     *
     * @var array<class-string, class-string>
     */
    protected $policies = [
        // 'App\Models\Model' => 'App\Policies\ModelPolicy',
    ];

    /**
     * Register any authentication / authorization services.
     */
    public function boot(): void
    {
        $this->registerPolicies();

        // Gates simples por rol
         Gate::define('manage-inventory', function ($user = null) {
            if (! $user) return false;
            return in_array($user->role, ['admin', 'gerente']);
        });
        Gate::define('manage-products', function ($user = null) {
            if (! $user) return false;
            return in_array($user->role, ['admin', 'gerente']);
        });
        Gate::define('view-reports', function ($user = null) {
            if (!$user) return false;
            // gerente y admin pueden ver reportes
            return in_array($user->role, ['gerente', 'admin']);
        });
    }
}
