import type { VercelRequest, VercelResponse } from '@vercel/node'
import { createClient } from '@supabase/supabase-js'

const supabaseUrl = process.env.VITE_SUPABASE_URL
const supabaseAnonKey = process.env.VITE_SUPABASE_ANON_KEY
const supabaseServiceKey = process.env.SUPABASE_SERVICE_ROLE_KEY

if (!supabaseUrl || !supabaseAnonKey) {
  throw new Error("Missing Supabase configuration. Please set VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY environment variables.")
}

const supabase = createClient(supabaseUrl, supabaseAnonKey)
// Only create admin client if service key is available
const supabaseAdmin = supabaseServiceKey ? createClient(supabaseUrl, supabaseServiceKey) : null

interface AppSettingsRequest {
  adminUserId: string
  action: 'get' | 'update'
  settings?: Record<string, string>
}

// Helper function to get setting descriptions
function getSettingDescription(key: string): string {
  const descriptions: Record<string, string> = {
    app_name: 'Application name displayed in the header and browser title',
    app_logo_url: 'URL to the application logo image',
    app_favicon_url: 'URL to the favicon file',
    app_description: 'Application description for meta tags and SEO'
  }
  return descriptions[key] || `Setting for ${key}`
}

export default async function handler(
  req: VercelRequest,
  res: VercelResponse
) {
  const allowedOrigin = process.env.VITE_APP_URL || 'http://localhost:8080';
  // Enable CORS for frontend
  res.setHeader('Access-Control-Allow-Credentials', 'true')
  res.setHeader('Access-Control-Allow-Origin', allowedOrigin)
  res.setHeader('Access-Control-Allow-Methods', 'GET,OPTIONS,PATCH,DELETE,POST,PUT')
  res.setHeader('Access-Control-Allow-Headers', 'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version')

  if (req.method === 'OPTIONS') {
    res.status(200).end()
    return
  }

  if (req.method === 'GET') {
    // Get public app settings (no auth required)
    try {
      const { data, error } = await supabase
        .from('app_settings')
        .select('setting_key, setting_value')
        .eq('is_public', true)

      if (error) {
        return res.status(500).json({ error: error.message })
      }

      // Convert to key-value object
      const settings: Record<string, string> = {}
      data?.forEach(item => {
        settings[item.setting_key] = item.setting_value || ''
      })

      return res.status(200).json({ success: true, settings })
    } catch (error) {
      console.error('Get app settings error:', error)
      return res.status(500).json({
        error: error instanceof Error ? error.message : 'Failed to get app settings'
      })
    }
  }

  if (req.method !== 'POST') {
    return res.status(405).json({ error: 'Method not allowed' })
  }

  try {
    const { adminUserId, action, settings } = req.body as AppSettingsRequest

    if (!adminUserId || !action) {
      return res.status(400).json({ error: 'Missing required fields: adminUserId and action' })
    }

    // Use service role key for admin checks to bypass RLS
    // If no service key, fall back to anon key (which won't work due to RLS)
    const adminClient = supabaseAdmin || supabase
    
    if (!supabaseAdmin) {
      console.warn('No service role key available - admin checks may fail due to RLS policies')
    }
    
    // Verify admin permissions
    const { data: roleData, error: roleError } = await adminClient
      .from('user_roles')
      .select('role, status')
      .eq('user_id', adminUserId)
      .single()

    if (roleError) {
      console.error('Admin check error:', roleError)
      return res.status(403).json({ error: 'Admin access required - database error' })
    }

    if (!roleData || roleData.role !== 'admin' || roleData.status !== 'active') {
      return res.status(403).json({ error: 'Admin access required - insufficient permissions' })
    }

    switch (action) {
      case 'get':
        // Get all app settings (admin access)
        const { data, error } = await adminClient
          .from('app_settings')
          .select('setting_key, setting_value, setting_type, description')
          .order('setting_key')

        if (error) {
          return res.status(500).json({ error: error.message })
        }

        const allSettings: Record<string, any> = {}
        data?.forEach(item => {
          allSettings[item.setting_key] = {
            value: item.setting_value || '',
            type: item.setting_type,
            description: item.description
          }
        })

        return res.status(200).json({ success: true, settings: allSettings })

      case 'update':
        if (!settings || Object.keys(settings).length === 0) {
          return res.status(400).json({ error: 'Settings object is required for update' })
        }

        // Update all settings using the admin client to bypass RLS
        const updatePromises = Object.entries(settings).map(async ([key, value]) => {
          // First, check if the setting exists
          const { data: existingData, error: checkError } = await adminClient
            .from('app_settings')
            .select('setting_key, setting_value')
            .eq('setting_key', key)
            .single()
          
          const updatePayload = { 
            setting_value: value,
            updated_at: new Date().toISOString(),
            updated_by: adminUserId
          }
          const { data: updateData, error, count } = await adminClient
            .from('app_settings')
            .update(updatePayload)
            .eq('setting_key', key)
            .select()

          if (error) {
            console.error(`Failed to update ${key}:`, error)
            throw new Error(`Failed to update ${key}: ${error.message}`)
          }
          
          // Verify the update
          const { data: verifyData, error: verifyError } = await adminClient
            .from('app_settings')
            .select('setting_value')
            .eq('setting_key', key)
            .single()
          
          return { key, success: verifyData?.setting_value === value }
        })

        const results = await Promise.all(updatePromises)

        return res.status(200).json({ success: true })

      default:
        return res.status(400).json({ error: 'Invalid action' })
    }
  } catch (error) {
    console.error('App settings API error:', error)
    return res.status(500).json({
      error: error instanceof Error ? error.message : 'Internal server error'
    })
  }
}