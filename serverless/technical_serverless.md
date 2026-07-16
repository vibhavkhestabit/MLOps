# Serverless Compute Research

## Objective

Modern cloud applications are expected to handle varying traffic efficiently while minimizing infrastructure costs and operational overhead. Traditionally, applications were deployed on dedicated virtual machines or servers that remained active regardless of whether users were accessing the application. Although this approach provides complete control over the infrastructure, it often leads to underutilized resources during periods of low traffic and requires continuous maintenance, monitoring and scaling.

To overcome these challenges, cloud providers introduced **Serverless Compute**, a cloud computing model where infrastructure management is handled entirely by the cloud platform. Instead of provisioning and managing servers, developers focus solely on writing application code while the platform automatically provisions compute resources, scales based on demand and charges only for the resources consumed.

The objective of this research is to understand the different serverless compute offerings available across major cloud providers such as **Microsoft Azure, Amazon Web Services (AWS), Google Cloud Platform (GCP), Vercel and Cloudflare**, and identify the most suitable platform for deploying our organization's applications, which are primarily built using **Python (FastAPI/Django)** for backend services and **Next.js** for frontend applications.

Rather than simply comparing pricing or cloud providers, this research focuses on understanding **how different serverless compute models work**, their communication capabilities, execution limitations and the scenarios where each approach should be preferred.

---

# Understanding Serverless Compute

Serverless computing does **not** mean that servers do not exist. Servers are still running in the cloud; however, they are completely managed by the cloud provider. Developers no longer need to provision virtual machines, configure operating systems, manage scaling policies or perform infrastructure maintenance.

Instead, the platform automatically allocates compute resources whenever an application receives traffic and releases those resources when they are no longer required. This allows organizations to achieve automatic scaling, reduced operational effort and significantly better resource utilization.

Today, serverless compute is broadly divided into two categories:

## Serverless Functions (Functions as a Service - FaaS)

Serverless Functions are small, event-driven units of execution that run only when a specific event occurs. Once the task completes, the Function terminates and the underlying compute resources are released automatically.

A Function can be triggered by numerous events such as:

* An HTTP request
* A scheduled timer
* A file upload
* A queue message
* A database event
* An Event Grid notification
* A Service Bus message

Because Functions execute only when required, organizations pay only for actual execution time rather than continuously running servers.

Typical workloads include:

* Scheduled report generation
* Email notifications
* File processing
* Image resizing
* Queue consumers
* Background jobs
* AI inference
* Data transformation

However, Functions are designed to execute a task and terminate. They are **not intended to maintain continuously running client connections**.

---

## Serverless Containers (Containers as a Service - CaaS)

Unlike Functions, Serverless Containers host an entire application inside a container while abstracting away the underlying servers.

The application remains continuously available to receive requests, maintain client connections and expose APIs, while the platform automatically scales the number of running container instances based on incoming traffic.

Serverless Containers are therefore ideal for applications that require continuously running backend services.

Typical workloads include:

* FastAPI applications
* Django applications
* Express.js applications
* Spring Boot applications
* Microservices
* REST APIs
* Enterprise backend services
* Real-time communication applications

In modern cloud architectures, it is common to combine both approaches. The primary application is deployed as a **Serverless Container**, while background processing tasks are executed using **Serverless Functions**.

---

# Chapter 1 – Real-Time Communication

One of the most important considerations while selecting a serverless compute platform is understanding how the application communicates with its users.

Not every application communicates in the same way. Some applications only need to return a response to an HTTP request, whereas others continuously stream information to users or allow users to exchange messages in real time.

The communication model directly influences whether the application should be deployed using **Serverless Functions** or **Serverless Containers**.

The three most common real-time communication mechanisms are **Server-Sent Events (SSE)**, **WebSockets** and **Socket.IO**.

---

## Server-Sent Events (SSE)

Server-Sent Events (SSE) provide **one-way communication** between the server and the client.

Once a client establishes a connection, the server continuously pushes updates to the client without requiring the client to repeatedly send new requests.

```
Server ─────────────────────────► Client
```

Since communication is only one-way, the client cannot send messages back through the same connection. If the client needs to communicate with the server, it must create a separate HTTP request.

SSE is particularly useful when information changes continuously on the server and users simply need to observe those updates.

Common use cases include:

* Live deployment logs
* Kubernetes pod logs
* Build progress
* File upload progress
* AI model inference progress
* Dashboard monitoring
* Stock price updates
* Weather dashboards
* Infrastructure monitoring

For example, during a software deployment, developers continuously monitor deployment logs. Instead of refreshing the page every few seconds, the backend streams newly generated log entries directly to the browser using SSE, providing a smooth real-time experience.

---

## WebSockets

Unlike SSE, WebSockets establish a **persistent bidirectional communication channel** between the client and the server.

```
Client ◄──────────────────────► Server
```

Once the connection is established, both the client and the server can exchange messages at any time without repeatedly creating new HTTP requests.

Because the connection remains open, WebSockets are highly efficient for applications where both parties continuously exchange information.

Typical use cases include:

* Chat applications
* Multiplayer games
* Live trading platforms
* Collaborative document editing
* IoT devices
* Live notifications

For example, in a chat application, every message typed by one user must immediately reach all connected users. This continuous two-way communication makes WebSockets the preferred communication protocol.

---

## Socket.IO

Socket.IO is a real-time communication library built on top of WebSockets.

Although WebSockets provide the underlying bidirectional communication channel, production applications generally require additional features such as automatic reconnection, event-based messaging, broadcasting and connection management.

Socket.IO provides these capabilities out of the box.

Key features include:

* Automatic reconnection after network failures
* Event-based communication
* Broadcasting messages
* Rooms and channels
* Group messaging
* Automatic fallback mechanisms
* Connection state management

