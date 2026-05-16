# 🕌 MasjidAtlas

A Flutter app that helps users discover nearby mosques based on their current location — without relying on the Google Maps API. Mosque data is scraped, cleaned, and stored in Supabase with PostGIS spatial support to power fast, proximity-based queries.

![Flutter](https://img.shields.io/badge/Flutter-3.x-blue) ![Supabase](https://img.shields.io/badge/Supabase-PostGIS-green) ![Architecture](https://img.shields.io/badge/Architecture-MVVM-purple)

---

## What it does

MasjidAtlas builds a spatial bounding box around the user's GPS coordinates using PostGIS functions, then queries the Supabase database to return all mosques within that area. Each mosque listing includes its available facilities (e.g. parking, wudu area, women's section).

`📍 user location → bounding box (PostGIS) → spatial query → nearby masjids + facilities`

---

## Data pipeline

No third-party mosque API exists, so the data was sourced end-to-end:

- **Scraped** using Selenium (Python)
- **Cleaned** and normalized
- **Inserted** into Supabase with PostGIS geometry columns
- Spatial queries use `ST_MakeEnvelope` / bounding box functions for fast lookups

---

## Architecture

**MVVM** — each screen has a paired `ViewModel` that extends `BaseViewModel`, driving UI state via a `ViewState` enum (idle / busy / error). Services are injected via **GetIt**, and **Provider** handles reactive UI updates.



## Tech stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x |
| State management | Provider + MVVM |
| Dependency injection | GetIt |
| Backend / Database | Supabase + PostGIS |
| Auth | Google, Facebook, Email |
| Notifications | Firebase Messaging |
| HTTP client | Dio |
| Data pipeline | Selenium (Python) |

---

## Key highlights

- Custom spatial data pipeline — no mosque directory API used
- PostGIS bounding box queries for real-time proximity search
- Full MVVM separation with a shared `BaseViewModel`
- Multi-provider auth (Google, Facebook, email)
- Firebase Crashlytics, Performance monitoring, and Push Notifications
- Responsive UI with `flutter_screenutil` and shimmer loading states
