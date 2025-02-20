<?php

namespace App\Mail;

use App\Models\Template;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Mail\Mailable;
use Illuminate\Mail\Mailables\Content;
use Illuminate\Mail\Mailables\Envelope;
use Illuminate\Queue\SerializesModels;

class DeleteOrder extends Mailable
{
    use Queueable, SerializesModels;

    /**
     * Create a new message instance.
     *
     * @return void
     */
    public $order;
    public $customer;
    public $products;
    public $userOrder;
    public $orderDetail;
    public $product_unit;
    public function __construct($order,$customer,$products,$userOrder,$orderDetail,$product_unit)
    {
        $this->order = $order;
        $this->customer = $customer;
        $this->products = $products;
        $this->userOrder = $userOrder;
        $this->orderDetail = $orderDetail;
        $this->product_unit =$product_unit;
    }
    public function build()
    {
        $template = Template::find(3);
        if ($template) {
            $content = $template->content;
            $Ma_Don_Hang = $this->order->output_code;
            $Tong_Tien_Hang =$this->order->total_price;
            $Khach_Hang = $this->customer->customer_name;
            $Ghi_Chu = $this->order->notes;
            $Chiet_Khau = $this->order->coupon;
            $DT_Khach_Hang = $this->customer->customer_phone;
            $DC_Khach_Hang =$this->customer->customer_addr;
            $Thu_Ngan = $this->userOrder->display_name;
            $Phone_User = $this->userOrder->phone;
            $Email_User = $this->userOrder->email;
            $products = $this->products;
            $product_unit = $this->product_unit;
            $date = date("H:i d/m/Y");
            $ProductOrder = '<table class="m_6124731000493369924td" cellspacing="0" cellpadding="6" style="width:100%;font-family:Helvetica Neue,Helvetica,Roboto,Arial,sans-serif;margin-bottom:40px;color:#636363;border:1px solid #e5e5e5" border="1">
            <thead>
                <tr>
                    <th class="m_6124731000493369924td" scope="col" style="text-align:left;color:#636363;border:1px solid #e5e5e5;padding:12px">STT</th>
                    <th class="m_6124731000493369924td" scope="col" style="text-align:left;color:#636363;border:1px solid #e5e5e5;padding:12px">Mã SP</th>
                    <th class="m_6124731000493369924td" scope="col" style="text-align:left;color:#636363;border:1px solid #e5e5e5;padding:12px">Tên sản phẩm</th>
                    <th class="m_6124731000493369924td" scope="col" style="text-align:left;color:#636363;border:1px solid #e5e5e5;padding:12px">Số Lượng</th>
                    <th class="m_6124731000493369924td" scope="col" style="text-align:left;color:#636363;border:1px solid #e5e5e5;padding:12px">DVT</th>
                    <th class="m_6124731000493369924td" scope="col" style="text-align:left;color:#636363;border:1px solid #e5e5e5;padding:12px">Đơn giá</th>
                    <th class="m_6124731000493369924td" scope="col" style="text-align:left;color:#636363;border:1px solid #e5e5e5;padding:12px">Thành tiền</th>
                    <!-- Add other table headers as needed -->
                </tr>
            </thead>
            <tbody>';
            foreach ($products as $index => $product) {
                if (($product)) {
                    $ProductOrder .= '<tr class="m_6124731000493369924order_item">
                    <td class="m_6124731000493369924td" style="text-align:left;vertical-align:middle;border:1px solid #eee;word-wrap:break-word;color:#636363;padding:12px">' . ($index +1) . '</td>
                        <td class="m_6124731000493369924td" style="text-align:left;vertical-align:middle;border:1px solid #eee;word-wrap:break-word;color:#636363;padding:12px">' . $product['maProduct'] . '</td>
                        <td class="m_6124731000493369924td" style="text-align:left;vertical-align:middle;border:1px solid #eee;word-wrap:break-word;color:#636363;padding:12px">' . $product['name'] . '</td>
                        <td class="m_6124731000493369924td" style="text-align:left;vertical-align:middle;border:1px solid #eee;word-wrap:break-word;color:#636363;padding:12px">' . $product['quantity'] . '</td>
                        <td class="m_6124731000493369924td" style="text-align:left;vertical-align:middle;border:1px solid #eee;word-wrap:break-word;color:#636363;padding:12px">' . $product_unit . '</td>
                        <td class="m_6124731000493369924td" style="text-align:left;vertical-align:middle;border:1px solid #eee;word-wrap:break-word;color:#636363;padding:12px">' . number_format($product['price'],0,2) . '</td>
                        <td class="m_6124731000493369924td" style="text-align:left;vertical-align:middle;border:1px solid #eee;word-wrap:break-word;color:#636363;padding:12px">' . number_format($product['quantity'] * $product['price'],0,2). '</td>
                    </tr>';
                } else {
                }
            }
            $ProductOrder .= '</tbody>
            </table>';
            $Link_Accept = "order.bividvietnam.com";
            $content = str_replace('{Ma_Don_Hang}', $Ma_Don_Hang, $content);
            $content = str_replace('{Khach_Hang}', $Khach_Hang, $content);
            $content = str_replace('{Tong_Tien_Hang}', $Tong_Tien_Hang, $content);
            $content = str_replace('{Ghi_Chu}', $Ghi_Chu, $content);
            $content = str_replace('{DT_Khach_Hang}', $DT_Khach_Hang, $content);
            $content = str_replace('{DC_Khach_Hang}', $DC_Khach_Hang, $content);
            $content = str_replace('{Thu_Ngan}', $Thu_Ngan, $content);
            $content = str_replace('{DT_Thu_Ngan}', $Phone_User, $content);
            $content = str_replace('{Email_Thu_Ngan}', $Email_User, $content);
            $content = str_replace('{Ngay_Xuat}', $date, $content);
            $content = str_replace('{link_accept}', $Link_Accept, $content);
            $content = str_replace('{Chiec_Khau}', $Chiet_Khau, $content);
            $content = str_replace('{Chi_Tiet_San_Pham}', $ProductOrder, $content);
            return $this->html($content)
                ->subject('Đơn hàng đã được gửi');
        } else {
            return with("Không có template");
        }
    }

}