For instance, consider a company-wide internal chat platform. Employees may join different departmental channels such as Engineering, HR or Sales. Socket.IO allows messages to be broadcast only to members of the selected room while automatically reconnecting users if their network connection is interrupted.

---

## Communication Support Across Serverless Platforms

One of the objectives of this research was to determine which serverless platforms support these communication mechanisms.

| Platform               | SSE                          | WebSockets | Socket.IO  | Recommended Usage                                 |
| ---------------------- | ---------------------------- | ---------- | ---------- | ------------------------------------------------- |
| Azure Functions        | ❌                            | ❌          | ❌          | Event-driven workloads only                       |
| Azure Container Apps   | ✅                            | ✅          | ✅          | Long-running backend services and APIs            |
| AWS Lambda             | ❌                            | ❌          | ❌          | Event-driven workloads only                       |
| AWS App Runner         | ✅                            | ✅          | ✅          | Containerized web applications                    |
| AWS ECS Fargate        | ✅                            | ✅          | ✅          | Enterprise microservices                          |
| Google Cloud Functions | ❌                            | ❌          | ❌          | Event-driven workloads only                       |
| Google Cloud Run       | ✅                            | ✅          | ✅          | Containerized applications                        |
| Vercel                 | ⚠️ Limited streaming support | ❌          | ❌          | Next.js frontend and lightweight APIs             |
| Cloudflare Workers     | ✅                            | ✅          | ⚠️ Limited | Edge applications and global low-latency services |

---

## Chapter 1 – Key Learnings

The communication model of an application is one of the primary factors that determines the appropriate serverless compute platform.

Applications requiring **REST APIs, SSE, WebSockets or Socket.IO** should generally be deployed using **Serverless Containers**, as they remain continuously available and can maintain persistent client connections.

Conversely, **Serverless Functions** are designed for finite, event-driven execution. They start when an event occurs, perform a specific task and terminate after completion. Although they excel at background processing, scheduled jobs and event handling, they are not intended to host long-running communication channels.

Understanding this distinction forms the foundation for selecting the correct compute model before comparing cloud providers or pricing.

# Chapter 2 – Execution Timeouts

After understanding how applications communicate with users, the next important aspect of serverless computing is understanding **execution timeouts**.

Unlike traditional servers that can continue running for as long as required, serverless platforms are designed to execute workloads efficiently and economically. To achieve this, cloud providers place limits on how long a serverless Function can execute before it is automatically terminated.

These timeout limits are particularly important while designing applications because they determine whether a workload is suitable for a **Serverless Function** or whether it should instead execute inside a **Serverless Container**.

Before comparing different cloud providers, it is important to understand the two different types of timeout mechanisms that exist in serverless platforms.

---

## Function Execution Timeout

Function Execution Timeout refers to the maximum duration for which a serverless Function is allowed to execute after being triggered.

A Function may be triggered by various events such as:

* An HTTP request
* A scheduled timer
* A Blob or file upload
* A Queue message
* An Event Grid notification
* A Service Bus message

Once triggered, the Function begins executing its logic. If execution exceeds the maximum timeout configured by the hosting platform, the Function is automatically terminated.

For example, consider a payroll generation system.

Every night at **12:00 AM**, a timer triggers a Function responsible for generating salary reports for every employee in the organization.

```text
12:00 AM
      │
Timer Trigger
      │
Generate Payroll Report
      │
Calculate Salaries
      │
Create Excel Report
      │
Upload to Storage
      │
Send Email to HR
      │
Execution Complete
```

Notice that no employee or HR executive is waiting in front of a browser while this process executes. The Function simply performs the assigned task in the background and terminates after completion.

This is a perfect example of an **event-driven workload**, where Serverless Functions provide an efficient and cost-effective solution.

Common examples include:

* Scheduled report generation
* Email notifications
* Queue processing
* Image resizing
* AI inference
* File processing
* Database cleanup jobs
* Backup operations

---

## HTTP Response Timeout

HTTP Response Timeout is often confused with Function Execution Timeout, although both represent completely different concepts.

Whenever a user interacts with a web application, the browser sends an HTTP request to the server and waits for a response.

For example, suppose an HR executive logs into the company's HR portal and clicks **Generate Monthly Salary Report**.

The browser sends an HTTP request to the backend.

```text
Browser
     │
Generate Report
     │
HTTP Request
     │
Server Starts Processing
```

Now imagine that generating salary reports for thousands of employees requires approximately **8–10 minutes**.

During this entire period, the browser continues waiting for the server to respond.

```text
Browser

Waiting...

Waiting...

Waiting...
```

Keeping an HTTP connection open for such a long duration is neither practical nor desirable. Therefore, cloud providers place limits on how long HTTP connections are allowed to remain active.

For Azure Functions, HTTP-triggered Functions are subject to an **approximately 230-second HTTP response limit** because requests pass through the Azure Load Balancer.

If the server has not returned a response within this period, the browser receives a timeout error even though the Function itself may still be executing (depending on the selected hosting plan).

This demonstrates that **HTTP Response Timeout and Function Execution Timeout are independent concepts**.

The browser may stop waiting long before the Function has actually completed its work.

---

## Long-Running Processing

Production applications generally avoid making users wait several minutes for processing to complete.

Instead, they follow an **asynchronous architecture**.

Consider the same payroll generation example.

Instead of forcing HR to wait while reports are generated, the application immediately acknowledges the request.

```text
HR Clicks "Generate Report"
             │
Request Accepted
             │
Immediate Success Response
             │
Browser Free To Continue Working
```

Meanwhile, the actual processing begins in the background.

```text
Serverless Function

↓

Generate Report

↓

Store Report

↓

Send Email Notification

↓

Processing Complete
```

