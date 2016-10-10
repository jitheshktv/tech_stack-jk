require 'spec_helper'


# check out https://github.com/k1LoW/awspec/blob/master/doc/resource_types.md for
# primitives to verify actual cfn creations match expectations

%w(WasLaunchConfig WasAutoscalingGroup).each do |env_var_name|
  fail "Must set env var #{env_var_name}" if ENV[env_var_name].nil?
end

describe launch_configuration(ENV['WasLaunchConfig']) do
  it { should exist }

  #its(:image_id) { should eq 'ami-f5f41398' }
  its(:instance_type) { should eq 'm3.2xlarge' }
  its(:user_data) { should be_partial_match_of_base64_decoding /orchestrator_client\.sh artifact_handler/ }

  its(:user_data) { should_not be_partial_match_of_base64_decoding /notset/ }

  its(:associate_public_ip_address) { should be false }

  its(:iam_instance_profile) { should match /OrchestratorClientInstanceProfile/ }

  its(:key_name) { should eq '' }

  # it { should have_security_group('Sawgrass-WEB-ELBSG') }
  # it { should have_security_group('LAB:Sawgrass:BASELinuxManagementSG') }
  # it { should have_security_group('Sawgrass-allow-all-within-VPC-SG') }
end

describe launch_configuration(ENV['WasDmgrLaunchConfig']) do
  it { should exist }

  #its(:image_id) { should eq 'ami-f5f41398' }
  its(:instance_type) { should eq 'm3.2xlarge' }
  its(:user_data) { should be_partial_match_of_base64_decoding /orchestrator_client\.sh artifact_handler/ }

  its(:user_data) { should_not be_partial_match_of_base64_decoding /notset/ }

  its(:associate_public_ip_address) { should be false }

  its(:iam_instance_profile) { should match /OrchestratorClientInstanceProfile/ }

  its(:key_name) { should eq '' }

  # it { should have_security_group('Sawgrass-WEB-ELBSG') }
  # it { should have_security_group('LAB:Sawgrass:BASELinuxManagementSG') }
  # it { should have_security_group('Sawgrass-allow-all-within-VPC-SG') }
end

describe autoscaling_group(ENV['WasAutoscalingGroup']) do
  it { should exist }
  its(:launch_configuration_name) { should eq ENV['WasLaunchConfig'] }
  its(:min_size) { should eq 2 }
  its(:max_size) { should eq 2 }
end

describe autoscaling_group(ENV['WasDmgrAutoscalingGroup']) do
  it { should exist }
  its(:launch_configuration_name) { should eq ENV['WasDmgrLaunchConfig'] }
  its(:min_size) { should eq 1 }
  its(:max_size) { should eq 1 }
end
