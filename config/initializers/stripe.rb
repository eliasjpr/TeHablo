Stripe.api_key = "8bBKkcNBCy54hL7eAmFdgggacO9Rk0KX"
STRIPE_PUBLISHABLE_KEY = "pk_dVdyYALGEArWGRs27BXnFopJF152G"


StripeEvent.setup do
  subscribe 'transfer.failed', 'transfer.update', 'transfer.paid' do |event|
    transfer = event.data.object

    Receipt.update_all({transfer_status: transfer.status, transfer_fee: transfer.fee}, {transfer_id: transfer.id})

  end

end