From the user's perspective, the request completes almost instantly, while the heavy processing continues independently.

The same approach is commonly used in AI applications.

For example, consider an application where users upload large videos for AI analysis.

Video processing may require twenty to thirty minutes.

Instead of making users stare at a loading screen, the application simply acknowledges the upload, starts a background Function responsible for AI processing and notifies the user once the results become available.

This architecture improves user experience, avoids unnecessary HTTP timeouts and allows compute resources to be utilized more efficiently.

---

# Serverless Function Timeout Comparison

| Platform                             | Plan                                   |             Default Timeout |               Maximum Timeout | HTTP / Request Limitation                                                               | Recommended Workloads                                   |
| ------------------------------------ | -------------------------------------- | --------------------------: | ----------------------------: | --------------------------------------------------------------------------------------- | ------------------------------------------------------- |
| **Azure Functions**                  | Consumption                            |               **5 minutes** |                **10 minutes** | HTTP-triggered requests have an **approximately 230-second response limit**             | Timers, Blob triggers, Queue processing, Scheduled jobs |
| **Azure Functions**                  | Flex Consumption / Premium / Dedicated |              **30 minutes** |                 **Unbounded** | HTTP-triggered requests continue to have an **approximately 230-second response limit** | Long-running background processing                      |
| **AWS Lambda**                       | All Plans                              |                Configurable |                **15 minutes** | Invocation ends when the configured timeout is reached                                  | Event-driven applications                               |
| **Google Cloud Functions (Gen2)**    | All Plans                              |                **1 minute** |                **60 minutes** | Request timeout is configurable                                                         | Event-driven applications                               |
| **Vercel Functions (Classic)**       | Hobby                                  |              **10 seconds** |                **60 seconds** | Function duration limit                                                                 | Lightweight API routes                                  |
| **Vercel Functions (Fluid Compute)** | Hobby                                  | **300 seconds (5 minutes)** |   **300 seconds (5 minutes)** | Function duration limit                                                                 | Next.js API routes                                      |
| **Vercel Functions (Fluid Compute)** | Pro / Enterprise                       | **300 seconds (5 minutes)** | **800 seconds (~13 minutes)** | Function duration limit                                                                 | Long-running API routes                                 |
| **Cloudflare Workers**               | Free / Paid                            |                         N/A | CPU execution depends on plan | HTTP requests are commonly limited to **approximately 100 seconds**                     | Edge logic, authentication, request processing          |

---

# Serverless Container Comparison

Unlike Functions, Serverless Containers are designed to host continuously running applications. They are not constrained by Function-style execution limits because the application itself remains active and continuously serves requests.

| Platform                 | Function-style Execution Timeout                        | SSE | WebSockets | Socket.IO | Typical Usage                                 |
| ------------------------ | ------------------------------------------------------- | --- | ---------- | --------- | --------------------------------------------- |
| **Azure Container Apps** | No                                                      | ✅   | ✅          | ✅         | Python, FastAPI, Django, Node.js applications |
| **AWS App Runner**       | No                                                      | ✅   | ✅          | ✅         | Containerized web applications                |
| **AWS ECS Fargate**      | No                                                      | ✅   | ✅          | ✅         | Enterprise microservices                      |
| **Google Cloud Run**     | No (HTTP request timeout configurable up to 60 minutes) | ✅   | ✅          | ✅         | Containerized APIs and real-time services     |

---

## Chapter 2 – Key Learnings

Execution timeouts are primarily associated with **Serverless Functions**, which are designed to perform a finite unit of work before terminating. These limits ensure efficient resource utilization and prevent Functions from running indefinitely.

It is equally important to distinguish between **Function Execution Timeout** and **HTTP Response Timeout**. Function Execution Timeout determines how long a Function may continue executing, whereas HTTP Response Timeout determines how long a browser or client is willing to wait for a response. These two mechanisms operate independently and should never be confused.

Applications involving long-running tasks should avoid making users wait for completion. Instead, they should acknowledge the request immediately, perform heavy processing asynchronously using Serverless Functions and notify users once the work has finished.

This asynchronous design pattern is one of the fundamental architectural principles used in modern cloud-native applications.


# Practical Application Architectures

After understanding communication models and execution timeouts, the next step is to understand how these concepts are applied in real-world applications. Modern cloud-native systems rarely rely on a single serverless compute model. Instead, they combine **Serverless Containers** and **Serverless Functions**, allowing each service to perform the tasks it is best suited for.

The following examples demonstrate how production applications are commonly architected across Azure, AWS and Google Cloud.

---

## Scenario 1 – HR Management Portal

An HR Management Portal allows employees to log in, apply for leave, view attendance records, download salary slips and manage personal information. These are day-to-day operations that require the backend application to remain continuously available to receive incoming requests.

Such workloads are ideal for **Serverless Containers** because the application must always be ready to serve REST APIs, authenticate users and communicate with databases.

However, some operations inside the same application are computationally expensive.

For example, at the end of every month, the HR department may generate salary reports for thousands of employees. This process can take several minutes as it involves salary calculations, tax deductions, Excel/PDF generation and storing the reports.

Keeping the HR executive waiting for several minutes is neither practical nor desirable. Instead, the application immediately acknowledges the request and triggers a **Serverless Function** to perform the heavy processing in the background. Once the report has been generated, it is stored in cloud storage and the HR executive is notified through email or an in-application notification.

### Recommended Architecture

```text
Next.js Frontend
        │
        ▼
Python Backend
(Serverless Container)
        │
        ├── Login APIs
        ├── Leave Management
        ├── Attendance APIs
        ├── Authentication
        │
        ▼
Generate Payroll Report
        │
        ▼
Serverless Function
        │
        ▼
Generate Excel/PDF
        │
        ▼
Blob Storage
        │
        ▼
Email HR
```

