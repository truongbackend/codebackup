<?php

namespace App\Mail;

use App\Http\Controllers\Admin\TemplateEmailController;
use App\Models\TemaplateEmail;
use App\Models\Template;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Queue\SerializesModels;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Contracts\Queue\ShouldQueue;

class SendUser extends Mailable
{
    use Queueable, SerializesModels;

    /**
     * Create a new message instance.
     *
     * @return void
     */
    public $user;
    public function __construct($user)
    {
        $this->user = $user;
    }

    /**
     * Get the message envelope.
     *
     * @return \Illuminate\Mail\Mailables\Envelope
     */
    public function build()
    {
        $template = TemaplateEmail::find(2);

        if ($template) {
            $content = $template->content;
            $username = $this->user->email;
            $password = "test123456";
            $Link_Accept = "order.bividvietnam.com";
            $content = str_replace('{username}', $username, $content);
            $content = str_replace('{password}', $password, $content);
            $content = str_replace('{link_accept}', $Link_Accept, $content);

            return $this->html($content)
                ->subject('Đơn hàng đã được gửi');
        } else {
            return $this->text("Không có template");
        }
    }
}
