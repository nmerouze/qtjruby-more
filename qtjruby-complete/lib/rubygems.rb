Object.send(:remove_const, :Gem) if Object.const_defined? :Gem
Kernel.send(:remove_method, :gem) if Kernel.respond_to? :gem

module Gem
end

module Kernel
  def gem *args; end
end