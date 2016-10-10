require 'base64'

CloudFormation {
  env ||= 'dev'
  ArtifactBucketName ||= 'notset'
  ArtifactIdList ||= 'notset'
  ChefRecipe ||= 'notset'
  tibcoadminImageId ||= 'ami-f5f41398'
  jkTibcoDomainSecurityGroupId ||= 'notset'
  jkTibcoEmsSecurityGroupId ||= 'notset'
  sawgrassBaseLinuxManagementSecurityGroupId ||= 'notset'
  jkSoftNasSecurityGroupId ||= 'notset'
  OrchestratorClientInstanceProfile ||= 'notset'
  tibcoadminPrivateSubnetIdA ||= 'notset'
  tibcoadminPrivateSubnetIdB ||= 'notset'
  tibcoadminInstanceType ||= 'm3.2xlarge'
  tibcoadminKeyName ||= ''
  tibcoemsInstancePrivateIp ||= 'notset'
  tibcoemsTcpPort ||= 'notset'
  tibcoemsDomain ||= 'notset'
  awtool1dRDSHostname ||= 'notset'
  awtool1dTcpPort ||= 'notset'
  awtool1dDBName ||= 'notset'
  awtool1dMasterUsername ||= 'notset'
  awtool1dMasterUserPassword ||= 'notset'
  awtool1dRDSAccessSecurityGroup ||= 'notset'

  Description 'Sawgrass TIBCO BW ADMIN'

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
  "createdomain-dbems": {
    "config": {
      "ems_server_ip": "%2",
      "ems_server_port": "%3",
      "db_hostname": "%4",
      "db_port": "%5",
      "db_sid": "%6",
      "db_user_name": "%7",
      "db_user_password": "%8",
      "domain_name": "%9",
      "db_security_group": "%10",
      "tibco_security_group_id": "%11"
    }
  }
}
JSON

./orchestrator_client.sh artifact_handler s3://#{ArtifactBucketName} #{ArtifactIdList} || error_exit
./orchestrator_client.sh chef_handler #{ChefRecipe} /var/tmp/chef_attributes.json || error_exit
cfn-signal -e $? --stack %0 \
                 --resource %1
  END

  EC2_Instance('TibcoBwAdminInstance') {

    ImageId tibcoadminImageId
    InstanceType tibcoadminInstanceType
    KeyName tibcoadminKeyName
    SubnetId tibcoadminPrivateSubnetIdB
    #DeletionPolicy 'Retain'
    IamInstanceProfile OrchestratorClientInstanceProfile
    SecurityGroupIds [
      jkTibcoDomainSecurityGroupId,
      sawgrassBaseLinuxManagementSecurityGroupId
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
        'Value' => 'Sawgrass-Tibco-BW-Admin'
      },
      {
        'Key' => 'Environment',
        'Value' => env
      }
    ]

    UserData FnBase64(
      FnFormat(
        user_data,
        Ref('AWS::StackName'),
        'TibcoBwAdminInstance',
        tibcoemsTibcoEmsInstancePrivateIp,
        tibcoemsTibcoEmsTcpPort,
        awtool1dRDSHostname,
        awtool1dTcpPort,
        awtool1dDBName,
        awtool1dMasterUsername,
        awtool1dMasterUserPassword,
        tibcoemsTibcoDomain,
        awtool1dRDSAccessSecurityGroup,
        jkTibcoDomainSecurityGroupId
      )
    )

    CreationPolicy(
      'ResourceSignal',
      {
        'Count' => 1,
        'Timeout' => 'PT2H'
      }
    )
  }

  Output 'tibcoadminInstancePrivateIp',
         FnGetAtt('TibcoBwAdminInstance', 'PrivateIp')
}
