<?php

namespace App\Jobs;

use Carbon\Carbon;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldBeUnique;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;

class SendReportJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    protected $sales;

    /**
     * Create a new job instance.
     *
     * @return void
     */
    public function __construct($sales)
    {
        $this->sales = $sales;
    }

    /**
     * Execute the job.
     *
     * @return void
     */
    public function handle()
    {
        $apiUrl = config('app.api_base_url');
        $currentMonth = Carbon::now()->month;
        $currentDay = Carbon::now()->day;
        $year = Carbon::now()->year;
    }
}
