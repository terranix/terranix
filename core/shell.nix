{ pkgs ?  import <nixpkgs> {} }:

# nix-shell script to parse provider APIs

let

  # folder where everything takes place
  moduleFolder = toString ./provider-modules;

  crawlerPart = path: modul: input: /* sh */ ''
    URL="${input.url}"
    file_name_html=${"$"}{URL##https://*/}
    file_name=`basename $file_name_html .html`
    ${pkgs.curl}/bin/curl --silent \
      ${input.url} \
      | ${pkgs.pup}/bin/pup \
        "${input.pupArgs} json{}" \
      | jq '.[] | {
modul: "${modul}", name: "'$file_name'", url : "${input.url}",
type : "${input.type}", "arguments" : ${input.jqArgs} }' \
      | jq '.' \
      | tee ${path}/${input.type}_$file_name.json
      sleep 4
  '';

  crawler = path: suffix: files:
    let
      commands = builtins.map (crawlerPart path suffix) files;
    in
      pkgs.writeShellScriptBin "crawl-${suffix}" /* sh */ ''
        mkdir -p ${path}
        rm ${path}/*.json
        ${pkgs.lib.concatStringsSep "\n" commands}
      '';

  pup_1 = "#argument-reference + p + ul";
  pup_2 = "#argument-reference + ul";

  r = "resource";
  d = "data";

  jq_1 = ''[ .children[] | { key: "\( .children[0].name )", description: .text , type : "nullOr string", default : "null" } ]'';
  jq_z = ''{ "test": . }'';
  jq_a = jq_z;


  crawlerAws =
    crawler "${moduleFolder}/aws" "aws" [
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/acm_certificate.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/acm_certificate_validation.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/acmpca_certificate_authority.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ami.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ami_copy.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ami_from_instance.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ami_launch_permission.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/api_gateway_account.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/api_gateway_api_key.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/api_gateway_authorizer.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/api_gateway_base_path_mapping.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/api_gateway_client_certificate.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/api_gateway_deployment.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/api_gateway_documentation_part.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/api_gateway_documentation_version.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/api_gateway_domain_name.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/api_gateway_gateway_response";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/api_gateway_integration.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/api_gateway_integration_response.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/api_gateway_method.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/api_gateway_method_response.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/api_gateway_method_settings.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/api_gateway_model.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/api_gateway_request_validator.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/api_gateway_resource.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/api_gateway_rest_api.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/api_gateway_stage.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/api_gateway_usage_plan.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/api_gateway_usage_plan_key.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/api_gateway_vpc_link.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/app_cookie_stickiness_policy.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/appautoscaling_policy.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/appautoscaling_scheduled_action.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/appautoscaling_target.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/appmesh_mesh.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/appmesh_virtual_node.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/appmesh_virtual_router.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/appsync_api_key.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/appsync_datasource.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/appsync_graphql_api.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/athena_database.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/athena_named_query.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/autoscaling_attachment.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/autoscaling_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/autoscaling_lifecycle_hooks.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/autoscaling_notification.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/autoscaling_policy.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/autoscaling_schedule.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/batch_compute_environment.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/batch_job_definition.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/batch_job_queue.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/budgets_budget.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cloud9_environment_ec2.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cloudformation_stack.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cloudfront_distribution.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cloudfront_origin_access_identity.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cloudfront_public_key.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cloudhsm_v2_cluster.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cloudhsm_v2_hsm.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cloudtrail.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cloudwatch_dashboard.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cloudwatch_event_permission.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cloudwatch_event_rule.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cloudwatch_event_target.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cloudwatch_log_destination.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cloudwatch_log_destination_policy.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cloudwatch_log_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cloudwatch_log_metric_filter.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cloudwatch_log_resource_policy.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cloudwatch_log_stream.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cloudwatch_log_subscription_filter.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cloudwatch_metric_alarm.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/codebuild_project.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/codebuild_webhook.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/codecommit_repository.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/codecommit_trigger.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/codedeploy_app.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/codedeploy_deployment_config.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/codedeploy_deployment_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/codepipeline";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/codepipeline_webhook";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cognito_identity_pool";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cognito_identity_pool_roles_attachment";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cognito_identity_provider.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cognito_resource_server";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cognito_user_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cognito_user_pool";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cognito_user_pool_client";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/cognito_user_pool_domain";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/config_aggregate_authorization";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/config_config_rule.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/config_configuration_aggregator.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/config_configuration_recorder.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/config_configuration_recorder_status.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/config_delivery_channel.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/customer_gateway.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/datasync_agent.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/datasync_location_efs.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/datasync_location_nfs.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/datasync_location_s3.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/datasync_task.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/dax_cluster.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/dax_parameter_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/dax_subnet_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/db_cluster_snapshot.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/db_event_subscription.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/db_instance.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/db_option_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/db_parameter_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/db_security_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/db_snapshot.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/db_subnet_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/default_network_acl.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/default_route_table.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/default_security_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/default_subnet.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/default_vpc.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/default_vpc_dhcp_options.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/devicefarm_project.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/directory_service_conditional_forwarder.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/directory_service_directory.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/dlm_lifecycle_policy";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/dms_certificate.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/dms_endpoint.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/dms_replication_instance.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/dms_replication_subnet_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/dms_replication_task.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/dx_bgp_peer.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/dx_connection.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/dx_connection_association.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/dx_gateway.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/dx_gateway_association.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/dx_hosted_private_virtual_interface.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/dx_hosted_private_virtual_interface_accepter.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/dx_hosted_public_virtual_interface.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/dx_hosted_public_virtual_interface_accepter.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/dx_lag.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/dx_private_virtual_interface.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/dx_public_virtual_interface.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/dynamodb_global_table.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/dynamodb_table.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/dynamodb_table_item.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ebs_snapshot.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ebs_snapshot_copy.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ebs_volume.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ec2_capacity_reservation";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ec2_fleet.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ec2_transit_gateway.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ec2_transit_gateway_route.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ec2_transit_gateway_route_table.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ec2_transit_gateway_route_table_association.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ec2_transit_gateway_route_table_propagation.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ec2_transit_gateway_vpc_attachment.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ecr_lifecycle_policy.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ecr_repository.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ecr_repository_policy.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ecs_cluster.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ecs_service.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ecs_task_definition.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/efs_file_system.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/efs_mount_target.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/egress_only_internet_gateway.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/eip.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/eip_association.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/eks_cluster.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/elastic_beanstalk_application.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/elastic_beanstalk_application_version.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/elastic_beanstalk_configuration_template.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/elastic_beanstalk_environment.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/elastic_transcoder_pipeline.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/elastic_transcoder_preset.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/elasticache_cluster.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/elasticache_parameter_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/elasticache_replication_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/elasticache_security_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/elasticache_subnet_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/elasticsearch_domain.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/elasticsearch_domain_policy.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/elb.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/elb_attachment.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/emr_cluster.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/emr_instance_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/emr_security_configuration.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/flow_log.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/gamelift_alias.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/gamelift_build.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/gamelift_fleet.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/gamelift_game_session_queue.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/glacier_vault.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/glacier_vault_lock.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/glue_catalog_database.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/glue_catalog_table.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/glue_classifier.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/glue_connection.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/glue_crawler.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/glue_job.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/glue_security_configuration.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/glue_trigger.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/guardduty_detector.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/guardduty_ipset.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/guardduty_member.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/guardduty_threatintelset.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iam_access_key.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iam_account_alias.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iam_account_password_policy.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iam_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iam_group_membership.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iam_group_policy.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iam_group_policy_attachment";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iam_instance_profile.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iam_openid_connect_provider.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iam_policy.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iam_policy_attachment.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iam_role.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iam_role_policy.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iam_role_policy_attachment";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iam_saml_provider.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iam_server_certificate.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iam_service_linked_role.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iam_user.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iam_user_group_membership.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iam_user_login_profile.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iam_user_policy.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iam_user_policy_attachment";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iam_user_ssh_key.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/inspector_assessment_target.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/inspector_assessment_template.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/inspector_resource_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/instance.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/internet_gateway.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iot_certificate.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iot_policy.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iot_policy_attachment.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iot_thing.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iot_thing_principal_attachment.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iot_thing_type.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/iot_topic_rule.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/key_pair.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/kinesis_analytics_application.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/kinesis_firehose_delivery_stream.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/kinesis_stream.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/kms_alias.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/kms_grant.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/kms_key.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/lambda_alias.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/lambda_event_source_mapping.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/lambda_function.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/lambda_permission.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/launch_configuration.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/launch_template.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/lb.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/lb_cookie_stickiness_policy.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/lb_listener.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/lb_listener_certificate.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/lb_listener_rule.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/lb_ssl_negotiation_policy.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/lb_target_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/lb_target_group_attachment.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/lightsail_domain.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/lightsail_instance.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/lightsail_key_pair.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/lightsail_static_ip.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/lightsail_static_ip_attachment.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/load_balancer_backend_server_policy.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/load_balancer_listener_policy.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/load_balancer_policy.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/macie_member_account_association.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/macie_s3_bucket_association.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/main_route_table_assoc.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/media_store_container.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/media_store_container_policy.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/mq_broker.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/mq_configuration.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/nat_gateway.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/neptune_cluster.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/neptune_cluster_instance.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/neptune_cluster_parameter_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/neptune_cluster_snapshot.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/neptune_event_subscription.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/neptune_parameter_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/neptune_subnet_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/network_acl.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/network_acl_rule.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/network_interface";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/network_interface_attachment.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/network_interface_sg_attachment.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/opsworks_application.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/opsworks_custom_layer.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/opsworks_ganglia_layer.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/opsworks_haproxy_layer.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/opsworks_instance.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/opsworks_java_app_layer.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/opsworks_memcached_layer.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/opsworks_mysql_layer.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/opsworks_nodejs_app_layer.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/opsworks_permission.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/opsworks_php_app_layer.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/opsworks_rails_app_layer.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/opsworks_rds_db_instance.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/opsworks_stack.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/opsworks_static_web_layer.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/opsworks_user_profile.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/organizations_account.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/organizations_organization.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/organizations_policy.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/organizations_policy_attachment.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/pinpoint_adm_channel";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/pinpoint_apns_channel";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/pinpoint_apns_sandbox_channel";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/pinpoint_apns_voip_channel";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/pinpoint_apns_voip_sandbox_channel";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/pinpoint_app";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/pinpoint_baidu_channel";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/pinpoint_email_channel";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/pinpoint_event_stream";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/pinpoint_gcm_channel";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/pinpoint_sms_channel";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/placement_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/proxy_protocol_policy.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/rds_cluster.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/rds_cluster_endpoint.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/rds_cluster_instance.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/rds_cluster_parameter_group";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/redshift_cluster.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/redshift_event_subscription.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/redshift_parameter_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/redshift_security_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/redshift_snapshot_copy_grant.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/redshift_subnet_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/route.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/route53_delegation_set.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/route53_health_check.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/route53_query_log.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/route53_record.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/route53_zone.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/route53_zone_association.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/route_table.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/route_table_association.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/s3_bucket.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/s3_bucket_inventory.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/s3_bucket_metric.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/s3_bucket_notification.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/s3_bucket_object.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/s3_bucket_policy.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/secretsmanager_secret.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/secretsmanager_secret_version.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/security_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/security_group_rule.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/service_discovery_private_dns_namespace.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/service_discovery_public_dns_namespace.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/service_discovery_service.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/servicecatalog_portfolio.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ses_active_receipt_rule_set.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ses_configuration_set";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ses_domain_dkim.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ses_domain_identity.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ses_domain_identity_verification.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ses_domain_mail_from.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ses_event_destination";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ses_identity_notification_topic";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ses_receipt_filter.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ses_receipt_rule.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ses_receipt_rule_set.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ses_template.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/sfn_activity.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/sfn_state_machine.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/simpledb_domain.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/snapshot_create_volume_permission.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/sns_platform_application.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/sns_sms_preferences.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/sns_topic.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/sns_topic_policy.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/sns_topic_subscription.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/spot_datafeed_subscription.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/spot_fleet_request.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/spot_instance_request.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/sqs_queue.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/sqs_queue_policy.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ssm_activation.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ssm_association.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ssm_document.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ssm_maintenance_window.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ssm_maintenance_window_target.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ssm_maintenance_window_task.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ssm_parameter.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ssm_patch_baseline.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ssm_patch_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/ssm_resource_data_sync.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/storagegateway_cache.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/storagegateway_cached_iscsi_volume.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/storagegateway_gateway.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/storagegateway_nfs_file_share.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/storagegateway_smb_file_share.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/storagegateway_upload_buffer.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/storagegateway_working_storage.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/subnet.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/swf_domain.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/volume_attachment.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/vpc.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/vpc_dhcp_options.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/vpc_dhcp_options_association.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/vpc_endpoint.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/vpc_endpoint_connection_notification.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/vpc_endpoint_route_table_association.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/vpc_endpoint_service.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/vpc_endpoint_service_allowed_principal.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/vpc_endpoint_subnet_association.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/vpc_ipv4_cidr_block_association.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/vpc_peering.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/vpc_peering_accepter.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/vpc_peering_options.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/vpn_connection.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/vpn_connection_route.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/vpn_gateway.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/vpn_gateway_attachment.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/vpn_gateway_route_propagation.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/waf_byte_match_set.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/waf_geo_match_set.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/waf_ipset.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/waf_rate_based_rule.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/waf_regex_match_set.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/waf_regex_pattern_set.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/waf_rule.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/waf_rule_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/waf_size_constraint_set.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/waf_sql_injection_match_set.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/waf_web_acl.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/waf_xss_match_set.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/wafregional_byte_match_set.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/wafregional_geo_match_set.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/wafregional_ipset.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/wafregional_rate_based_rule.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/wafregional_regex_match_set.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/wafregional_regex_pattern_set.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/wafregional_rule.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/wafregional_rule_group.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/wafregional_size_constraint_set.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/wafregional_sql_injection_match_set.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/wafregional_web_acl.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/wafregional_web_acl_association.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/r/wafregional_xss_match_set.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/acm_certificate.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/acmpca_certificate_authority.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/ami.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/ami_ids.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/api_gateway_api_key.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/api_gateway_resource.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/api_gateway_rest_api.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/api_gateway_vpc_link.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/arn.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/autoscaling_groups.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/availability_zone.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/availability_zones.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/batch_compute_environment.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/batch_job_queue.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/billing_service_account.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/caller_identity.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/canonical_user_id.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/cloudformation_export.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/cloudformation_stack.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/cloudhsm_v2_cluster.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/cloudtrail_service_account.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/cloudwatch_log_group.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/codecommit_repository.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/cognito_user_pools";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/db_cluster_snapshot.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/db_event_categories.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/db_instance.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/db_snapshot.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/dx_gateway.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/dynamodb_table.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/ebs_snapshot.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/ebs_snapshot_ids.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/ebs_volume.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/ec2_transit_gateway.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/ec2_transit_gateway_route_table.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/ec2_transit_gateway_vpc_attachment.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/ecr_repository.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/ecs_cluster.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/ecs_container_definition.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/ecs_service.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/ecs_task_definition.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/efs_file_system.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/efs_mount_target.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/eip.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/eks_cluster.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/elastic_beanstalk_hosted_zone.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/elastic_beanstalk_solution_stack.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/elasticache_cluster.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/elasticache_replication_group.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/elb.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/elb_hosted_zone_id.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/elb_service_account.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/glue_script.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/iam_account_alias.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/iam_group.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/iam_instance_profile.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/iam_policy.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/iam_policy_document.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/iam_role.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/iam_server_certificate.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/iam_user.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/inspector_rules_packages.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/instance.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/instances.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/internet_gateway.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/iot_endpoint.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/ip_ranges.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/kinesis_stream.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/kms_alias.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/kms_ciphertext.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/kms_key.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/kms_secret.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/kms_secrets.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/lambda_function.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/lambda_invocation.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/launch_configuration.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/launch_template.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/lb.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/lb_listener.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/lb_target_group.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/mq_broker.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/nat_gateway.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/network_acls.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/network_interface.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/network_interfaces.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/partition.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/prefix_list.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/pricing_product.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/rds_cluster.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/redshift_cluster.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/redshift_service_account.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/region.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/route.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/route53_delegation_set.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/route53_zone.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/route_table.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/route_tables.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/s3_bucket.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/s3_bucket_object.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/secretsmanager_secret.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/secretsmanager_secret_version.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/security_group.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/security_groups.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/sns_topic.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/sqs_queue.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/ssm_document.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/ssm_parameter.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/storagegateway_local_disk.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/subnet.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/subnet_ids.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/vpc.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/vpc_dhcp_options.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/vpc_endpoint.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/vpc_endpoint_service.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/vpc_peering_connection.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/vpcs.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/vpn_gateway.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/workspaces_bundle.html";}
      ];

  crawlerTerraform=
    crawler "${moduleFolder}/terraform" "terraform" [
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/terraform/d/remote_state.html";}
      ];



  crawlerGithub=
    crawler "${moduleFolder}/github" "github" [
#{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/github/d/ip_ranges.html";}
{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/github/d/repositories.html";}
{ type = d; pupArgs = pup_2; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/github/d/repository.html";}
#{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/github/d/team.html";}
#{ type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/github/d/user.html";}

{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/github/r/branch_protection.html";}
{ type = r; pupArgs = pup_2; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/github/r/issue_label.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/github/r/membership.html";}
{ type = r; pupArgs = pup_2; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/github/r/organization_project.html";}
{ type = r; pupArgs = pup_2; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/github/r/organization_webhook.html";}
{ type = r; pupArgs = pup_2; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/github/r/project_column.html";}
{ type = r; pupArgs = pup_2; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/github/r/repository.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/github/r/repository_collaborator.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/github/r/repository_deploy_key.html";}
{ type = r; pupArgs = pup_2; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/github/r/repository_project.html";}
{ type = r; pupArgs = pup_2; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/github/r/repository_webhook.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/github/r/team.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/github/r/team_membership.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/github/r/team_repository.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/github/r/user_gpg_key.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/github/r/user_invitation_accepter.html";}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/github/r/user_ssh_key.html";}
      ];

  crawlerHcloud =
    crawler "${moduleFolder}/hcloud" "hcloud" [
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/hcloud/r/server.html" ;}
{ type = r; pupArgs = pup_2; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/hcloud/r/volume.html" ;}
{ type = r; pupArgs = pup_2; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/hcloud/r/volume_attachment.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/hcloud/r/ssh_key.html" ;}
{ type = r; pupArgs = pup_2; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/hcloud/r/floating_ip.html" ;}
{ type = r; pupArgs = pup_2; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/hcloud/r/floating_ip_assignment.html" ;}
{ type = r; pupArgs = pup_2; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/hcloud/r/rdns.html" ;}
{ type = d; pupArgs = pup_2; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/hcloud/d/floating_ip.html" ;}
{ type = d; pupArgs = pup_2; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/hcloud/d/image.html" ;}
{ type = d; pupArgs = pup_2; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/hcloud/d/ssh_key.html" ;}
{ type = d; pupArgs = pup_2; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/hcloud/d/volume.html" ;}
      ];

  crawlerCloudflare =
    crawler "${moduleFolder}/cloudflare" "cloudflare" [
# { type = d; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/d/ip_ranges.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/access_application.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/access_policy.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/access_rule.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/account_member.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/custom_pages.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/filter.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/firewall_rule.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/load_balancer.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/load_balancer_monitor.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/load_balancer_pool.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/page_rule.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/rate_limit.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/record.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/waf_rule.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/worker_route.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/worker_script.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/zone.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/zone_lockdown.html" ;}
{ type = r; pupArgs = pup_1; jqArgs = jq_1; url = "https://www.terraform.io/docs/providers/cloudflare/r/zone_settings_override.html" ;}
      ];

# todo sanitize the descriptions

  moduleCreator =
  let
    defaultNix = "${moduleFolder}/default.nix";
    createDefaultNix = /* sh */ ''
