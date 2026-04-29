# Health Check Endpoints Documentation

This document outlines the health check endpoints for the multi-language application architecture. These endpoints are used by the `app_monitor.sh` watchdog script and future Nginx load balancers to determine upstream server health.

## 1. Node.js (Express) API
* **Stack**: PostgreSQL, Express
* **Port**: `3000`
* **Endpoint**: `GET http://localhost:3000/api/health`
* **Description**: Verifies the Node.js event loop and the pg.Pool connection to PostgreSQL.
* **cURL Command**:
  ```
  curl -s http://localhost:3000/api/health
  ```

## 2. Python (FastAPI) API

* **Stack**: MySQL, FastAPI, Uvicorn
* **Port**: 8000
* **Endpoint**: GET http://localhost:8000/api/health (or / depending on routing)
* **Swagger UI**: GET http://localhost:8000/docs
* **cURL Command**:
```
curl -s http://localhost:8000/
```

## PHP (Laravel) API
* **Stack**: MySQL, Laravel
* **Port**: 9000
* **Endpoint**: GET http://localhost:9000/api/health
* **cURL Command**:
```
curl -s http://localhost:9000/api/health
```

## 4. React (Next.js) Frontend

* **Stack**: Next.js App Router
* **Port**: 3001
* **Endpoint**: GET http://localhost:3001/
* **Description**: Verifies that the SSR Node instance is actively serving HTML/JS payloads.

![ss](../screenshots/ss1.png)
![ss](../screenshots/ss2.png)
![ss](../screenshots/ss3.png)
![ss](../screenshots/ss4.png)
![ss](../screenshots/ss5.png)
![ss](../screenshots/ss6.png)
![ss](../screenshots/ss7.png)
![ss](../screenshots/ss8.png)
![ss](../screenshots/ss9.png)
![ss](../screenshots/ss10.png)
![ss](../screenshots/ss11.png)
![ss](../screenshots/ss12.png)
![ss](../screenshots/ss13.png)
![ss](../screenshots/ss14.png)
![ss](../screenshots/ss15.png)
![ss](../screenshots/ss16.png)
![ss](../screenshots/ss17.png)
![ss](../screenshots/ss18.png)
![ss](../screenshots/ss19.png)
![ss](../screenshots/ss20.png)
![ss](../screenshots/ss21.png)
![ss](../screenshots/ss22.png)
![ss](../screenshots/ss23.png)
![ss](../screenshots/ss24.png)
![ss](../screenshots/ss25.png)
![ss](../screenshots/ss26.png)
![ss](../screenshots/ss27.png)
![ss](../screenshots/ss28.png)