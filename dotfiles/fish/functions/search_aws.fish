function search_aws
  echo "Running: aws ec2 describe-instances \
    --region $argv[1] \
    --filters \"Name=tag-value,Values=$argv[2]\""
  aws ec2 describe-instances \
    --region $argv[1] \
    --filters "Name=tag-value,Values=$argv[2]"
end
