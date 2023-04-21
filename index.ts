import * as pulumi from "@pulumi/pulumi";

const name = "wired-tag";
const config = new pulumi.Config();
const maintainer = config.require("maintainer");

const wiredAwsEcrStackRef = new pulumi.StackReference(
  `${maintainer}/wired-aws-ecr/prod`
);

const wiredGpClusterStackRef = new pulumi.StackReference(`${maintainer}/wired-gp-cluster/prod`);

export const ecrRepositoryName = name;
export const ecrRepositoryUrl = wiredAwsEcrStackRef
  .getOutput("ecrRepositories")
  .apply((repos) => repos[name]);

export const wiredGpClusterSecretId = wiredGpClusterStackRef.getOutput("awsSecretId");
export const wiredGpClusterDomain = wiredGpClusterStackRef.getOutput("coordinatorDomain");