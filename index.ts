import * as pulumi from "@pulumi/pulumi";

const name = "wired-tag";
const config = new pulumi.Config();
const maintainer = config.require("maintainer");

const wiredAwsEcrStackRef = new pulumi.StackReference(
  `${maintainer}/wired-aws-ecr/prod`
);

const wiredAutoTagStackRefOutputs = new pulumi.StackReference(
  `${maintainer}/wired-auto-tag/prod`
).getOutput("outputs");

export const ecrRepositoryName = name;
export const ecrRepositoryUrl = wiredAwsEcrStackRef
  .getOutput("ecrRepositories")
  .apply((repos) => repos[name]);

export const wiredAutoTagAwsSecretId = wiredAutoTagStackRefOutputs.apply(
  (outputs) => outputs["awsSecretId"]
);
export const wiredAutoTagGreenplumHost = wiredAutoTagStackRefOutputs.apply(
  (outputs) => outputs["gpHost"]
);
