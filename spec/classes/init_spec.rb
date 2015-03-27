require 'spec_helper'
describe 'etcd' do

  context 'with defaults for all parameters' do
    it { should contain_class('etcd') }
  end
end