cat > ${defaultNix} <<EOF
{ config, lib, ... }:
{ imports = [

EOF
for nix_file in `find ${moduleFolder} -mindepth 2 -maxdepth 2 -type f | grep -e "nix\$"`
do
  echo ./`echo $nix_file | xargs dirname | xargs basename `/`basename $nix_file` >> ${defaultNix}
done
cat >> ${defaultNix} <<EOF

];}
EOF
    '';

    createNixModules = /* sh */ ''
      for file in `find ${moduleFolder} -mindepth 2 -maxdepth 2 -type f | grep -e "json\$"`
      do
      output_file=`dirname $file`/`basename $file .json`.nix
      cat $file | jq --raw-output '. | "
      # automatically generated, you should change \(.type)_\(.name).json instead
      # documentation : \(.url)
      { config, lib, ... }:
      with lib;
      with types;
      {
        options.\(.modul).\(.type).\(.name) = mkOption {
          default = {};
          description = \"\";
          type = with types; attrsOf ( submodule ( { name, ... }: {
            options = {
            # internal object that should not be overwritten.
            # used to generate references
            \"_ref\" = mkOption {
              type = with types; string;
              default = \"\( if .type == "data" then "data." else "" end )\( .modul )_\( .name ).${"$"}{name}\";
              description = \"\";
            };

            # automatically generated
            extraConfig = mkOption {
              type = nullOr attrs;
              default = {};
              example = { provider = \"aws.route53\"; };
              description = \"use this option to add options not coverd by this module\";
            };

      \( .arguments | map(
      "      # automatically generated, change the json file instead
            \( .key ) = mkOption {
              type = \(.type);
              \( if .default != null then "default = \(.default);" else "" end )
              description = \"\( .description )\";
            };"
      ) | join("\n") )
          }; }));
        };

        config =
          let
            result = flip mapAttrs
              config.\(.modul).\(.type).\(.name)
                (key: value:
                let
                  filteredValues = filterAttrs (key: _: key != \"extraConfig\") value;
                  extraConfig = value.extraConfig;
                in
                  filteredValues // extraConfig);
          in
            mkIf ( config.\(.modul).enable && length (builtins.attrNames result) != 0 ) {
              \(.type).\(.modul)_\(.name) = result;
            };
      }
      "' > $output_file
      done
      '';
  in
    pkgs.writeShellScriptBin "render-modules" /* sh */ ''
      ${createNixModules}
      ${createDefaultNix}
    '';

  createManpages =
  let
    markdownFile = toString ./manpage.md;
    manpage = toString ./manpage.man.1;
  in
    pkgs.writeShellScriptBin "render-manpages" /* sh */ ''
      cat > ${markdownFile} <<EOF
      # DESCRIPTION

      These are all supported terraform providers (for now).
      The type might not be correct, this is because parsing the types is
      very difficult at the moment and must be done semi automatic.

      You can always create a resource like this

      \`\`\`
      resource."<provider_module>"."<name>" = {
        key = value;
      };
      \`\`\`

      this is equivalent to HCL syntax for

      \`\`\`
      resource "<provider_module>" "<name>" {
        key = value
      }
      \`\`\`

      # OPTIONS
      EOF
      for file in `find ${moduleFolder} -mindepth 2 -maxdepth 2 -type f | grep -e "json\$"`
      do
        cat $file | jq --raw-output '"
      ## \(.module).\(.type).\(.name)

      Module definition for equivalent HCL commands of

      ```
      \(.type) \"\(.modul)_\(.name)\" \"name\" {}
      ```

      Documentation : \(.url)

      \( . as $main | [ $main.arguments[] |
        "
      ## \( $main.modul ).\( $main.type ).\( $main.name ).\"\\<name\\>\".\( .key )

      *Type*

      \( .type )

      \( if .default != null then "
      *Default*

      \( .default )" else "" end )

      *Description*

      \( .description )

      "] | join ("\n")
      )

      ## \( .modul ).\( .type ).\( .name ).\"\\<name\\>\".extraConfig

      *Type*

      attrs

      *Default*

      {}

      *Example*

      { provider = \"aws.route53_profile\"; }

      *Description*

      Use this option to add parameters the module has not defined, or if you want to force overwrite something that is defined wrong.

      "' >> ${markdownFile}
      done

      cat <( echo "% TerraNix" && \
        echo "% Ingolf Wagner" && \
        echo "% $( date +%Y-%m-%d )" && \
        cat ${markdownFile} ) \
        | ${pkgs.pandoc}/bin/pandoc - -s -t man \
        > ${manpage}
      rm ${markdownFile}
    '';

in pkgs.mkShell {

  # needed pkgs
  # -----------
  buildInputs = with pkgs; [
    pup
    pandoc
    jq
    crawlerHcloud
    crawlerCloudflare
    crawlerAws
    crawlerGithub
    crawlerTerraform
    moduleCreator
    createManpages
  ];

  # run this on start
  # -----------------
  shellHook = ''

  HISTFILE=${toString ./.}/.history

  '';
}
