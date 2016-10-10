require 'base64'

CloudFormation {

  env ||= 'dev'
  ArtifactBucketName ||= 'notset'
  ArtifactIdList ||= 'notset'
  ChefRecipe ||= 'notset'
  wasImageId ||= 'ami-f5f41398'
  sawgrassBaseLinuxManagementSecurityGroupId ||= 'notset'
  sawgrassAllowAllWithinVpcSecurityGroupId ||= 'notset'
  sawgrassWebElbSecurityGroupId ||= 'notset'
  OrchestratorClientInstanceProfile ||= 'notset'
  wasPrivateSubnetIdA ||= 'notset'
  wasPrivateSubnetIdB ||= 'notset'
  wasInstanceType ||= 'm3.2xlarge'
  wasKeyName ||= ''
  wasdmgrInstancePrivateIp ||= ''
  wasContentServerIp ||= 'notset'
  wasContentServerPort ||= 'notset'

  Description 'Sawgrass WAS Autoscaling Group'

  user_data = <<-END
#!/bin/bash
set -x
export PATH=/usr/local/bin:$PATH
export AWS_REGION=us-east-1
env

source /etc/profile.d/proxy.sh

function error_exit {
  cfn-signal -e 1 --stack %0 --resource %1
  exit 1
}

[ ! -d /orchestrator/client ] && echo "ERROR:  cant find orchestrator client" && exit 2
cd /orchestrator/client

cat - <<JSON > /var/tmp/chef_attributes.json
{
  "wsi": {
    "dmgr_host_name": "%2"
  },
  "content_server": {
    "ip": "%3",
    "port": "%4"
  }
}
JSON
./orchestrator_client.sh artifact_handler s3://#{ArtifactBucketName} #{ArtifactIdList} || error_exit
./orchestrator_client.sh chef_handler #{ChefRecipe} /var/tmp/chef_attributes.json || error_exit
cfn-signal -e $? --stack %0 \
                 --resource %1
  END

  AutoScaling_AutoScalingGroup('WasAutoscalingGroup') {
    LaunchConfigurationName Ref('WasLaunchConfig')

    was_asg_size = 1
    MinSize was_asg_size
    MaxSize was_asg_size
    DesiredCapacity was_asg_size

    VPCZoneIdentifier [
      wasPrivateSubnetIdA,
      wasPrivateSubnetIdB
    ]

    Tags [
      {
        'Key' => 'Name',
        'Value' => 'Sawgrass-WW-WAS-Node',
        'PropagateAtLaunch' => true
      },
      {
        'Key' => 'Environment',
        'Value' => env,
        'PropagateAtLaunch' => true
      }
    ]

    CreationPolicy(
      'ResourceSignal',
      {
        'Count' => was_asg_size.to_s,
        'Timeout' => 'PT45M'
      }
    )
  }

  AutoScaling_LaunchConfiguration('WasLaunchConfig') {

    ImageId wasImageId
    InstanceType wasInstanceType
    AssociatePublicIpAddress false
    KeyName wasKeyName

    IamInstanceProfile OrchestratorClientInstanceProfile
    SecurityGroups [
      sawgrassBaseLinuxManagementSecurityGroupId,
      sawgrassAllowAllWithinVpcSecurityGroupId,
      sawgrassWebElbSecurityGroupId
    ]

    # lifted these from CloudFormation repo, not sure
    # of the why for the two volumes
    BlockDeviceMappings [
      {
        DeviceName: '/dev/sdf',
        Ebs: {
          DeleteOnTermination: true,
          VolumeSize: '60',
          Encrypted: true
        }
      },
      {
        DeviceName: '/dev/sdk',
        Ebs: {
          DeleteOnTermination: true,
          VolumeSize: '60',
          Encrypted: true
        }
      }
    ]

    UserData FnBase64(FnFormat(user_data, Ref('AWS::StackName'), 'WasAutoscalingGroup', wasdmgrInstancePrivateIp, wasContentServerIp, wasContentServerPort))
  }

  Output 'WasLaunchConfig',
         Ref('WasLaunchConfig')
  Output 'WasAutoscalingGroup',
         Ref('WasAutoscalingGroup')
}
