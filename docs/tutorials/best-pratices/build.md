# Building your tagging strategy

## Defining needs and use cases

As with many practices in operations, implementing a tagging strategy is a process of iteration and improvement. Start small with your immediate priority and grow the tagging schema as you need to.

Start building your strategy by engaging with stakeholders who have a fundamental underlying need to consume metadata. These teams define the metadata that resources need to be tagged with to support their activities, such as reporting, automation, and data classification. They outline how the resources need to be organized and which policies they need to be mapped to. Examples of roles and functions that these stakeholders can have in organizations include:

* **Finance** and **Line of Business** need to understand the value of investment by mapping it to costs to prioritize actions that need to be taken when addressing ineﬃciency. Understanding cost vs value generated helps to identify unsuccessful lines of business or product offerings. This leads to informed decisions about continuing support, adopting an alternative (for example, using a SaaS offering or managed service), or retiring an unprofitable business offering.
* **Governance** and **Compliance** need to understand the categorization of data (for example, public, sensitive, or confidential), whether a specific workload is in or out of scope for audit against a specific standard or regulation and the criticality of the service (whether the service or application is business-critical) to apply appropriate controls and oversight, such as permissions, policies, and monitoring.
* **Operations** and **Development** need to understand the workload lifecycle and implemented stages of their supported products. Management of release stages, (for example, Development, Test, Production split) and their associated support prioritizations and stakeholder management requirements. Duties such as Backups, Patching, Observability and Deprecation also need to be defined and understood.
* **Information Security (InfoSec)** and **Security Operations (SecOps)** outline what controls must be applied and which are recommended. InfoSec normally defines the implementation of the controls, and SecOps is generally responsible for managing those controls.

## Defining and publishing a tagging schema

Employ a consistent approach in tagging your AWS resources, both for mandatory and optional tags. A comprehensive tagging schema helps you to achieve this consistency. The following examples can help get you started:

* Agree on the mandatory tag keys
* Define acceptable values and tag naming conventions (upper or lower case, dashes or underscores, hierarchy, and so on)
* Confirm values would not constitute personally identifiable information (PII)
* Decide who can define and create new tag keys
* Agree on how to add new mandatory tag values and how to manage optional tags

> Best pratices refers to the AWS [white paper](https://docs.aws.amazon.com/whitepapers/latest/tagging-best-practices/tagging-best-practices.html)