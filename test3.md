```

{
    "vpc_id": "vpc-0c24b1cc77da8f463",
    "subnet_ids": {
        "public": [
            "subnet-0324095a4f2188967",
            "subnet-083814b087bad140b",
            "subnet-03a1260affe6f9944"
        ],
        "private": [
            "subnet-00110ffa3ef259d0c",
            "subnet-0a96e24163ef2c9c3"
        ]
    },
    "cluster_name": "cluster-24",
    "instance_type": "m5.xlarge",
    "desired_capacity": 2,
    "max_size": 5,
    "min_size": 2
}



import json
from aws_cdk import (
    Stack,
    aws_ec2 as ec2,
    aws_eks as eks,
    aws_iam as iam,
)
from constructs import Construct

class EksClusterStack(Stack):

    def __init__(self, scope: Construct, id: str, **kwargs) -> None:
        super().__init__(scope, id, **kwargs)

        # Load parameters from inputs.json
        with open("inputs.json") as f:
            inputs = json.load(f)

        # Use the loaded inputs
        vpc_id = inputs["vpc_id"]
        public_subnet_ids = inputs["subnet_ids"]["public"]
        private_subnet_ids = inputs["subnet_ids"]["private"]
        cluster_name = inputs["cluster_name"]
        instance_type = inputs["instance_type"]
        desired_capacity = inputs["desired_capacity"]
        max_size = inputs["max_size"]
        min_size = inputs["min_size"]

        # Call the VPC function to get the VPC object
        vpc = self.get_vpc(vpc_id, public_subnet_ids, private_subnet_ids)

        # Create EKS Cluster
        cluster = eks.Cluster(self, "EKSCluster",
            cluster_name=cluster_name,
            vpc=vpc,
            default_capacity=0,  # We will define node groups manually
            version=eks.KubernetesVersion.V1_30  # Adjust to your Kubernetes version
        )

        # IAM policy for Cluster Autoscaler
        autoscaler_policy = iam.PolicyStatement(
            effect=iam.Effect.ALLOW,
            actions=[
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup"
            ],
            resources=["*"]
        )

        # Define Managed Node Group ng-1 (Public Subnets with Auto-scaling)
        ng1 = cluster.add_nodegroup_capacity("ng-1",
            nodegroup_name="ng-1",
            instance_types=[ec2.InstanceType(instance_type)],
            desired_size=desired_capacity,
            min_size=min_size,
            max_size=max_size,
            capacity_type=eks.CapacityType.ON_DEMAND,
            subnets=ec2.SubnetSelection(subnets=self.get_public_subnets(vpc, public_subnet_ids))  # Attach public subnets
        )

        # Attach autoscaler policy to the node group role
        ng1.role.add_to_policy(autoscaler_policy)

        # Define Managed Node Group ng-2 (Private Subnets with Auto-scaling and private networking)
        ng2 = cluster.add_nodegroup_capacity("ng-2",
            nodegroup_name="ng-2",
            instance_types=[ec2.InstanceType(instance_type)],
            desired_size=desired_capacity,
            min_size=min_size,
            max_size=max_size,
            capacity_type=eks.CapacityType.ON_DEMAND,
            subnets=ec2.SubnetSelection(subnets=self.get_private_subnets(vpc, private_subnet_ids)),  # Attach private subnets
            private_networking=True  # Enable private networking
        )

        # Attach autoscaler policy to the node group role
        ng2.role.add_to_policy(autoscaler_policy)

    def get_vpc(self, vpc_id: str, public_subnet_ids: list, private_subnet_ids: list) -> ec2.IVpc:
        """
        Function to return an imported VPC from existing attributes
        """
        return ec2.Vpc.from_vpc_attributes(self, "ExistingVPC",
            vpc_id=vpc_id,
            availability_zones=["us-west-2a", "us-west-2b", "us-west-2c"],
            public_subnet_ids=public_subnet_ids,
            private_subnet_ids=private_subnet_ids
        )

    def get_public_subnets(self, vpc: ec2.IVpc, public_subnet_ids: list) -> list[ec2.ISubnet]:
        """
        Function to return a list of public subnets based on IDs
        """
        return [ec2.Subnet.from_subnet_id(self, f"PublicSubnet{i+1}", subnet_id) for i, subnet_id in enumerate(public_subnet_ids)]

    def get_private_subnets(self, vpc: ec2.IVpc, private_subnet_ids: list) -> list[ec2.ISubnet]:
        """
        Function to return a list of private subnets based on IDs
        """
        return [ec2.Subnet.from_subnet_id(self, f"PrivateSubnet{i+1}", subnet_id) for i, subnet_id in enumerate(private_subnet_ids)]


```