### Key Takeaway

* Containers host the primary application.
* Functions execute long-running background jobs.
* Users receive immediate responses instead of waiting for processing to finish.

---

## Scenario 2 – DevOps Monitoring Dashboard

Consider an internal DevOps dashboard used for monitoring Kubernetes deployments, infrastructure metrics and application logs.

Developers expect deployment progress, CPU usage and container logs to update continuously without refreshing the browser.

This requirement makes **Server-Sent Events (SSE)** an ideal communication mechanism. The backend continuously streams newly generated logs to connected clients while maintaining a persistent connection.

Since the backend must remain active at all times, it is deployed using a **Serverless Container**.

At the same time, the platform may generate nightly infrastructure reports, cloud cost summaries or compliance reports. These activities do not require user interaction and therefore execute efficiently as **Serverless Functions** triggered by scheduled timers.

### Recommended Architecture

```text
Browser
        │
        ▼
DevOps Backend
(Serverless Container)
        │
        ├── REST APIs
        ├── Kubernetes Logs
        ├── Monitoring APIs
        └── SSE Stream
                │
                ▼
Live Browser Updates

12 AM
        │
        ▼
Serverless Function
        │
        ▼
Infrastructure Report
        │
        ▼
Email Operations Team
```

### Key Takeaway

* Containers handle continuous communication.
* SSE streams live deployment logs.
* Functions generate scheduled operational reports.

---

## Scenario 3 – Company Chat Application

A company chat platform requires users to send messages instantly, view online users, receive typing indicators and participate in departmental channels.

Unlike dashboard updates, chat applications require both the client and the server to exchange information continuously.

This makes **WebSockets** the preferred communication protocol, while **Socket.IO** further simplifies implementation by providing automatic reconnection, event-based messaging, broadcasting and room management.

Because these connections remain active throughout the user's session, the chat server should be deployed using a **Serverless Container**.

Serverless Functions continue to play an important supporting role by handling background activities such as sending welcome emails to new employees, performing scheduled database backups or processing notifications.

### Recommended Architecture

```text
Users
        │
        ▼
Socket.IO
        │
        ▼
Node.js Backend
(Serverless Container)
        │
        ├── Chat Messages
        ├── Online Users
        ├── Typing Indicators
        ├── Group Channels
        │
        ▼
Database

Background Tasks
        │
        ▼
Serverless Functions
        │
        ├── Welcome Emails
        ├── Database Backup
        └── Notification Processing
```

### Key Takeaway

* Socket.IO provides production-ready real-time communication.
* Containers maintain persistent client connections.
* Functions execute supporting background operations.

---

## Scenario 4 – AI Video Processing Platform

Consider an AI-powered platform where users upload videos for transcription, summarization or object detection.

Uploading the video itself is a normal HTTP request handled by the backend application.

However, processing the uploaded video may require several minutes depending on file size and AI model complexity.

Rather than forcing users to wait, the backend immediately accepts the upload and triggers a **Serverless Function** responsible for video processing.

Throughout execution, users can monitor processing progress through **Server-Sent Events (SSE)** exposed by the backend container. Once processing finishes, the generated results become available for download.

### Recommended Architecture

```text
Next.js Frontend
        │
        ▼
Python Backend
(Serverless Container)
        │
Upload Video
        │
        ▼
Blob Storage
        │
        ▼
Serverless Function
        │
        ├── Frame Extraction
        ├── AI Processing
        ├── Caption Generation
        ├── Video Analysis
        │
        ▼
Store Results
        │
        ▼
SSE Progress Updates
        │
        ▼
Browser
```

### Key Takeaway

* Containers receive uploads and stream progress.
* Functions execute compute-intensive AI workloads.
* Users remain informed without waiting for a long-running HTTP request.

---

# Overall Conclusions

The study demonstrates that selecting a serverless platform is not simply a matter of choosing between Azure, AWS or Google Cloud. The first architectural decision is determining **how the application behaves**.

Applications that primarily expose REST APIs or require real-time communication through **SSE, WebSockets or Socket.IO** are best deployed using **Serverless Containers** such as Azure Container Apps, AWS App Runner, ECS Fargate or Google Cloud Run. These services remain continuously available and are capable of maintaining persistent client connections.

On the other hand, **Serverless Functions** are intended for finite, event-driven workloads. They are ideal for scheduled jobs, queue processing, file uploads, report generation, AI inference, image processing and other background tasks that execute only when triggered.

In practice, modern cloud-native applications combine both compute models. Containers host the primary application and manage user interactions, while Functions execute asynchronous workloads independently. This hybrid architecture provides automatic scaling, reduced infrastructure management, improved cost efficiency and a better overall user experience.

Understanding these principles forms the foundation for evaluating individual serverless platforms such as Azure, AWS, Google Cloud, Vercel and Cloudflare in the subsequent chapters of this research.

# Chapter 3 – Cold Starts, Scale-to-Zero, Warm Instances & Autoscaling

After understanding communication mechanisms and execution timeouts in the previous chapters, the next important aspect of serverless computing is understanding **how cloud platforms manage compute resources automatically**.

One of the biggest advantages of serverless computing is that developers no longer need to manually provision, monitor or remove servers. Instead, cloud providers automatically create compute resources when traffic increases and remove them when applications become idle.

While this provides excellent cost optimization, it also introduces concepts such as **Cold Starts**, **Scale-to-Zero**, **Warm Instances**, **Cooldown Periods**, **Polling Intervals** and **Provisioned Concurrency**. Understanding these concepts is essential because they directly affect application performance, latency and operational cost.

Rather than studying these concepts independently, they should be viewed as different stages of the same application lifecycle.

