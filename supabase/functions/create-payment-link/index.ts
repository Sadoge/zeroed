// Supabase Edge Function: create-payment-link
// Generates a Stripe Payment Link for an invoice.
//
// Expects: { invoice_id, invoice_number, amount_cents, currency, client_name, client_email, description }
// Returns: { payment_link: string }

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import Stripe from 'https://esm.sh/stripe@13.6.0?target=deno'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const stripe = new Stripe(Deno.env.get('STRIPE_SECRET_KEY')!, {
  apiVersion: '2023-10-16',
  httpClient: Stripe.createFetchHttpClient(),
})

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req: Request) => {
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {
    // Verify the user is authenticated
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL')!,
      Deno.env.get('SUPABASE_ANON_KEY')!,
      { global: { headers: { Authorization: req.headers.get('Authorization')! } } },
    )
    const { data: { user }, error: authError } = await supabase.auth.getUser()
    if (authError || !user) {
      return new Response(JSON.stringify({ error: 'Unauthorized' }), {
        status: 401,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    // Get the user's Stripe account ID
    const { data: profile } = await supabase
      .from('profiles')
      .select('stripe_account_id')
      .eq('id', user.id)
      .single()

    if (!profile?.stripe_account_id) {
      return new Response(JSON.stringify({ error: 'Stripe not connected. Please connect Stripe in Settings.' }), {
        status: 400,
        headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      })
    }

    const { invoice_id, invoice_number, amount_cents, currency, client_name, client_email, description } = await req.json()

    // Create a Stripe Payment Link via the connected account
    const price = await stripe.prices.create({
      unit_amount: amount_cents,
      currency: currency || 'usd',
      product_data: { name: description || `Invoice ${invoice_number}` },
    }, { stripeAccount: profile.stripe_account_id })

    const paymentLink = await stripe.paymentLinks.create({
      line_items: [{ price: price.id, quantity: 1 }],
      metadata: { invoice_id, invoice_number, client_email },
      after_completion: {
        type: 'redirect',
        redirect: { url: `${Deno.env.get('APP_URL')}/payment-success?invoice=${invoice_id}` },
      },
    }, { stripeAccount: profile.stripe_account_id })

    // Store the payment link on the invoice
    await supabase
      .from('invoices')
      .update({ stripe_payment_link: paymentLink.url })
      .eq('id', invoice_id)

    return new Response(JSON.stringify({ payment_link: paymentLink.url }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  }
})
