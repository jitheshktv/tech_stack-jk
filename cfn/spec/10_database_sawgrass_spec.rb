require 'spec_helper'

%w(DbInstance).each do |env_var_name|
  fail "Must set env var #{env_var_name}" if ENV[env_var_name].nil?
end

describe rds(ENV['DbInstance']) do
  it { should exist }
  its(:db_instance_status) { should eq('available') | eq('creating') | eq('modifying') | eq('backing-up') }
  its(:publicly_accessible) { should be false }
  its(:storage_encrypted) { should be true }
  #it { should belong_to_vpc('vpc-e5f73382') }
end