```text
Traffic Arrives
      │
      ▼
Application Starts
      │
      ▼
Warm Instance
      │
      ▼
Traffic Stops
      │
      ▼
Cooldown Period
      │
      ▼
Scale to Zero
      │
      ▼
No Compute Running
      │
      ▼
New Request Arrives
      │
      ▼
Cold Start
      │
      ▼
Warm Instance Again
```

---

# 3.1 Scale-to-Zero

Scale-to-Zero is one of the defining characteristics of serverless computing.

It refers to the platform's ability to automatically remove all running compute instances when there is no incoming traffic. Unlike Virtual Machines, where infrastructure continues running regardless of utilization, serverless platforms stop billing for compute once no active instances remain.

For example, consider an application receiving heavy traffic during office hours.

```text
9:00 AM

200 Active Users

↓

Application Scales

1 → 3 → 6 → 10 Containers
```

At night, no users access the application.

```text
11:00 PM

Traffic = 0

↓

Platform Removes Compute

↓

0 Running Containers
```

Since no compute resources remain active, organizations only pay for storage, networking and other supporting services rather than idle CPU and memory.

Scale-to-Zero is one of the primary reasons why serverless computing is considered highly cost-efficient.

---

# 3.2 Cold Start

A Cold Start occurs whenever an application has previously scaled to zero and a new request arrives.

Since no compute resources are currently available, the platform must first provision infrastructure before processing the request.

This process may include:

* Allocating compute resources
* Allocating memory
* Starting the runtime or container
* Initializing application dependencies
* Opening network ports
* Performing health checks

Only after these steps complete can the application begin serving requests.

```text
No Running Containers

↓

User Opens Website

↓

Platform Starts Container

↓

Application Starts

↓

Request Processed
```

The first request therefore experiences additional latency compared to subsequent requests.

Cold Start duration depends on several factors including runtime, programming language, dependency size, container image size, memory allocation and cloud provider implementation. For this reason, cloud providers intentionally do not publish fixed cold start durations.

---

# 3.3 Warm Instance

A Warm Instance is an already running execution environment capable of immediately serving incoming requests without requiring initialization.

For example, after the first request starts the application,

```text
User 1

↓

Cold Start

↓

Application Running
```

subsequent users experience significantly lower latency.

```text
User 2

↓

Warm Instance

↓

Immediate Response
```

Maintaining warm instances is one of the most common techniques used to reduce cold starts in production systems.

Different cloud providers implement warm instances using different mechanisms such as Azure Always Ready Instances, AWS Provisioned Concurrency, Google Cloud Minimum Instances or Azure Container Apps Minimum Replicas.

---

# 3.4 Cooldown Period

Cloud platforms do not immediately terminate running instances when traffic stops.

Instead, they intentionally wait for a short duration to determine whether traffic resumes before removing compute resources.

This waiting period is known as the **Cooldown Period** or **Idle Window**.

For Azure Container Apps, Microsoft officially documents a default cooldown period of **300 seconds (5 minutes)**.

Example:

```text
Traffic Stops

↓

Platform Waits

300 Seconds

↓

Still No Traffic?

↓

Begin Scaling Down
```

If new requests arrive during the cooldown period, the application continues using existing warm instances and avoids unnecessary cold starts.

Cooldown periods improve stability by preventing applications from repeatedly scaling down and restarting when traffic fluctuates.

---

# 3.5 Polling Interval

Polling Interval refers to how frequently the autoscaling engine evaluates application metrics to determine whether scaling actions are required.

Unlike Cooldown, which begins after traffic stops, Polling occurs continuously throughout the application's lifetime.

Azure Container Apps officially evaluates scaling metrics approximately every **30 seconds**.

Example:

```text
9:00:00

↓

Check Metrics

↓

9:00:30

↓

Check Again

↓

9:01:00

↓

Check Again
```

If CPU usage, concurrent requests or queue length exceed configured thresholds, additional replicas are created.

Polling Interval therefore determines **how frequently scaling decisions are evaluated**, whereas Cooldown determines **how long the platform waits before removing resources.**

---

# 3.6 Provisioned Concurrency

Provisioned Concurrency is an AWS Lambda feature that keeps a specified number of execution environments initialized and ready to process requests.

Without Provisioned Concurrency, Lambda may scale completely to zero, resulting in cold starts whenever new requests arrive.

For example,

```text
Provisioned Concurrency = 5

↓

5 Lambda Environments

Always Ready

↓

No Cold Start
```

Although this increases infrastructure cost because compute remains allocated, it significantly improves response time for latency-sensitive applications.

Similar concepts exist across other cloud providers:

* Azure Functions → Always Ready Instances
* Azure Container Apps → Minimum Replicas
* Google Cloud Run → Minimum Instances
* Google Cloud Functions → Minimum Instances
* AWS ECS Fargate → Minimum Desired Tasks

Although terminology differs, the objective remains identical: **maintain warm compute resources to reduce cold starts.**

---

# Chapter 3 – Platform Comparison

## Serverless Platform Scaling Comparison

