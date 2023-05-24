{ lib, ... }:
{
  # should disapear
  resource.yolo = { };
  data.yolo = { };

  # should stay
  locals.yolo = { };
}
