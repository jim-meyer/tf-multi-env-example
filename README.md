# Purpose

Demonstrates how to use Terraform ("tf") to deploy IaC resources to multiple environments.
Lots of blogs show the file structure on how to do this. But I have yet run into something
that also shows the *file contents* to make this happen.

So from one directory (this repo's root) once can deploy to two different environments:
- sandbox
- prod

Each of these envs could be in a different account. One would just need to make sure the
AWS CLI profile or AWS CLI credential env vars are for the proper account.

# The use case that prompted this repo

I needed to deploy to two different envs (sandbox, prod) in *3 separate accounts*.
And I wanted each env to use it's own S3 bucket separate from the other envs to avoid possibly
corrupting or deleting one env's TF state while mucking around with another env.
(Sure, I could have used IAM for this but I *hate* mucking around with IAM).

By naiively using `terraform init ...` like this when I deployed first to sandbox then to prod from the same local copy of the repo:

```bash
terraform init -backend-config=sandbox/backend.tf
terraform init -backend-config=prod/backend.tf
```

I was getting errors like this when deploying to the second env (prod):
```
╷
│ Error: Backend configuration changed
│ 
│ A change in the backend configuration has been detected, which may require migrating existing state.
│ 
│ If you wish to attempt automatic migration of the state, use "terraform init -migrate-state".
│ If you wish to store the current configuration with no changes to the state, use "terraform init -reconfigure".
╵
```

It appears that this is because `.terraform/terraform-state.tfstate` was referring to `sandbox` from the first deployment.

The "trick" here is to use `terraform init -reconfigure ...` which presumably ignores the info
in `.terraform/terraform-state.tfstate` and deploys successfully to prod using the prod env's
S3 bucket.

# Why not just use Terraform workspaces?

(Terraform workspaces)[https://developer.hashicorp.com/terraform/cli/workspaces] can be useful for
some purposes. But TF workspaces store all env's state in a single S3 bucket.
This repo shows how TF can be used to store each env's state in a separate bucket.
