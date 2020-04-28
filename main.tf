provider "aws" {
  region = "us-west-2"
}

resource "aws_s3_bucket" "website_www" {

  bucket = "www.${var.domain_example}"
  acl    = "public-read"
  policy = data.aws_iam_policy_document.bucket_policy.json

  website {
    index_document = "index.html"
    error_document = "error.html"
  }
}

resource "aws_s3_bucket" "website_subdomain" {

  bucket = var.domain_example
  acl    = "private"
  policy = ""

  website {
    redirect_all_requests_to = "https://www.${var.domain_example}"
  }
}

data "aws_iam_policy_document" "bucket_policy" {

  statement {
    sid = "AllowedIPReadAccess"

    actions = [
      "s3:GetObject",
    ]

    resources = [
      "arn:aws:s3:::www.${var.domain_example}/*",
    ]

    condition {
      test     = "IpAddress"
      variable = "aws:SourceIp"

      values = ["0.0.0.0/0"]
    }

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_object" "website_example" {
  key          = "index.html"
  bucket       = aws_s3_bucket.website_www.id
  source       = "index.html"
  content_type = "text/html"

  etag = filemd5("index.html")
}

resource "aws_s3_bucket_object" "website_error" {
  key          = "error.html"
  bucket       = aws_s3_bucket.website_www.id
  source       = "error.html"
  content_type = "text/html"

  etag = filemd5("error.html")
}
