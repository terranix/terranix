{ config, ... }:

{
  variable.token = {
    sensitive = true;
  };

  variable.settings = { };

  module.network = {
    source = "./network";
  };

  resource.some_resource.name = { };

  provider.some_provider = {
    token = config.variable.token;
    interpolated = "prefix-${config.variable.token}";
  };

  resource.other_resource.another_name = {
    field_with_variable_attribute = config.variable.settings "region";
    field_with_module_output = config.module.network "subnet_id";
    field_with_whole_resource = toString config.resource.some_resource.name;
  };
}
