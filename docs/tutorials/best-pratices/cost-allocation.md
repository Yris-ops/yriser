# Tags for cost allocation and financial management

## Maximizing Cost Visibility and Financial Management

One of the first tagging use cases organizations often tackle is visibility and management of cost and usage. There are usually a few reasons for this:

- It's typically a well understood scenario and requirements are well known. For example, finance teams want to see the total cost of workloads and infrastructure that span across multiple services, features, accounts, or teams. One way to achieve this cost visibility is through consistent tagging of resources.

- Tags and their values are clearly defined. Usually, cost allocation mechanisms already exist in an organization’s finance systems, for example, tracking by cost center, business unit, team, or organization function.

- Rapid, demonstrable return on investment. It’s possible to track cost optimization trends over time when resources are tagged consistently, for example, for resources that were rightsized, auto-scaled, or put on a schedule.

Understanding how you incur costs in cloud provider allows you to make informed financial decisions. Knowing where you have incurred costs at the resource, workload, team, or organization level enhances your understanding of the value delivered at the applicable level when compared to the business outcomes achieved.

- The engineering teams might not have experience with financial management of their resources. Attaching a person with a specialized skill in cloud provider financial management who can train engineering and development teams on the basics of financial management, and create a relationship between finance and engineering to foster the culture of FinOps will help achieve measurable outcomes for the business, and encourage teams to build with cost in mind. Establishing good financial practices is covered in depth by the Cost Optimization Pillar of the Well-Architected Framework, but we will touch on a few of the fundamental principles in this whitepaper.

## Implementing Effective Resource Tagging Strategies

 - **Cost Center**: You can use a tag to indicate the cost center responsible for the resource. This facilitates cost attribution to specific entities within your organization.
- **Business Unit**: If your organization is divided into distinct business units, you can use a tag to identify the business unit to which the resource belongs. This provides better visibility into costs associated with each business unit.
- Environment: If you have multiple environments (e.g., development, test, production), you can use a tag to indicate the environment to which the resource belongs. This can help track costs by environment and identify optimization opportunities specific to each environment.
- **Project**: If you allocate resources to specific projects, you can use a tag to indicate the corresponding project. This facilitates cost tracking by project and evaluation of project profitability.
- **Owner**: You can use a tag to indicate the owner or person responsible for the resource. This facilitates communication and cost accountability.
- **Resource Type**: You can use a tag to indicate the type of resource, such as database, EC2 instance, managed service, etc. This allows grouping costs by resource type and better understanding of cost distribution.
- **Creation Date**: By adding a tag with the resource's creation date, you can track the lifespan of resources and assess their cost impact over time.

These examples are just a starting point, and you can add additional tags based on your specific needs. The goal is to choose tags that enable you to categorize and analyze costs meaningfully for your organization.