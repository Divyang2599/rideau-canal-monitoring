# Rideau Canal Skateway - Real-Time Monitoring System

**Student:** Divyang Lodariya  
**Student ID:** 041267894  
**Course:** CST8916 - Remote Data and Real-time Applications  
**College:** Algonquin College, Ottawa  

---

## What Is This Project?

The Rideau Canal in Ottawa is one of the longest skating rinks in the world. Every winter, the National Capital Commission (NCC) checks ice conditions to decide if it is safe for people to skate.

This project builds a system that monitors ice conditions automatically and in real-time. Instead of someone going out to check the ice manually, we simulate sensors placed at 3 locations along the canal. These sensors send data to the cloud every 10 seconds, and the system processes that data and shows it on a live dashboard.

---

## The 3 Sensor Locations

| Location | What It Monitors |
|---|---|
| Dow's Lake | Ice thickness, surface temp, snow, external temp |
| Fifth Avenue | Ice thickness, surface temp, snow, external temp |
| NAC | Ice thickness, surface temp, snow, external temp |

---

## Safety Rules (From NCC)

| Status | Condition |
|---|---|
| ✅ Safe | Ice ≥ 30cm AND Surface Temp ≤ -2°C |
| ⚠️ Caution | Ice ≥ 25cm AND Surface Temp ≤ 0°C |
| ❌ Unsafe | Anything else |

---

## System Architecture


![Architecture Diagram](architecture/architecture-diagram.png)

---

## Azure Services Used

**Azure IoT Hub** — Think of this as the post office. All 3 sensors send their data here and IoT Hub receives and organizes it.

**Azure Stream Analytics** — This is the brain. It reads incoming sensor data and every 5 minutes calculates the average, min, and max values. It also decides the safety status.

**Azure Cosmos DB** — A fast database that stores the processed 5-minute summaries. The dashboard reads from here.

**Azure Blob Storage** — Long-term storage. Every 5-minute summary is also saved here as a file for historical records.

**Azure App Service** — Hosts the web dashboard so anyone with the URL can see it.

---

## How Data Flows (Step by Step)

1. Python script runs on a laptop and pretends to be 3 physical sensors
2. Each sensor sends a JSON message to Azure IoT Hub every 10 seconds
3. Azure Stream Analytics reads those messages continuously
4. Every 5 minutes, Stream Analytics calculates averages and determines safety status
5. Results go into Cosmos DB (for the dashboard) and Blob Storage (for history)
6. The web dashboard reads from Cosmos DB and displays the data
7. Dashboard auto-refreshes every 30 seconds to show latest conditions

---

## Project Repositories

| Repo | Description | Link |
|---|---|---|
| Main Documentation | This repo — architecture, screenshots, query | You are here |
| Sensor Simulator | Python code that simulates the IoT sensors | [rideau-canal-sensor-simulation](https://github.com/Divyang2599/rideau-canal-sensor-simulation) |
| Web Dashboard | Node.js backend + HTML frontend | [rideau-canal-dashboard](https://github.com/Divyang2599/rideau-canal-dashboard) |

**Live Dashboard:** https://rideau-canal-dashboard-dl-gxgcfdcjbtd0h5hz.canadacentral-01.azurewebsites.net

---

## Stream Analytics Query

The query is saved in `stream-analytics/query.sql`.

The key idea: we use a **5-minute Tumbling Window**. This means every 5 minutes, Stream Analytics collects all readings from that window and calculates one summary per location. Non-overlapping windows — clean and simple.

---

## Screenshots

All screenshots are in the `screenshots/` folder:

| File | What It Shows |
|---|---|
| 01-iot-hub-devices.png | IoT Hub with 3 registered devices |
| 02-iot-hub-metrics.png | IoT Hub receiving messages from simulator |
| 03-stream-analytics-query.png | The SQL query in Stream Analytics |
| 04-stream-analytics-running.png | Stream Analytics job in Running state |
| 05-cosmos-db-data.png | Cosmos DB showing stored documents |
| 06-blob-storage-files.png | Blob Storage with archived files |
| 07-dashboard-local.png | Dashboard running on localhost |
| 08-dashboard-azure.png | Dashboard live on Azure App Service |

---

## Setup Instructions

### Prerequisites
- Azure account (student subscription works)
- Python 3.x installed
- Node.js 18+ installed

### High-Level Steps
1. Create Resource Group in Azure
2. Create IoT Hub, Cosmos DB, Storage Account
3. Register 3 devices in IoT Hub
4. Set up Stream Analytics with IoT Hub input and 2 outputs
5. Run the sensor simulator (see sensor repo)
6. Deploy the dashboard (see dashboard repo)

---

## Results

The system successfully:
- Receives sensor data from 3 locations every 10 seconds
- Processes it into 5-minute summaries with safety status
- Stores results in Cosmos DB and Blob Storage
- Displays live safety status on a web dashboard

Sample data from one 5-minute window:

| Location | Avg Ice | Avg Surface Temp | Status |
|---|---|---|---|
| Dow's Lake | 33.7 cm | -6.5°C | Safe |
| Fifth Avenue | 30.8 cm | -3.3°C | Safe |
| NAC | 35.2 cm | -9.4°C | Safe |

---

## Challenges and How I Solved Them

**Problem 1: Stream Analytics output aliases did not match the query**  
The query used `[iothub-input]` but the actual configured alias was `[rideau-canal-iot-hub]`. Fixed by checking the exact alias names in the portal and updating the query.

**Problem 2: GitHub Push Protection blocked commits with real secrets**  
I accidentally put real connection strings in `.env.example` files. GitHub blocked the push. Fixed by replacing real values with placeholders, amending the commit, and force pushing. Also regenerated all keys.

**Problem 3: Dashboard showed blank after key regeneration**  
When I regenerated the Cosmos DB key for security, Stream Analytics lost write access. Had to stop the job, update the output credentials, and restart it.

**Problem 4: Python virtual environment not reading .env file**  
`load_dotenv()` was not finding the file because the script was run from a different directory. Fixed by using `Path(__file__).parent / ".env"` to always point to the correct location.

---

## Video Demo

[YouTube Demo Link - UPDATE THIS](https://youtube.com)

---

## AI Tools Used

- **Tool:** Claude (Anthropic)
- **Purpose:** Code generation, debugging, documentation writing, architecture guidance
- **Extent:** All code was generated with AI assistance. I reviewed, understood, tested, and debugged every component. I made decisions about architecture, fixed errors, and can explain how each part works.

---

## References

- [Azure IoT Hub Documentation](https://docs.microsoft.com/azure/iot-hub/)
- [Azure Stream Analytics Documentation](https://docs.microsoft.com/azure/stream-analytics/)
- [Azure Cosmos DB Documentation](https://docs.microsoft.com/azure/cosmos-db/)
- [azure-iot-device Python SDK](https://pypi.org/project/azure-iot-device/)
- [@azure/cosmos Node.js SDK](https://www.npmjs.com/package/@azure/cosmos)
- [Chart.js Documentation](https://www.chartjs.org/docs/)
