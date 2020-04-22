Ticket xpress Integration

This gem uses the JSON format of the ticket xpress API.

To get the voucher details

`voucher_detail = TicketXpress.get_voucher_detail('voucher_code')`

To authorize the voucher

`authorize = TicketXpress.authorize_voucher('voucher_code', voucher_detail['data']['remaining_value'])`

To Capture the voucher

We can get the capture URL in the authorize response.

`capture = TicketXpress.capture_voucher('voucher_code', voucher_detail['data']['remaining_value'], /api/transactions/edr-xxxxxxxxxxxx/actions/capture, "Invoice_id", invoice_amount, "email address", "Phone number with +91")`

To refund the voucher

`refund = TicketXpress.refund_voucher('voucher_code', voucher_detail['data']['remaining_value'], "/api/transactions/edr-xxxxxxxxxxx/actions/refund")`
