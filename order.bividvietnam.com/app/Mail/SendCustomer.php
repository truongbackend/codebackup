<?php
use App\Models\Template;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Queue\SerializesModels;

class SendCustomer extends Mailable
{
    use Queueable, SerializesModels;

    public $user;

    public function __construct($user)
    {
        $this->user = $user;
    }

    public function build()
    {
        $template = Template::find(2);

        if ($template) {
            $content = $template->content;
            $username = $this->user->username;
            $password = $this->user->password;
            $Link_Accept = "order.bividvietnam.com";
            $content = str_replace('{username}', $username, $content);
            $content = str_replace('{password}', $password, $content);
            $content = str_replace('{link_accept}', $Link_Accept, $content);

            return $this->html($content)
                ->subject('Đăng kí khách hàng');
        } else {
            return $this->text("Không có template");
        }
    }
}
