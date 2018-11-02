resource "alicloud_api_gateway_group" "apiGatewayGroup" {
  name        = "${var.apigateway_group_name}"
  description = "${var.apigateway_group_description}"
}

data "alicloud_api_gateway_groups" "data_apigatway_groups" {
  name_regex  = "${alicloud_api_gateway_group.apiGatewayGroup.name}"
  output_file = "output_ApiGatawayGroups"
}

resource "alicloud_api_gateway_api" "apiGatewayApi" {
  name        = "terraformapi"
  group_id    = "${alicloud_api_gateway_group.apiGatewayGroup.id}"
  description = "description"
  auth_type   = "APP"

  request_config = {
    protocol = "HTTP"
    method   = "GET"
    path     = "/test/path"
    mode     = "MAPPING"
  }

  service_type = "HTTP"

  http_service_config = {
    address   = "http://apigateway-backend.alicloudapi.com:8080"
    method    = "GET"
    path      = "/web/cloudapi"
    timeout   = 22
    aone_name = "cloudapi-openapi"
  }

  request_parameters = [
    {
      name         = "aa"
      type         = "STRING"
      required     = "OPTIONAL"
      in           = "QUERY"
      in_service   = "QUERY"
      name_service = "testparams"
    },
    {
      name         = "bbbbbbb"
      type         = "STRING"
      required     = "OPTIONAL"
      in           = "QUERY"
      in_service   = "QUERY"
      name_service = "bbbb"
    },
  ]
}

resource "alicloud_api_gateway_app" "appTest" {
  name        = "${var.apigateway_app_name_test}"
  description = "${var.apigateway_app_description_test}"
}
