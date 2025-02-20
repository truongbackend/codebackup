<?php

namespace App\Jobs;

use App\Models\User;
use Carbon\Carbon;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\Log; // Correct import

class CheckUserLoginStatus implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    /**
     * Create a new job instance.
     *
     * @return void
     */
    public function __construct()
    {
    
    }

    /**
     * Execute the job.
     *
     * @return void
     */
    public function handle()
    {
        Log::info('CheckUserLoginStatus job started.');
        $now = Carbon::now();
        $users = User::where('logined', '<', $now->subDay())
                     ->where('lock_status', 0) 
                     ->whereDoesntHave('roles', function ($query) {
                        $query->where('name', 'Admin'); 
                    })
                     ->get();
        foreach ($users as $user) {
            $user->update(['lock_status' => 1]);
            Log::info('Updated lock_status for user', ['user_id' => $user->id]);
        }
        Log::info('CheckUserLoginStatus job finished.');
    }
}
