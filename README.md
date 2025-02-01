# Estin Losts

## Project Overview

Estin Losts is a Golang project designed to help users manage and recover lost items. This project aims to provide a platform where users can create posts about lost items, claim found items, and receive notifications about their posts. Additionally, it includes features for user authentication and administrative actions to manage the platform effectively.

## Features

- Profiles & Authentication: Users can create profiles and authenticate themselves to access the platform.
- Create Post: Users can create posts about lost items with detailed descriptions and images.
- Claim Found Posts: Users can claim posts about found items by providing necessary proof.
- Notifications: Users receive notifications about their posts and claims.
- Admin Actions: Administrators can manage users, posts, and claims to ensure the platform runs smoothly.

## How to Run the Project

To run the Estin Losts project, you need to have Docker installed on your machine. The project requires PostgreSQL and MinIO instances for data storage and file management, respectively. Follow the steps below to set up and run the project:

### Prerequisites

- Docker
- Docker Compose

### Steps

1. **Clone the Repository:**
    ```sh
    git clone /m:/Documents/Golang/estin_losts.git
    cd estin_losts
    ```

3. **Start Docker Containers:**
    Use Docker Compose to start the PostgreSQL and MinIO instances.
    ```sh
    docker-compose up -d
    ```

4. **Run the Application:**
    Build and run the Golang application.
    ```sh
    go build -o estin_losts
    ./estin_losts
    ```

5. **Access the Application:**
    Open your browser and navigate to `http://localhost:8080` to access the Estin Losts platform.
