module Convict; class Cell

  def initialize(__CONVICT__, __CONVICT_FILE__, __GUARD__)
    $value = lambda do
      __GUARD__.enable do
        instance_eval """#{__CONVICT__}
""", File.realpath(__CONVICT_FILE__), 1
      end
    end.call
  end
end; end
