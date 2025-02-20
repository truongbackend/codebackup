<?php

namespace App\Mail;

use App\Models\TemaplateEmail;
use App\Models\Template;
use Illuminate\Bus\Queueable;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Queue\SerializesModels;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Contracts\Queue\ShouldQueue;

class StatusOrder extends Mailable
{
    use Queueable, SerializesModels;

    /**
     * Create a new message instance.
     *
     * @return void
     */
    public $order;
    public $customer;
    public $userUpdate;
    public $orderStatus;
    public function __construct($order,$customer,$userUpdate,$orderStatus)
    {
        $this->order = $order;
        $this->customer = $customer;
        $this->userUpdate = $userUpdate;
        $this->orderStatus = $orderStatus;
    }

    public function build(){
        $template = TemaplateEmail::find(4);
        if ($template) {
            $content = $template->content;
            $trang_thai = $this->orderStatus->name;
            $ma_don_hang = $this->order->output_code;
            $ten_nguoi = $this->userUpdate->display_name;
            $ghi_chu = $this->order->notes;
            $Link_Accept = "order.bividvietnam.com";
            $content = str_replace('{ma_don_hang}', $ma_don_hang, $content);
            $content = str_replace('{trang_thai}', $trang_thai, $content);
            $content = str_replace('{link_accept}', $Link_Accept, $content);
            $content = str_replace('{ghi_chu}', $ghi_chu, $content);
            $content = str_replace('{ten_nguoi}', $ten_nguoi, $content);
            return $this->html($content)
                ->subject('Đơn hàng đã được gửi');
        } else {
            return $this->text("Không có template");
        }
    }
}
