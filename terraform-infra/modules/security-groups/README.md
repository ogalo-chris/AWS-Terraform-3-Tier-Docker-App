
---

## Security Groups Module – Overview

This module defines **security groups for a production-style 3-tier AWS architecture** consisting of:

* Public Application Load Balancer (ALB)
* Bastion host
* Frontend application servers
* Internal ALB
* Backend application servers
* RDS database

All security groups are created inside a provided VPC and follow the **principle of least privilege** using **security group–to–security group rules** instead of open CIDR ranges where possible.

---

## Traffic Flow & Security Group Responsibilities

### 1. Public ALB Security Group (`public_alb`)

* **Inbound**

  * HTTP (80) from the internet
  * HTTPS (443) from the internet
* **Outbound**

  * All traffic allowed
* **Purpose**

  * Entry point for public user traffic

---

### 2. Bastion Security Group (`bastion`)

* **Inbound**

  * SSH (22) only from `bastion_allowed_ips`
* **Outbound**

  * All traffic allowed
* **Purpose**

  * Secure administrative access to private instances

---

### 3. Frontend App Servers Security Group (`frontend`)

* **Inbound**

  * Application traffic (3000) from **Public ALB SG**
  * SSH (22) from **Bastion SG**
* **Outbound**

  * All traffic allowed
* **Purpose**

  * Hosts the frontend application layer

---

### 4. Internal ALB Security Group (`internal_alb`)

* **Inbound**

  * HTTP (80) from **Frontend App Servers SG**
* **Outbound**

  * All traffic allowed
* **Purpose**

  * Routes internal traffic from frontend to backend services

---

### 5. Backend App Servers Security Group (`backend`)

* **Inbound**

  * Application traffic (8080) from **Internal ALB SG**
  * SSH (22) from **Bastion SG**
* **Outbound**

  * All traffic allowed
* **Purpose**

  * Hosts backend APIs and business logic

---

### 6. RDS Security Group (`rds`)

* **Inbound**

  * PostgreSQL (5432) from **Backend App Servers SG**
* **Outbound**

  * All traffic allowed (AWS default requirement)
* **Purpose**

  * Protects the database from direct network access

---

## Security Design Principles Used

* ✅ **No direct internet access** to application servers or database
* ✅ **Security group chaining** instead of wide CIDR ranges
* ✅ **SSH access restricted** to bastion host only
* ✅ Clear **east–west traffic control** between tiers

---

## Security Recommendations


1. **Use HTTPS internally**

   * Terminate TLS at both public and internal ALBs

2. **Enable VPC Flow Logs**

   * Helps audit and troubleshoot network traffic

3. **Rotate bastion IPs carefully**

   * Avoid long-lived public IP allowlists

---

