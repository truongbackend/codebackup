<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;

class RolesAndPermissionsSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        // Tạo vai trò
        $createPostPermission = Permission::firstOrCreate(['name' => 'create post']);
        $editPostPermission = Permission::firstOrCreate(['name' => 'edit post']);
        $adminRole = Role::firstOrCreate(['name' => 'admin', 'guard_name' => 'api']);
        $adminRole->givePermissionTo($createPostPermission, $editPostPermission);
        $editorRole = Role::firstOrCreate(['name' => 'editor', 'guard_name' => 'api']);
        $editorRole->givePermissionTo($createPostPermission);
        $adminUser = User::find(48);
        if ($adminUser) {
            $adminUser->assignRole('admin');
        }
        $editorUser = User::find(48);
        if ($editorUser) {
            $editorUser->assignRole('editor');
        }
    }
}