| Platform     | Compute Service        | Scale to Zero             | Polling Interval            | Cooldown / Idle Window                     | Warm Instance Support                 | Cold Start | Cold Start Mitigation   | Level of Control |
| ------------ | ---------------------- | ------------------------- | --------------------------- | ------------------------------------------ | ------------------------------------- | ---------- | ----------------------- | ---------------- |
| Azure        | Azure Functions        | ✅ Yes                     | N/A (Event-driven)          | Not Published                              | Always Ready Instances (Premium/Flex) | Yes        | Always Ready Instances  | Medium           |
| Azure        | Azure Container Apps   | ✅ Yes (Min Replicas = 0)  | **30 sec (Official)**       | **300 sec / 5 min (Official)**             | Minimum Replicas                      | Yes        | Minimum Replicas ≥ 1    | High             |
| AWS          | AWS Lambda             | ✅ Yes                     | N/A (Event-driven)          | Not Published                              | Provisioned Concurrency               | Yes        | Provisioned Concurrency | High             |
| AWS          | AWS App Runner         | ✅ Yes                     | Not Published               | Not Published                              | Minimum Running Capacity              | Possible   | Maintain Warm Capacity  | Medium           |
| AWS          | AWS ECS Fargate        | Configuration Dependent   | Managed by ECS Auto Scaling | Configurable via ECS Auto Scaling Policies | Minimum Desired Tasks                 | Yes        | Minimum Desired Tasks   | Very High        |
| Google Cloud | Cloud Functions (Gen2) | ✅ Yes                     | N/A (Event-driven)          | Not Published                              | Minimum Instances                     | Yes        | Minimum Instances       | Medium           |
| Google Cloud | Cloud Run              | ✅ Yes (Min Instances = 0) | Not Published               | Not Published                              | Minimum Instances                     | Yes        | Minimum Instances ≥ 1   | High             |
| Vercel       | Vercel Functions       | ✅ Yes                     | N/A (Event-driven)          | Not Published                              | Platform Managed                      | Yes        | Platform Managed        | Low              |
| Cloudflare   | Cloudflare Workers     | ✅ Yes                     | N/A (Event-driven)          | Not Published                              | Platform Managed (Isolate Reuse)      | Minimal    | V8 Isolates             | Very Low         |

---

## Cold Start Behaviour Comparison

| Platform               | Cold Start Behaviour                 | Primary Reason                        |
| ---------------------- | ------------------------------------ | ------------------------------------- |
| Azure Functions        | Medium                               | Function host initialization          |
| Azure Container Apps   | Medium                               | Container startup                     |
| AWS Lambda             | Medium (Higher for Java/.NET or VPC) | Runtime initialization                |
| AWS App Runner         | Medium                               | Container initialization              |
| AWS ECS Fargate        | Medium–High                          | Task scheduling and container startup |
| Google Cloud Functions | Low–Medium                           | Gen2 runtime improvements             |
| Google Cloud Run       | Low                                  | Optimized container startup           |
| Vercel Functions       | Low                                  | Optimized Next.js / Node.js runtime   |
| Cloudflare Workers     | Very Low                             | V8 Isolates instead of containers     |

> **Note:** Cloud providers intentionally do not publish fixed cold start durations because startup time depends on runtime, language, deployment package, container image size, memory allocation and regional infrastructure.

---

## Warm Instance Configuration Comparison

| Platform               | Warm Instance Mechanism  |
| ---------------------- | ------------------------ |
| Azure Functions        | Always Ready Instances   |
| Azure Container Apps   | Minimum Replicas         |
| AWS Lambda             | Provisioned Concurrency  |
| AWS App Runner         | Minimum Running Capacity |
| AWS ECS Fargate        | Minimum Desired Tasks    |
| Google Cloud Functions | Minimum Instances        |
| Google Cloud Run       | Minimum Instances        |
| Vercel                 | Automatically Managed    |
| Cloudflare Workers     | Automatic Isolate Reuse  |

---

## Scale-to-Zero Comparison

| Platform               | Default Behaviour                         |
| ---------------------- | ----------------------------------------- |
| Azure Functions        | Automatically scales to zero when idle    |
| Azure Container Apps   | Scales to zero when Minimum Replicas = 0  |
| AWS Lambda             | Automatically scales to zero              |
| AWS App Runner         | Automatically scales according to traffic |
| AWS ECS Fargate        | Depends on Auto Scaling configuration     |
| Google Cloud Functions | Automatically scales to zero              |
| Google Cloud Run       | Scales to zero when Minimum Instances = 0 |
| Vercel Functions       | Automatically scales to zero              |
| Cloudflare Workers     | Executes only when requests arrive        |

---

# Chapter 3 – Key Learnings

This chapter demonstrates that **serverless platforms continuously balance performance and cost**. Keeping compute resources active provides excellent response times but increases infrastructure cost, whereas scaling completely to zero minimizes cost at the expense of occasional cold starts.

Although Azure, AWS, Google Cloud, Vercel and Cloudflare all support automatic scaling, they expose different levels of operational control. Azure provides the most transparent scaling behaviour by officially documenting polling intervals and cooldown periods for Azure Container Apps. AWS offers the highest level of configurability through Provisioned Concurrency and Auto Scaling policies, while Google Cloud focuses on deployment simplicity using Minimum Instances. Vercel abstracts most infrastructure management for frontend applications, whereas Cloudflare achieves exceptionally low startup latency through its V8 isolate architecture.

From an architectural perspective, the most important takeaway is that **cold starts are not a platform limitation but a consequence of scaling to zero**. Production systems that require consistently low latency should maintain warm execution environments using the provider-specific mechanisms discussed in this chapter, while cost-sensitive applications can allow full scale-to-zero to maximize infrastructure savings.

# Chapter 4 – Pricing, Free Tiers & Cost Optimization

After understanding how serverless platforms communicate (Chapter 1), execute workloads (Chapter 2), and automatically scale (Chapter 3), the final step is understanding **how cloud providers charge for these services** and **which platform should be selected for different types of applications**.

Unlike traditional Virtual Machines where users pay for continuously running infrastructure, serverless platforms follow a **pay-for-what-you-use** pricing model. Resources are allocated only when required and automatically released when workloads complete, significantly reducing operational costs.

However, each provider implements pricing differently. Azure, AWS, Google Cloud, Vercel and Cloudflare all offer generous free tiers, but they differ in billing units, free quotas, developer experience and enterprise capabilities. Understanding these differences enables architects to choose the most cost-effective platform without compromising scalability or performance.

