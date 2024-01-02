# -----------------------------------------------------
# S3 Bucket
# -----------------------------------------------------
resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.domain_name
  tags   = var.tags
}

# -----------------------------------------------------
# S3 Bucket Policy
# -----------------------------------------------------
# data "aws_iam_policy_document" "s3_bucket_policy" {
#   statement {
#     actions = [
#       "s3:GetObject",
#     ]

#     resources = [
#       "arn:aws:s3:::${var.domain_name}/*",
#     ]

#     principals {
#       type = "AWS"

#       identifiers = [
#         aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn,
#       ]
#     }
#   }
# }

data "aws_iam_policy_document" "s3_bucket_policy" {
  depends_on = [ 
    aws_cloudfront_distribution.s3_distribution,
    aws_s3_bucket.s3_bucket]

    statement {
      sid = "s3_cloudfront_static_website"
      effect = "Allow"
      actions = ["s3:GetObject"]
      principals {
        identifiers = ["cloudfront.amazonaws.com"]
        type = "Service"
      }

      resources = [ "arn:aws:s3:::${aws_s3_bucket.s3_bucket.bucket}/*"]
      condition {
        test = "StringEquals"
        variable = "AWS:SourceArn"
        values = [aws_cloudfront_distribution.s3_distribution.arn]
      }
    }
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = data.aws_iam_policy_document.s3_bucket_policy.json
}

# -----------------------------------------------------
# S3 Bucket Website Configuration
# -----------------------------------------------------
resource "aws_s3_bucket_website_configuration" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "404.html"
  }
}

# -----------------------------------------------------
# Cloudfront Distribution
# -----------------------------------------------------
resource "aws_cloudfront_origin_access_control" "s3_distribution" {
  name = "security_pillar100_cf_s3_oac_2"
  origin_access_control_origin_type = "s3"
  signing_behavior = "always"
  signing_protocol = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  depends_on = [
    aws_s3_bucket.s3_bucket,
    aws_cloudfront_origin_access_control.s3_distribution
  ]

  origin {
    domain_name = aws_s3_bucket.s3_bucket.bucket_regional_domain_name
    origin_id   = "s3-cloudfront"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods = [
      "GET",
      "HEAD",
    ]

    cached_methods = [
      "GET",
      "HEAD",
    ]

    target_origin_id = "s3-cloudfront"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"

    min_ttl     = var.cloudfront_min_ttl
    default_ttl = var.cloudfront_default_ttl
    max_ttl     = var.cloudfront_max_ttl
  }

  price_class = var.price_class

  restrictions {
    geo_restriction {
      restriction_type = var.cloudfront_geo_restriction_restriction_type
      locations        = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  custom_error_response {
    error_code            = 403
    response_code         = 200
    error_caching_min_ttl = 0
    response_page_path    = "/index.html"
  }

  wait_for_deployment = false
  tags                = var.tags
}

# -----------------------------------------------------
# Cloudfront Origin Access Identity
# -----------------------------------------------------
resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "access-identity-${var.domain_name}.s3.amazonaws.com"
}