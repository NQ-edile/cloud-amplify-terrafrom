resource "aws_amplify_app" "react_app" {
  name = "terraform-react-app"
  repository = "https://github.com/NQ-edile/cloud-amplify-terrafrom"

  access_token = "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"

  build_spec = <<-EOT
    version: 0.1
    frontend:
      phases:
        preBuild:
          commands:
            - npm install
        build:
          commands:
            - npm run build
      artifacts:
        baseDirectory: public
        files:
          - '**/*'
      cache:
        paths:
          - node_modules/**/*
  EOT

  custom_rule {
    source = "/<*>"
    status = "404"
    target = "/index.html"
  }

  environment_variables = {
    ENV = "test"
  }
}

resource "aws_amplify_branch" "main" {
    app_id = aws_amplify_app.react_app.id
    branch_name = "main"
}

output "default_domain" {
  description = "The amplify domain (non-custom)."
  value       = aws_amplify_app.react_app.default_domain
}