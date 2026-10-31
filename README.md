# Smart Customer Feedback Analyzer with Sentiment and Topic Detection

An enterprise-grade, microservice-oriented Natural Language Processing (NLP) intelligence platform designed to extract actionable business insights from customer feedback at scale.

---

## 1. Project Overview

Organizations receive customer feedback across numerous channels—support tickets, customer surveys, app reviews, and social media. Processing this unstructured feedback manually is slow, error-prone, and fails to detect emerging operational issues in time.

The **Smart Customer Feedback Analyzer** platform provides:
- Automated sentiment analysis and probability distributions using **DistilBERT** *(Implemented &mdash; Step 3)*.
- Unsupervised topic discovery, dominant topic classification, and keyword extraction using **Latent Dirichlet Allocation (LDA)** *(Implemented &mdash; Step 4)*.
- Synchronous Django-to-FastAPI ML orchestration, transaction-safe result persistence, and `FeedbackTopic` storage *(Implemented &mdash; Step 5)*.
- Real-time organizational health monitoring, sentiment breakdowns, and volume trends via an interactive **Next.js Dashboard** *(Implemented &mdash; Step 6)*.
- High-throughput bulk CSV ingestion with pre-ingestion preview, row error tracking, and automated batch analysis *(Implemented &mdash; Step 7)*.
- Memory-efficient streaming CSV and JSON exports with built-in **spreadsheet formula injection protection** *(Implemented &mdash; Step 7)*.
- Production-hardened multi-container architecture with **Gunicorn**, **Uvicorn**, **PostgreSQL 16**, **Next.js Standalone**, security headers, rate limiting, and **GitHub Actions CI/CD** *(Implemented &mdash; Step 8)*.

---

## 2. Implementation Status

| Stage | Name | Status | Verification Summary |
| :--- | :--- | :--- | :--- |
| **Step 1** | **Foundation, Architecture & Health Checks** | **COMPLETE** | **Static Integrity & Python Unit Tests Passed (100%)** |
| **Step 2** | **Database Design & Django Core REST API** | **COMPLETE** | **39 Unit Tests Passed, JWT Auth, Tenant Isolation, Feedback CRUD, Verify Script 4/4 Passed** |
| **Step 3** | **DistilBERT Sentiment Analysis Service** | **COMPLETE WITH ENVIRONMENT LIMITATIONS** | **23 Unit Tests Passed, Single & Batch Inference APIs, Model Lifecycle, Preprocessing, Error Handling, Verify Script 4/4 Passed** |
| **Step 4** | **LDA Topic Detection & NLP Pipeline** | **COMPLETE** | **47 ML Unit Tests Passed, Topic Training, Single/Batch Inference, Model Lifecycle, Safe Retraining, Verify Script 4/4 Passed** |
| **Step 5** | **Django to FastAPI ML Orchestration & Persistence** | **COMPLETE** | **50 Django Tests (97 Total), MLServiceClient, FeedbackAnalysisService, FeedbackTopic Storage, Batch Analysis, Verify Script 4/4 Passed** |
| **Step 6** | **Next.js Dashboard & Frontend Architecture** | **COMPLETE WITH ENVIRONMENT LIMITATIONS** | **Next.js 14+ App Router, Auth UI, Live Aggregation APIs, Sentiment & Topic Visualizations, Feedback Table & Detail Inspector, Verify Script 100% Passed (53 Django Tests)** |
| **Step 7** | **Bulk Ingestion, Export Pipelines & E2E Validation** | **COMPLETE** | **Bulk CSV Ingestion, Preview Validation, Deduplication, Streaming CSV/JSON Exports with Formula Injection Protection, Import UI Workflow, 89 Django Tests, Verify Script 100% Passed** |
| **Step 8** | **Production Hardening, Deployment & CI/CD** | **COMPLETE** | **Gunicorn WSGI, Uvicorn ASGI, PostgreSQL 16 Support, Security Headers, Rate Limiting, Docker Compose Prod, GitHub Actions CI/CD, 100% Matrix Passed** |

---

## 3. Technology Stack

