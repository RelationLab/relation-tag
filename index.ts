import * as pulumi from "@pulumi/pulumi";

const name = "wired-tag";
const config = new pulumi.Config();
const maintainer = config.require("maintainer");

const wiredAwsEcrStackRef = new pulumi.StackReference(
  `${maintainer}/wired-aws-ecr/prod`
);

const wiredGpClusterStackRef = new pulumi.StackReference(`${maintainer}/wired-gp-cluster/prod`);

const wiredUgcInfraDevStackRef = new pulumi.StackReference(`${maintainer}/wired-ugc-infra/dev`);
const wiredUgcInfraStagStackRef = new pulumi.StackReference(`${maintainer}/wired-ugc-infra/stag`);
const wiredUgcInfraProdStackRef = new pulumi.StackReference(`${maintainer}/wired-ugc-infra/prod`);

export const ecrRepositoryName = name;
export const ecrRepositoryUrl = wiredAwsEcrStackRef
  .getOutput("ecrRepositories")
  .apply((repos) => repos[name]);

export const wiredGpClusterSecretId = wiredGpClusterStackRef.getOutput("awsSecretId");
export const wiredGpClusterDomain = wiredGpClusterStackRef.getOutput("coordinatorDomain");

export const wiredUgcSecretIdDev = wiredUgcInfraDevStackRef.getOutput("awsSecretId");
export const wiredUgcSecretIdStag = wiredUgcInfraStagStackRef.getOutput("awsSecretId");
export const wiredUgcSecretIdProd = wiredUgcInfraProdStackRef.getOutput("awsSecretId");

export const wiredUgcDataBaseHostDev = wiredUgcInfraDevStackRef.getOutput("rdsDatabaseDomain");
export const wiredUgcDataBaseHostStag = wiredUgcInfraStagStackRef.getOutput("rdsDatabaseDomain");
export const wiredUgcDataBaseHostProd = wiredUgcInfraProdStackRef.getOutput("rdsDatabaseDomain");