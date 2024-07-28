# Deploying EBS Driver to your EKS cluster

1. open provider.tf replace the aws credentials with your's own credentials
2. open variable.tf replace the variables 

    a. cluster name : your existing cluster name

    b. region       : your preferred region
    
    c. account id   : your aws account id

As of now we have oidc provider creation as well in the EBS_FUll dir
which can be later shifted to the infra directory.

# Why is the identity provider for the eks cluster required ?
> The OIDC (OpenID Connect) identity provider is required for an EKS (Amazon Elastic Kubernetes Service) cluster to enable authentication between Kubernetes and AWS services.
>
The OIDC provider is responsible for validating the tokens that Kubernetes uses to authenticate requests to the AWS APIs. When a request is made, the OIDC provider checks the token to ensure that it was issued by a trusted identity provider, and that it has not expired. If the token is valid, the request is allowed to proceed.

>Without the OIDC provider, Kubernetes would not be able to verify the identities of users or services trying to access AWS resources, making it difficult to securely manage and access resources.