---

# 4.1 How Serverless Pricing Works

Serverless platforms charge based on **resource consumption rather than server ownership**. Instead of renting an entire server for a fixed monthly price, billing depends on the actual resources consumed by the application.

For **Serverless Functions**, the primary billing factors are:

* Number of function executions (Requests / Invocations)
* Execution duration
* Memory allocated
* CPU usage (on some providers)

For **Serverless Containers**, billing is based on:

* vCPU allocation
* Memory allocation
* Container running time
* Network bandwidth
* Additional managed cloud services

This pricing model allows applications to scale automatically while ensuring developers only pay for the compute resources actually consumed.

---

## Function vs Container Pricing

| Service                    | Primary Billing Factors                                |
| -------------------------- | ------------------------------------------------------ |
| **Serverless Functions**   | Requests (Invocations) + Execution Time + Memory / CPU |
| **Serverless Containers**  | vCPU + Memory + Running Time                           |
| **Static Website Hosting** | Storage + Outbound Bandwidth                           |
| **CDN Services**           | Outbound Data Transfer                                 |

### Example

Suppose a scheduled report generation function runs once every night.

```text
12:00 AM
      │
Generate Monthly Report
      │
Runs for 2 Minutes
      │
Stops
```

Since the function executes only once per day, billing occurs only during those two minutes.

In contrast, a REST API serving users throughout the day requires a continuously available backend.

```text
Users
   │
REST API
   │
Container
   │
Database
```

Containers remain available until scaled down, making them better suited for complete backend applications.

---

# 4.2 Official Free Tier & Trial Credits

Most cloud providers encourage developers to adopt their platforms by offering free tiers, trial credits and startup programs. These programs are particularly valuable for students, hobby projects and early-stage startups.

## Free Tier & Trial Credit Comparison

| Platform         | Always Free Tier                                    | Trial Credits                               | Student Benefits                       | Startup Program                     | Credit Card Required     |
| ---------------- | --------------------------------------------------- | ------------------------------------------- | -------------------------------------- | ----------------------------------- | ------------------------ |
| **Azure**        | Azure Functions free grant + selected free services | **US$200 (30 Days)**                        | Azure for Students                     | Microsoft for Startups Founders Hub | Trial: Yes, Students: No |
| **AWS**          | Yes                                                 | Free Tier (12 Months for eligible services) | AWS Educate / Academy                  | AWS Activate                        | Yes                      |
| **Google Cloud** | Yes                                                 | **US$300 (90 Days)**                        | Google Cloud Education Programs        | Google for Startups Cloud           | Yes                      |
| **Vercel**       | Hobby Plan                                          | None                                        | GitHub Student Developer Pack Benefits | Vercel Startup Program              | No                       |
| **Cloudflare**   | Free Plan                                           | None                                        | None                                   | Cloudflare for Startups             | No                       |

### Understanding the Free Tier

It is important to distinguish between **trial credits** and an **always-free tier**.

**Trial credits** (such as Azure's US$200 or Google Cloud's US$300) are temporary balances that expire after a fixed period.

An **always-free tier** provides monthly usage limits that automatically reset every billing cycle. As long as the application remains within these limits, there is no charge.

For example:

* AWS Lambda provides **1 million free requests every month**.
* Google Cloud Functions provides **2 million free invocations every month**.
* Vercel Hobby Plan includes monthly execution quotas suitable for personal websites and small projects.
* Cloudflare Workers provide **100,000 free requests per day**.

This means developers can often host personal portfolios, blogs and academic projects entirely free of cost.

---

# 4.3 Function & Container Pricing

Although all serverless platforms follow a pay-as-you-go pricing model, the billing dimensions differ slightly across providers.

## Function Pricing Comparison

| Platform                          | Monthly Free Requests            | Free Compute                                  | Billing Unit               | Charged For                              |
| --------------------------------- | -------------------------------- | --------------------------------------------- | -------------------------- | ---------------------------------------- |
| **Azure Functions**               | **1 Million**                    | **400,000 GB-seconds**                        | GB-seconds                 | Requests + Memory + Execution Time       |
| **AWS Lambda**                    | **1 Million**                    | **400,000 GB-seconds**                        | GB-seconds                 | Requests + Memory + Execution Time       |
| **Google Cloud Functions (Gen2)** | **2 Million**                    | **400,000 GB-seconds + 200,000 vCPU-seconds** | vCPU-seconds + GiB-seconds | Requests + CPU + Memory + Execution Time |
| **Vercel Functions**              | Included Monthly Execution Quota | Included CPU & Memory Quotas                  | Execution Duration         | Invocations + Compute                    |
| **Cloudflare Workers**            | **100,000 Requests / Day**       | CPU Time Included                             | CPU Milliseconds           | Requests + CPU Time                      |

### Function Pricing Observations

* Azure and AWS follow almost identical billing models.
* Google Cloud Gen2 separates CPU and memory billing for greater flexibility.
* Cloudflare Workers focus on CPU execution time because they execute inside lightweight V8 isolates rather than traditional containers.
* Vercel abstracts infrastructure complexity by exposing plan-based quotas instead of GB-second calculations.

---

## Serverless Container Pricing Comparison

| Platform                 | Scale-to-Zero           | Billing Based On | Idle Billing               | Warm Instance Support    | Best For                             |
| ------------------------ | ----------------------- | ---------------- | -------------------------- | ------------------------ | ------------------------------------ |
| **Azure Container Apps** | Yes                     | vCPU + Memory    | No (after scaling to zero) | Minimum Replicas         | Containerized APIs                   |
| **AWS App Runner**       | Yes                     | vCPU + Memory    | Reduced when idle          | Minimum Running Capacity | Managed Web Applications             |
| **AWS ECS Fargate**      | Configuration Dependent | vCPU + Memory    | Depends on Running Tasks   | Minimum Desired Tasks    | Production Containers                |
| **Google Cloud Run**     | Yes                     | vCPU + Memory    | No (after scaling to zero) | Minimum Instances        | Stateless Containerized Applications |

