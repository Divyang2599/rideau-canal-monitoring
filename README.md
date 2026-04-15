# Rideau Canal Skateway: Real-Time Monitoring System

**Student:** Divyang Lodariya  
**Student ID:** 041267894  
**Course:** CST8916 — Remote Data and Real-time Applications  
**College:** Algonquin College, Ottawa  

---

## 1. Project Overview

The Rideau Canal in Ottawa is one of the longest skating rinks in the world. Every winter, the National Capital Commission (NCC) checks ice conditions to decide if it is safe for people to skate.

This project builds a system that monitors ice conditions automatically and in real-time. Instead of someone going out to check the ice manually, we simulate sensors placed at 3 locations along the canal. These sensors send data to the cloud every 10 seconds, and the system processes that data and shows it on a live dashboard.

---

## 2. Sensor Configurations

### 2.1 Sensor Locations

| Location | Parameters Monitored |
| :--- | :--- |
| **Dow's Lake** | Ice thickness, surface temp, snow, external temp |
| **Fifth Avenue** | Ice thickness, surface temp, snow, external temp |
| **NAC** | Ice thickness, surface temp, snow, external temp |

### 2.2 Safety Rules (NCC Standards)

| Status | Condition |
| :--- | :--- |
| ✅ **Safe** | Ice ≥ 30cm AND Surface Temp ≤ -2°C |
| ⚠️ **Caution** | Ice ≥ 25cm AND Surface Temp ≤ 0°C |
| ❌ **Unsafe** | Anything else |

---

## 3. System Architecture

```mermaid
