terraform {
  backend "s3" {
    # A little chicken-and-egg problem... Here is how to pre-create the bucket before init:
    # aws s3api create-bucket --bucket bencemadarasz-tf-state-store --region eu-west-1 --create-bucket-configuration LocationConstraint=eu-west-1
    # aws s3api put-bucket-versioning --bucket bencemadarasz-tf-state-store --versioning-configuration Status=Enabled
    # IDEA: do this with CDK?
    bucket       = "bencemadarasz-tf-state-store"
    key          = "homework/provisioning"
    use_lockfile = true        # better than nothing, but in CI better to use Atlantis or similiar
    region       = "eu-west-1" # no vars here
  }
}
