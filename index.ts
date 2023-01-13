import * as pulumi from "@pulumi/pulumi";
import * as aws from "@pulumi/aws";

const name = "wired-tag";
const config = new pulumi.Config();
const maintainer = config.require("maintainer");

const wiredAwsEcrStackRef = aws
  .getRegionOutput()
  .apply(
    (res) =>
      new pulumi.StackReference(`${maintainer}/wired-aws-ecr/${res.name}`)
  );

const wiredAutoTagStackRefOutputs = new pulumi
  .StackReference(`${maintainer}/wired-auto-tag/prod`)
  .getOutput("outputs")

export const ecrRepositoryName = name;
export const ecrRepositoryUrl = wiredAwsEcrStackRef.apply((stack) =>
  stack.getOutput("ecrRepositories").apply((repos) => repos[name])
);
export const wiredAutoTagAwsSecretId = wiredAutoTagStackRefOutputs.apply((outputs) => outputs["awsSecretId"]);
export const wiredAutoTagGreenplumHost = wiredAutoTagStackRefOutputs.apply((outputs) => outputs["gpHost"]);