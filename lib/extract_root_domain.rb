# frozen_string_literal: true

def extract_root_domain(url)
  parts = url.split('.')

  # Ensure we have at least two parts (e.g., "example.com")
  return url if parts.length < 2

  # Handle common cases like ".co.uk" by checking if the last part is a known TLD length (two-character country code)
  tld_exceptions = %w[co uk com org net gov edu mil int biz info]
  if parts.length > 2 && tld_exceptions.include?(parts[-2])
    return parts[-3..].join('.') # e.g., "news.bbc.co.uk" → "bbc.co.uk"
  end

  # Default: Keep the last two parts (e.g., "starter.woorichurch.org" → "woorichurch.org")
  parts[-2..].join('.')
end
