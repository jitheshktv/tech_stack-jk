require 'spec_helper'


# check out https://github.com/k1LoW/awspec/blob/master/doc/resource_types.md for
# primitives to verify actual cfn creations match expectations

%w(TibcoBwAdminLaunchConfig TibcoBwAdminAutoscalingGroup TibcoEmsLaunchConfig TibcoEmsAutoscalingGroup).each do |env_var_name|
  fail "Must set env var #{env_var_name}" if ENV[env_var_name].nil?
end

describe launch_configuration(ENV['TibcoBwAdminLaunchConfig']) do
  it { should exist }

  #its(:image_id) { should eq 'ami-f5f41398' }
  its(:instance_type) { should eq 'm3.2xlarge' }
  its(:user_data) { should be_partial_match_of_base64_decoding /orchestrator_client\.sh artifact_handler/ }

  its(:user_data) { should_not be_partial_match_of_base64_decoding /notset/ }

  its(:associate_public_ip_address) { should be false }

  its(:iam_instance_profile) { should match /OrchestratorClientInstanceProfile/ }

  #its(:key_name) { should eq '' }

  # given there is > 1 sg with this name in a region, awspec will get upset
  # it { should have_security_group('JK_TIBCO_DOMAIN') }
  # it { should have_security_group('LAB:Sawgrass:BASELinuxManagementSG') }
end

describe autoscaling_group(ENV['TibcoBwAdminAutoscalingGroup']) do
  it { should exist }
  its(:launch_configuration_name) { should eq ENV['TibcoBwAdminLaunchConfig'] }
  its(:min_size) { should eq 4 }
  its(:max_size) { should eq 4 }
end

describe launch_configuration(ENV['TibcoEmsLaunchConfig']) do
  it { should exist }

  #its(:image_id) { should eq 'ami-f5f41398' }
  its(:instance_type) { should eq 'm3.2xlarge' }
  its(:user_data) { should be_partial_match_of_base64_decoding /orchestrator_client\.sh artifact_handler/ }

  its(:user_data) { should_not be_partial_match_of_base64_decoding /notset/ }

  its(:associate_public_ip_address) { should be false }

  its(:iam_instance_profile) { should match /OrchestratorClientInstanceProfile/ }

  #its(:key_name) { should eq '' }

  # it { should have_security_group('JK_SoftNas') }
  # it { should have_security_group('JK_TIBCO_EMS') }
  # it { should have_security_group('LAB:Sawgrass:BASELinuxManagementSG') }
end

describe autoscaling_group(ENV['TibcoEmsAutoscalingGroup']) do
  it { should exist }
  its(:launch_configuration_name) { should eq ENV['TibcoEmsLaunchConfig'] }
  its(:min_size) { should eq 2 }
  its(:max_size) { should eq 2 }
end
