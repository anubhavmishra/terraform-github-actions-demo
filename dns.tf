provider "cloudflare" {
  version   = "~> 2.0"
  email     = var.cloudflare_email
  api_token = var.cloudflare_api_token
}

resource "cloudflare_record" "root_www" {
  zone_id = var.cloudflare_zone_id
  name    = "www"
  value   = "www.${var.domain_example}.s3-website-us-west-2.amazonaws.com"
  type    = "CNAME"
  proxied = true
}


