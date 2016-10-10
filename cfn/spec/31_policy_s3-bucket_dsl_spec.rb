require 'spec_helper'

%w(s3BucketName).each do |env_var_name|
  fail "Must set env var #{env_var_name}" if ENV[env_var_name].nil?
end

describe 'Do not allow upload of unencrypted objects to S3.' do

  before(:all) do
    @godlike_iam_policy = <<-END
      {
        "Version": "2012-10-17",
        "Statement": [
          {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
          }
        ]
      }
    END

    @iam_client = Aws::IAM::Client.new

    verbose = false
    model = CfnDsl::eval_file_with_extras('31_policy_s3-bucket_dsl.rb', [], verbose)
    resources = JSON.load model.to_json
    bucket_policy_document = resources['Resources']['TestBucketPolicy']['Properties']['PolicyDocument']
    @bucket_policy_document_str = JSON.generate bucket_policy_document
  end

  context 'an s3 bucket with policy that S3:PutObject should be denied if not encrypted with AES256.' do
    it 'denies the a call to PutObject without encryption.' do
      puts @bucket_policy_document_str
      simulate_custom_policy_response = @iam_client.simulate_custom_policy policy_input_list: [@godlike_iam_policy],
                                                                           action_names: %w(s3:PutObject),
                                                                           resource_policy: @bucket_policy_document_str,
                                                                           resource_arns: ["arn:aws:s3:::#{ENV['s3BucketName']}/*"],
                                                                           caller_arn: 'arn:aws:iam::786819633871:user/eric.kascic@stelligent.com'
      expect(simulate_custom_policy_response.evaluation_results.size).to eq 1

      puts simulate_custom_policy_response.evaluation_results
      # Should equal one of: implicitDeny, explicitDeny, or allowed
      expect(simulate_custom_policy_response.evaluation_results.first.eval_decision).to eq('explicitDeny'),
                                                                                        "Not denied: s3:PutObject"
    end
  end
end