### Frontend Service (`frontend/`)
- **Framework**: Next.js 14+ (App Router, Standalone Node runner)
- **Language**: TypeScript (Strict Mode with complete data model contracts)
- **Styling**: Tailwind CSS & Modern CSS Design Tokens (Dark theme, responsive grid)
- **Icons**: Real SVG Icons (Lucide React & Accessible Inline SVGs, strictly zero emojis)
- **State & Session**: React Context (`AuthProvider`, `ToastProvider`), `TokenStorage` (Access/Refresh JWTs with auto-refresh), and custom hooks
- **Routes & Views**:
  - `app/page.tsx`: Smart root redirect (authenticated -> `/dashboard`, unauthenticated -> `/login`)
  - `app/(auth)/login/page.tsx` & `app/(auth)/register/page.tsx`: JWT Authentication UI
  - `app/dashboard/page.tsx`: Operational intelligence dashboard with KPI metrics, sentiment gauges, top topics, volume trends, and recent feedback
  - `app/feedback/page.tsx`: Filterable feedback table with pagination, multi-field filters, streaming CSV/JSON export actions, and batch analysis actions
  - `app/feedback/[id]/page.tsx`: In-depth feedback detail inspector with sentiment breakdown, topic keywords, and analysis timeline
  - `app/imports/page.tsx`: Bulk CSV feedback upload, validation preview, real-time chunk progress, and error inspection
  - `app/organizations/page.tsx`: Multi-tenant workspace and membership management
  - `app/settings/page.tsx`: User profile and environment configuration
  - `app/api/health/route.ts`: Node.js internal runtime health check

### Core Backend Service (`services/django-api/`)
- **Framework**: Django 4.2+ / Django REST Framework (DRF)
- **Production Server**: Gunicorn (WSGI, 3 configurable workers)
- **Authentication**: JWT via `djangorestframework-simplejwt` with token rotation and blacklisting
- **Database**: PostgreSQL 16 (Production) / SQLite (Zero-config Development)
- **Rate Limiting & Abuse Defense**: DRF Throttling (`AnonRateThrottle`, `UserRateThrottle`, `ScopedRateThrottle`)
- **Security Headers**: HSTS, `X-Content-Type-Options: nosniff`, `X-Frame-Options: DENY`, `Referrer-Policy: same-origin`, secure cookie toggles
- **Domain Apps & Modules**:
  - `apps.health`: Health check endpoint and dependency monitoring
  - `apps.accounts`: User registration, JWT login/refresh/logout, profile retrieval
  - `apps.organizations`: Multi-tenant workspace entities and role-based permissions (`OWNER`, `ADMIN`, `ANALYST`)
  - `apps.feedback`: `Feedback` and `FeedbackTopic` models, serializers, views, and `MLServiceClient` orchestration
  - `apps.imports`: `ImportJob` state machine, chunked bulk ingestion, duplicate detection, and automated ML triggers
  - `apps.exports`: Memory-efficient streaming CSV/JSON exports with formula injection defense (`=, +, -, @`)

### AI & Machine Learning Service (`services/ml-service/`)
- **Framework**: FastAPI (Async ASGI with lifespan event management)
- **Production Server**: Uvicorn (ASGI, 2 configurable workers)
- **Validation**: Pydantic v2 & Pydantic Settings
- **Sentiment Engine**: Hugging Face Transformers & PyTorch (`distilbert-base-uncased-finetuned-sst-2-english`)
- **Topic Engine**: Scikit-Learn `CountVectorizer` & `LatentDirichletAllocation` (`sklearn.decomposition`)
- **Serialization**: `joblib` & `json` with atomic file swapping

### CI/CD & DevOps
- **Containerization**: Multi-stage Dockerfiles (`docker/`) with unprivileged users (`USER appuser`)
- **Compose Orchestration**: `docker-compose.yml` (development) & `docker-compose.prod.yml` (production with PostgreSQL)
- **Continuous Integration**: GitHub Actions workflow (`.github/workflows/ci.yml`) testing Django, FastAPI, Frontend, and full verification matrix.

---

## 4. Architecture & Port Allocation

```
+-------------------------------------------------------------------------------+
|                             Client Web Browser                                |
+---------------------------------------+---------------------------------------+
                                        | HTTP (Port 3000)
                                        v
+-------------------------------------------------------------------------------+
|                       Next.js Frontend (Port 3000)                            |
|       - UI Shell, Dashboard, Ingestion & Export Workflows                     |
+---------------------------------------+---------------------------------------+
                                        | HTTP REST / JWT Sessions
                                        v
+-------------------------------------------------------------------------------+
|                   Django Core Application API (Port 8000)                     |
|       - Gunicorn WSGI Server (3 workers)                                      |
|       - Auth, Workspaces, Feedback CRUD, Rate Limiting, Security Headers      |
|       - Bulk CSV Ingestion (apps.imports) & Streaming Exports (apps.exports)  |
|       - ML Orchestration Client (apps.feedback.services.ml_client)             |
+-------------------+-----------------------------------+-----------------------+
                    | TCP 5432                          | HTTP (Port 8001)
                    v                                   v
+-----------------------+           +-------------------------------------------+
| PostgreSQL 16 DB      |           |     FastAPI ML Microservice (Port 8001)   |
| (feedback_db)         |           |     - Uvicorn ASGI Server                 |
| (SQLite in dev)       |           |     - DistilBERT Sentiment Analysis       |
+-----------------------+           |     - Scikit-Learn LDA Topic Detection    |
                                    +-------------------------------------------+
```

