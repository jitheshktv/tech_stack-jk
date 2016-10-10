require 'base64'

CloudFormation {

  env ||= 'dev'
  ArtifactBucketName ||= 'notset'
  ArtifactIdList ||= 'notset'
  ChefRecipe ||= 'notset'
  wasdmgrImageId ||= 'ami-f5f41398'
  sawgrassBaseLinuxManagementSecurityGroupId ||= 'notset'
  sawgrassAllowAllWithinVpcSecurityGroupId ||= 'notset'
  sawgrassWebElbSecurityGroupId ||= 'notset'
  OrchestratorClientInstanceProfile ||= 'notset'
  wasdmgrPrivateSubnetIdA ||= 'notset'
  wasdmgrPrivateSubnetIdB ||= 'notset'
  wasdmgrInstanceType ||= 'm3.2xlarge'
  wasdmgrKeyName ||= ''
  wasdmgrContentServerIp ||= 'notset'
  wasdmgrContentServerPort ||= 'notset'

  Description 'Sawgrass WAS DMGR Autoscaling Group'

  user_data = <<-END
#!/bin/bash
set -x
export PATH=/usr/local/bin:$PATH
export AWS_REGION=us-east-1
env

source /etc/profile.d/proxy.sh

function error_exit {
  cfn-signal -e 1 --stack %0 \
                  --resource %1
  exit 1
}

[ ! -d /orchestrator/client ] && echo "ERROR:  cant find orchestrator client" && exit 2
cd /orchestrator/client

cat - <<JSON > /var/tmp/chef_attributes.json
{
  "content_server": {
    "ip": "%2",
    "port": "%3"
  }
}
JSON
./orchestrator_client.sh artifact_handler s3://#{ArtifactBucketName} #{ArtifactIdList} || error_exit
./orchestrator_client.sh chef_handler #{ChefRecipe} /var/tmp/chef_attributes.json || error_exit
cfn-signal -e $? --stack %0 \
                 --resource %1
  END

  EC2_Instance('WasDmgrInstance') {

    ImageId wasdmgrImageId
    InstanceType wasdmgrInstanceType
    KeyName wasdmgrKeyName
    SubnetId wasdmgrPrivateSubnetIdB

    IamInstanceProfile OrchestratorClientInstanceProfile
    SecurityGroupIds [
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

    Tags [
      {
        'Key' => 'Name',
        'Value' => 'Sawgrass-WW-Dmgr'
      },
      {
        'Key' => 'Environment',
        'Value' => env
      }
    ]

    UserData FnBase64(FnFormat(user_data, Ref('AWS::StackName'), 'WasDmgrInstance', wasdmgrContentServerIp, wasdmgrContentServerPort))

    CreationPolicy(
      'ResourceSignal',
      {
        'Count' => 1,
        'Timeout' => 'PT45M'
      }
    )
  }

  Output 'wasdmgrInstancePrivateIp',
         FnGetAtt('WasDmgrInstance', 'PrivateIp')
}
