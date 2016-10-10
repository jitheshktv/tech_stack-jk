require 'aws-sdk'
require 'cfndsl'

describe 'BillingAdmin restricted IAM permissions' do

  before(:all) do
    @iam_client = Aws::IAM::Client.new

    verbose = false
    model = CfnDsl::eval_file_with_extras('30_policy_demo_dsl.rb', [], verbose)
    resources = JSON.load model.to_json
    puts resources
    billing_admin_policy_document = resources['Resources']['billingAdmin']['Properties']['Policies'].first['PolicyDocument']
    puts billing_admin_policy_document
    @billing_admin_policy_document_str = JSON.generate billing_admin_policy_document

    @denied_actions = %w(
      iam:CreateUser
      iam:DeleteUser
      iam:AddUserToGroup
      iam:RemoveUserFromGroup
      ec2:CreateDhcpOptions
      ec2:DeleteDhcpOptions
      ec2:AllocateAddress
      ec2:AssociateAddress
      ec2:DisassociateAddress
      ec2:MoveAddressToVpc
      ec2:ReleaseAddress
      ec2:RestoreAddressToClassic
      ec2:Create*Gateway
      ec2:Delete*Gateway
      ec2:Attach*Gateway
      ec2:Detach*Gateway
      ec2:CreateNetworkAcl*
      ec2:DeleteNetworkAcl*
      ec2:ReplaceNetworkAcl*
      ec2:AssociateRouteTable
      ec2:CreateRoute
      ec2:CreateRouteTable
      ec2:DeleteRoute
      ec2:DeleteRouteTable
      ec2:DisableVgwRoutePropagation
      ec2:DisassociateRouteTable
      ec2:EnableVgwRoutePropagation
      ec2:ReplaceRoute
      ec2:ReplaceRouteTableAssociation
      ec2:CreateSubnet
      ec2:DeleteSubnet
      ec2:ModifySubnetAttribute
      ec2:CreateVpc ec2:DeleteVpc
      ec2:AcceptVpcPeeringConnection
      ec2:CreateVpcPeeringConnection
      ec2:DeleteVpcPeeringConnection
      ec2:RejectVpcPeeringConnection
      ec2:CreateVpnConnection
      ec2:CreateVpnConnectionRoute
      ec2:DeleteVpnConnection
      ec2:DeleteVpnConnectionRoute
      ec2:AttachVpnGateway
      ec2:CreateVpnGateway
      ec2:DeleteVpnGateway
      ec2:DetachVpnGateway
      cloudtrail:DeleteTrail
      cloudtrail:StopLogging
    )
  end

  context 'billing admin role allows billing actions and view usage' do
    it 'denies any other action' do
      @denied_actions.each do |denied_action|

        simulate_custom_policy_response = @iam_client.simulate_custom_policy policy_input_list: [@billing_admin_policy_document_str],
                                                                             action_names: [denied_action]

        expect(simulate_custom_policy_response.evaluation_results.size).to eq 1

        # Should equal one of: implicitDeny, explicitDeny, or allowed
        expect(simulate_custom_policy_response.evaluation_results.first.eval_decision).to eq('implicitDeny'),
                                                                                             "Not denied: #{denied_action}"
      end
    end
  end
end
