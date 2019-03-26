require 'spec_helper'
describe 'jenkins' do
  context 'with default values for all parameters' do
    it { should contain_class('jenkins') }
  end
end

# comment
