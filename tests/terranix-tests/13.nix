{ config, ... }:

{
  resource.some_resource.name = { };

  data.some_data_resource.name = { };

  resource.other_resource.another_name = {
    field_with_resource_reference = config.resource.some_resource.name "referenced_attribute";
    field_with_data_reference = config.data.some_data_resource.name "another_attribute";
  };
}