### Port Allocation Table

| Service | Host Port | Container Port | Process Manager | Health Endpoint |
| :--- | :--- | :--- | :--- | :--- |
| **Next.js Frontend** | `3000` | `3000` | Node.js Standalone | `http://localhost:3000/api/health` |
| **Django Core API** | `8000` | `8000` | Gunicorn WSGI | `http://localhost:8000/api/v1/health/` |
| **FastAPI ML Service**| `8001` | `8001` | Uvicorn ASGI | `http://localhost:8001/health` |
| **PostgreSQL Database**| `5432` | `5432` | PostgreSQL 16 | `pg_isready` probe |

---

## 5. Local Quickstart & Development

### 1. Environment Configuration
```bash
# Copy root environment variables
cp .env.example .env
```

### 2. Start Services Locally with Python Virtual Environment
```bash
# Run Django Migrations
python services/django-api/manage.py migrate

# Start Django API Server
python services/django-api/manage.py runserver 0.0.0.0:8000

# Start FastAPI ML Microservice (in separate terminal)
uvicorn app.main:app --app-dir services/ml-service --host 0.0.0.0 --port 8001 --reload

# Start Next.js Frontend (in separate terminal)
cd frontend && npm run dev
```

---

## 6. Production Deployment Instructions

### Deploy with Production Docker Compose (Recommended)

To deploy the entire production stack (PostgreSQL 16, Django Gunicorn, FastAPI Uvicorn, and Next.js Standalone):

```bash
# 1. Configure production environment
cp .env.example .env
# Set DJANGO_SECRET_KEY, POSTGRES_PASSWORD, DJANGO_ALLOWED_HOSTS in .env

# 2. Build and launch all production containers
docker compose -f docker-compose.prod.yml up --build -d

# 3. View container health and logs
docker compose -f docker-compose.prod.yml ps
docker compose -f docker-compose.prod.yml logs -f
```

---

## 7. Testing & Verification Suite

### Automated Verification Matrix (Steps 1 &ndash; 8)

```bash
python scripts/verify_step1.py  # Step 1: Foundation & Health Architecture
python scripts/verify_step2.py  # Step 2: Database Models, Auth & Tenant Isolation
python scripts/verify_step3.py  # Step 3: DistilBERT Sentiment Analysis
python scripts/verify_step4.py  # Step 4: LDA Topic Detection
python scripts/verify_step5.py  # Step 5: Django-to-FastAPI ML Orchestration
python scripts/verify_step6.py  # Step 6: Next.js Frontend Contracts & Visualizations
python scripts/verify_step7.py  # Step 7: Bulk CSV Ingestion & Streaming Exports
python scripts/verify_step8.py  # Step 8: Production Hardening, Security & CI/CD
```

### Unit Test Suites

```bash
# 1. Run all 89 Django unit tests
python services/django-api/manage.py test apps

# 2. Run all 47 FastAPI ML unit tests
python -m unittest discover -s services/ml-service/tests
```

---

## 8. Security & Compliance Checklist

- [x] **No hardcoded production secrets**: All secrets driven by 12-factor environment variables.
- [x] **Git Secret Hygiene**: `.env`, `.env.local`, SQLite DBs, and cached models excluded in `.gitignore`.
- [x] **JWT Security**: Access tokens (60m), Refresh tokens (7d) with rotation and blacklisting.
- [x] **Multi-Tenant Isolation**: Scoped queries and cross-tenant access prevention across feedback, imports, exports, and analytics.
- [x] **Spreadsheet Formula Injection Defense**: Automatic prepending of `'` to cells starting with `=`, `+`, `-`, `@`.
- [x] **Rate Limiting & Throttling**: Configured DRF throttles for anonymous users, authenticated users, auth endpoints, imports, and exports.
- [x] **Production Security Headers**: Configured HSTS, `nosniff`, `DENY` framing, and SSL redirect toggles.
- [x] **Container Security**: Non-root execution (`USER appuser`) across all production Dockerfiles.
