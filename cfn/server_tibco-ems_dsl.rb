require 'base64'

CloudFormation {
  env ||= 'dev'
  ArtifactBucketName ||= 'notset'
  ArtifactIdList ||= 'notset'
  ChefRecipe ||= 'notset'
  tibcoemsImageId ||= 'ami-f5f41398'
  jkTibcoDomainSecurityGroupId ||= 'notset'
  jkTibcoEmsSecurityGroupId ||= 'notset'
  sawgrassBaseLinuxManagementSecurityGroupId ||= 'notset'
  jkSoftNasSecurityGroupId ||= 'notset'
  OrchestratorClientInstanceProfile ||= 'notset'
  tibcoemsPrivateSubnetIdA ||= 'notset'
  tibcoemsPrivateSubnetIdB ||= 'notset'
  tibcoemsInstanceType ||= 'm3.2xlarge'
  tibcoemsKeyName ||= ''

  Description 'Sawgrass TIBCO EMS'

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

./orchestrator_client.sh artifact_handler s3://#{ArtifactBucketName} #{ArtifactIdList} || error_exit
./orchestrator_client.sh chef_handler #{ChefRecipe} || error_exit
cfn-signal -e $? --stack %0 \
                 --resource %1
  END

  EC2_Instance('TibcoEmsInstance') {

    ImageId tibcoemsImageId
    InstanceType tibcoemsInstanceType
    KeyName tibcoemsKeyName
    SubnetId tibcoemsPrivateSubnetIdB

    IamInstanceProfile OrchestratorClientInstanceProfile
    SecurityGroupIds [
      jkTibcoEmsSecurityGroupId,
      sawgrassBaseLinuxManagementSecurityGroupId,
      jkSoftNasSecurityGroupId
    ]

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
        'Value' => 'Sawgrass-Tibco-EMS'
      },
      {
        'Key' => 'Environment',
        'Value' => env
      }
    ]

    UserData FnBase64(FnFormat(user_data, Ref('AWS::StackName'), 'TibcoEmsInstance'))

    CreationPolicy(
      'ResourceSignal',
      {
        'Count' => 1,
        'Timeout' => 'PT2H'
      }
    )
  }

  Output 'tibcoemsInstancePrivateIp',
         FnGetAtt('TibcoEmsInstance', 'PrivateIp')
}
