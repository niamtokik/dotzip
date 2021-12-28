defmodule Dotzip.Extensions do

  @moduledoc """

  List of supported ZIP extension. This module is used to do a
  quickcheck on filenames.

  """

  def supported do
    ["zip", "zipx", "jar", "war", "docx", "xlxs", "pptx", "odt",
    "ods", "odp"]
  end

end
