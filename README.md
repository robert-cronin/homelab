# Educational Homelab Kubernetes Cluster

Welcome to my homelab Kubernetes cluster repository! This project serves as both a personal learning journey and a resource for others interested in setting up their own Kubernetes Homelabs. The setup consists of 2 Raspberry Pi 4s and a Mac Mini, showcasing how you can build a powerful, heterogeneous cluster with hardware you might already have at home.

## Hardware Setup

- 2 x Raspberry Pi 4 (4GB and 8GB models)
- 1 x Mac Mini
- Network switch (with 3 Gigabit Ethernet cables)
- Nest Wifi router
- Power supplies for each device
- 32 GB microSD cards for the Raspberry Pis

This combination of ARM (Raspberry Pi) and x86 (Mac Mini) architectures demonstrates the flexibility of Kubernetes in managing diverse hardware! The Raspberry Pis are great for edge computing and IoT projects, while the Mac Mini provides additional compute power and storage.

## Software Stack

### Core Components

1. **[MicroK8s](https://microk8s.io/)**: Our choice of Kubernetes distribution

   - **Why**: MicroK8s is lightweight, easy to install, and perfect for edge computing and IoT devices like Raspberry Pis. It's also backed by Canonical, ensuring good support and documentation.

2. **[Talos OS](https://www.talos.dev/)** (In trial phase)
   - **Why**: I am currently exploring Talos OS as a potential replacement for the current Ubuntu/MicroK8s setup. Talos is a minimal, immutable Linux distribution designed specifically for running Kubernetes, which can enhance security and simplify upgrades.

### Cluster Management and GitOps

3. **[ArgoCD](https://argoproj.github.io/cd/)**: GitOps continuous delivery tool
   - **Why**: ArgoCD allows us to define our entire cluster state in Git, making it easier to manage, version, and rollback changes. It's a powerful tool for maintaining consistency between our Git repositories and live cluster state.

### Networking and Service Mesh

4. **[Istio](https://istio.io/)**: Service mesh
   - **Why**: Istio provides the traffic management, security, and observability features for the cluster's microservices. In a learning environment, it's invaluable for understanding modern microservices architectures and practices.

### Storage and Databases

5. **[PostgreSQL](https://www.postgresql.org/)**: Relational database

   - **Why**: PostgreSQL is a robust, open-source database that's widely used in production environments. It's an excellent choice for learning about database management in Kubernetes.

6. **[Redis](https://redis.io/)**: In-memory data structure store
   - **Why**: Redis is often used for caching and real-time applications. Including it in our stack allows us to explore performance optimization techniques and distributed caching, as well as session storage and pub/sub messaging.

### Messaging and Event Streaming

7. **[RabbitMQ](https://www.rabbitmq.com/)**: Message broker
   - **Why**: RabbitMQ is a popular choice for implementing message queues and pub/sub systems. It's great for learning about decoupled architectures and asynchronous communication between services.

### Serverless and FaaS

8. **[OpenFaaS](https://www.openfaas.com/)**: Serverless functions platform
   - **Why**: OpenFaaS allows us to deploy serverless functions on Kubernetes, providing a great way to learn about serverless architectures and event-driven computing. Alternatives that you might explore include [Knative](https://knative.dev/docs/) and [Fission](https://fission.io/)

### Security and Secret Management

9. **[SOPS](https://github.com/mozilla/sops)**: Secrets encryption

   - **Why**: SOPS allows us to securely store encrypted secrets in our Git repository, which is crucial for maintaining security in a GitOps workflow.

10. **[Reflector](https://github.com/emberstack/kubernetes-reflector)**: Kubernetes resource reflection
    - **Why**: Reflector helps us manage secrets across namespaces, which is particularly useful in a learning environment where we might want to share certain configurations across different parts of our cluster.

## Repository Structure

- `apps/`: Application-specific configurations
- `argocd/`: ArgoCD setup and configuration
- `domains/`: Domain-specific configurations
- `hack/`: Utility scripts
- `istio/`: Istio service mesh configuration
- `openfaas/`: OpenFaaS serverless platform setup
- `postgres/`: PostgreSQL database configuration
- `rabbitmq/`: RabbitMQ message broker setup
- `redis/`: Redis in-memory data store configuration
- `reflector/`: Reflector configuration for secret management
- `talos/`: Talos OS configuration and setup scripts (for our ongoing trial)

## Setup Instructions

1. Install MicroK8s on your Raspberry Pis and Mac Mini following the [official guide](https://microk8s.io/docs/getting-started).
2. Join the nodes to form a cluster using `microk8s add-node` command.
3. Apply the configurations in the `argocd/` directory to set up ArgoCD.
4. Use ArgoCD to deploy the rest of the applications and configurations.

For detailed setup instructions, please refer to the README files in each directory.

## Learning Opportunities

This homelab setup provides numerous learning opportunities:

1. **Multi-architecture clusters**: Learn how to manage a cluster with both ARM and x86 nodes.
2. **GitOps**: Understand how to manage your entire infrastructure as code using ArgoCD.
3. **Service Mesh**: Explore advanced networking concepts with Istio.
4. **Databases in Kubernetes**: Learn how to run and manage databases in a containerized environment.
5. **Serverless on Kubernetes**: Experiment with serverless architectures using OpenFaaS.
6. **Message Queues**: Understand asynchronous communication patterns with RabbitMQ.
7. **Caching**: Learn about distributed caching and performance optimization with Redis.
8. **Security**: Explore secure secret management practices with SOPS and Reflector.

## Contributing

Contributions, questions, and discussions are welcome! Feel free to open issues or submit pull requests if you have suggestions or improvements.

## License

This project is licensed under the Apache License 2.0. See the LICENSE file for details.
