// Supabase Edge Function: send-invoice-email
// Sends invoice or reminder emails via Resend (or any SMTP provider).
//
// Expects: { type, invoice_id, invoice_number, client_name, client_email, amount, currency, payment_link? }
// Returns: { success: true }

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const RESEND_API_KEY = Deno.env.get('RESEND_API_KEY')!
const FROM_EMAIL = Deno.env.get('FROM_EMAIL') || 'invoices@zeroed.app'

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

    // Get sender's business profile
    const { data: profile } = await supabase
      .from('profiles')
      .select('business_name, email')
      .eq('id', user.id)
      .single()

    const businessName = profile?.business_name || 'Your Business'
    const senderEmail = profile?.email || user.email

    const {
      type,
      invoice_number,
      client_name,
      client_email,
      amount,
      currency,
      payment_link,
    } = await req.json()

    const formattedAmount = new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: currency || 'USD',
    }).format(amount)

    const isReminder = type === 'reminder'

    const subject = isReminder
      ? `Reminder: Invoice ${invoice_number} — ${formattedAmount} due`
      : `Invoice ${invoice_number} from ${businessName}`

    const payButtonHtml = payment_link
      ? `<a href="${payment_link}" style="display:inline-block;background:#22D3EE;color:#0A0F1C;padding:12px 32px;border-radius:8px;text-decoration:none;font-weight:600;margin:24px 0;">Pay Now — ${formattedAmount}</a>`
      : ''

    const html = `
      <div style="font-family:Inter,system-ui,sans-serif;max-width:600px;margin:0 auto;padding:32px;color:#0F172A;">
        <h2 style="margin:0 0 4px;font-size:20px;font-weight:700;">${businessName}</h2>
        <p style="margin:0 0 24px;color:#64748B;font-size:13px;">${senderEmail}</p>

        ${isReminder ? '<p style="color:#EF4444;font-weight:600;">This is a friendly reminder that payment is overdue.</p>' : ''}

        <p>Hi ${client_name},</p>
        <p>${isReminder
          ? `Invoice <strong>${invoice_number}</strong> for <strong>${formattedAmount}</strong> is past due. Please arrange payment at your earliest convenience.`
          : `Please find attached invoice <strong>${invoice_number}</strong> for <strong>${formattedAmount}</strong>.`
        }</p>

        <div style="text-align:center;">
          ${payButtonHtml}
        </div>

        <hr style="border:none;border-top:1px solid #E2E8F0;margin:24px 0;" />
        <p style="color:#94A3B8;font-size:11px;text-align:center;">
          Payment due within 30 days. Late payments subject to 1.5% monthly interest.
        </p>
      </div>
    `

    // Send via Resend
    const emailResponse = await fetch('https://api.resend.com/emails', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${RESEND_API_KEY}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        from: `${businessName} <${FROM_EMAIL}>`,
        to: [client_email],
        subject,
        html,
      }),
    })

    if (!emailResponse.ok) {
      const err = await emailResponse.text()
      throw new Error(`Email send failed: ${err}`)
    }

    return new Response(JSON.stringify({ success: true }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  } catch (err) {
    return new Response(JSON.stringify({ error: err.message }), {
      status: 500,
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
    })
  }
})