### Containers vs Functions

Functions are most economical for **short-lived event-driven workloads**, whereas containers are better suited for **complete backend applications**, REST APIs and microservices requiring persistent application processes.

---

# 4.4 Real-World Cost Analysis & Platform Selection

Cloud architecture decisions are rarely made using pricing alone. Real-world applications often combine multiple serverless services to balance performance, scalability and operational cost.

## Application Selection Matrix

| Application                  | Frontend        | Backend                                           | Functions                                | Recommended Platform |
| ---------------------------- | --------------- | ------------------------------------------------- | ---------------------------------------- | -------------------- |
| Personal Portfolio           | Vercel          | —                                                 | Vercel Functions                         | Vercel               |
| College Placement Portal     | Vercel          | Azure Container Apps / Cloud Run                  | Azure Functions / Google Cloud Functions | Azure / GCP          |
| Startup SaaS                 | Vercel          | Azure Container Apps / AWS App Runner / Cloud Run | Azure Functions / AWS Lambda             | Azure / AWS / GCP    |
| Enterprise HRMS              | React / Angular | Azure Container Apps / AWS ECS Fargate            | Azure Functions / AWS Lambda             | Azure / AWS          |
| AI Video Processing Platform | React           | Container Services                                | Functions                                | Azure / AWS / GCP    |

### Observations

* **Personal portfolios** can usually remain within the free tiers of Vercel or Cloudflare.
* **College projects and MVPs** benefit from Vercel for the frontend and Cloud Run or Azure Container Apps for the backend.
* **Enterprise systems** generally prefer Azure or AWS because of their mature networking, monitoring, RBAC and compliance capabilities.
* **AI workloads** are better suited to serverless container platforms due to their longer execution times and higher compute requirements.

---

# 4.5 Cost Optimization & Final Platform Selection

Designing an efficient cloud-native application is not only about selecting the correct provider—it is also about minimizing unnecessary infrastructure costs.

## Cost Optimization Strategies

| Strategy                  | Functions        | Containers   | Benefit                       |
| ------------------------- | ---------------- | ------------ | ----------------------------- |
| Scale-to-Zero             | Yes              | Yes          | Eliminates idle compute costs |
| Warm Instances            | Optional         | Optional     | Reduces cold starts           |
| Event-Driven Architecture | Best Choice      | Not Ideal    | Pay only when events occur    |
| Long-Running APIs         | Not Ideal        | Best Choice  | Stable backend performance    |
| Optimize CPU & Memory     | Yes              | Yes          | Reduces compute charges       |
| Reduce Startup Time       | Moderate Impact  | High Impact  | Faster responses              |
| Cache Responses           | Moderate Benefit | High Benefit | Lowers backend workload       |
| CDN for Static Content    | Indirect         | Indirect     | Reduces bandwidth and latency |

---

## Final Platform Decision Matrix

| Requirement                 | Best Choice                                               | Alternatives                  | Reason                                            |
| --------------------------- | --------------------------------------------------------- | ----------------------------- | ------------------------------------------------- |
| Personal Portfolio          | Vercel                                                    | Cloudflare Pages              | Simplest deployment and generous free tier        |
| Static Websites             | Cloudflare Pages                                          | Vercel                        | Global CDN with excellent performance             |
| Next.js Applications        | Vercel                                                    | Cloudflare Pages              | Native Next.js integration                        |
| Event-Driven Workloads      | Azure Functions / AWS Lambda / Google Cloud Functions     | Cloudflare Workers            | Mature Function-as-a-Service platforms            |
| Containerized Microservices | Azure Container Apps / Google Cloud Run / AWS ECS Fargate | AWS App Runner                | Designed for long-running containerized workloads |
| Enterprise Applications     | Azure / AWS                                               | Google Cloud                  | Enterprise networking, security and compliance    |
| AI & ML APIs                | Google Cloud Run / Azure Container Apps / AWS ECS Fargate | —                             | Better support for containerized AI workloads     |
| Edge Applications           | Cloudflare Workers                                        | Vercel Edge Functions         | Global edge execution with ultra-low latency      |
| Rapid MVP Development       | Vercel + Cloud Run                                        | Vercel + Azure Container Apps | Fast deployment with minimal operational overhead |

---

# Chapter 4 – Key Learnings

Serverless pricing is fundamentally based on **resource consumption**, allowing organizations to pay only for the compute resources actually used instead of continuously running infrastructure.

Functions and Containers complement one another rather than compete. Functions excel at handling event-driven, asynchronous and scheduled workloads, while serverless containers provide the flexibility and runtime required for complete backend APIs, microservices and enterprise applications.

Among the platforms studied:

* **Azure** provides one of the strongest enterprise ecosystems with excellent integration across Microsoft services.
* **AWS** offers the largest collection of cloud services and the highest operational flexibility.
* **Google Cloud** focuses on deployment simplicity, particularly through Cloud Run.
* **Vercel** delivers the best developer experience for frontend and Next.js applications.
* **Cloudflare** leads in edge computing through its globally distributed Workers platform.

The most important conclusion from this chapter is that **there is no universally "best" serverless platform**. The correct choice depends on application architecture, communication requirements, execution time, scalability needs, latency expectations, operational complexity and budget. Modern cloud-native applications frequently combine multiple platforms—for example, Vercel for the frontend, Azure Container Apps or Cloud Run for backend APIs, and Azure Functions or AWS Lambda for background processing—to achieve the best balance between performance, scalability and cost.
