locals {
  lambda_zip_location = "outputs/welcome.zip"
}
#S3 Bucket
resource "random_pet" "lambda_bucket_name" {
  prefix = "my-case-bucket-lambda"
  length = 4
}
resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id
  acl           = "private"
  force_destroy = true
}

data "archive_file" "welcome" {
  type        = "zip"
  source_file = "welcome.py"
  output_path = local.lambda_zip_location
}

resource "aws_s3_bucket_object" "lambda_welcome" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "welcome.zip"
  source = data.archive_file.welcome.output_path

  etag = filemd5(data.archive_file.welcome.output_path)
}
#ApiGateway
resource "aws_api_gateway_rest_api" "api" {
  name = "myapi"
}

resource "aws_api_gateway_resource" "resource" {
  path_part   = "resource"
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.test_lambda.invoke_arn
}

# Lambda
resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.test_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn = "arn:aws:execute-api:${var.myregion}:${var.accountId}:${aws_api_gateway_rest_api.api.id}/*/${aws_api_gateway_method.method.http_method}${aws_api_gateway_resource.resource.path}"
}


resource "aws_lambda_function" "test_lambda" {
  filename      = local.lambda_zip_location
  function_name = "welcome"
  role          = aws_iam_role.lambda_role.arn
  handler       = "welcome.hello"
  source_code_hash = filebase64sha256(local.lambda_zip_location)
  runtime = "python3.7"
}