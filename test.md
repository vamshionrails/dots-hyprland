from aws_cdk import (
    Stack,
    aws_ec2 as ec2,
    aws_eks as eks,
)
from constructs import Construct

class EksClusterStack(Stack):

    def __init__(self, scope: Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)

        # Import existing VPC
        vpc = ec2.Vpc.from_vpc_attributes(self, "ExistingVPC",
            vpc_id="vpc-0c24b1cc77da8f463",
            availability_zones=["us-west-2a", "us-west-2b", "us-west-2c"],
            public_subnet_ids=[
                "subnet-0324095a4f2188967",
                "subnet-083814b087bad140b",
                "subnet-03a1260affe6f9944"
            ],
            private_subnet_ids=[
                "subnet-00110ffa3ef259d0c",
                "subnet-0a96e24163ef2c9c3"
            ]
        )

        # Create EKS Cluster
        cluster = eks.Cluster(self, "EKSCluster",
            cluster_name="cluster-24",
            vpc=vpc,
            default_capacity=0,  # We will define node groups manually
            version=eks.KubernetesVersion.V1_29  # Adjust according to your Kubernetes version
        )

        # Define Node Group ng-1 (Public Subnets)
        cluster.add_auto_scaling_group_capacity("ng-1",
            instance_types=[ec2.InstanceType("m5.xlarge")],
            desired_capacity=2,
            vpc_subnets=ec2.SubnetSelection(subnets=[
                ec2.Subnet.from_subnet_id(self, "PublicSubnet1", "subnet-0324095a4f2188967"),
                ec2.Subnet.from_subnet_id(self, "PublicSubnet2", "subnet-083814b087bad140b")
            ])
        )

        # Define Node Group ng-2 (Private Subnets with private networking enabled)
        cluster.add_auto_scaling_group_capacity("ng-2",
            instance_types=[ec2.InstanceType("m5.xlarge")],
            desired_capacity=2,
            vpc_subnets=ec2.SubnetSelection(subnets=[
                ec2.Subnet.from_subnet_id(self, "PrivateSubnet1", "subnet-00110ffa3ef259d0c"),
                ec2.Subnet.from_subnet_id(self, "PrivateSubnet3", "subnet-0a96e24163ef2c9c3")
            ]),
            bootstrap_enabled=True,
            private_networking=True
        )
