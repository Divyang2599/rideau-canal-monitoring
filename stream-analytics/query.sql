WITH SensorData AS (
    SELECT
        location,
        iceThickness,
        surfaceTemperature,
        snowAccumulation,
        externalTemperature,
        System.Timestamp() AS windowEnd
    FROM [rideau-canal-iot-hub]
    TIMESTAMP BY CAST(timestamp AS datetime)
),

Aggregated AS (
    SELECT
        location,
        AVG(iceThickness)           AS avgIceThickness,
        MIN(iceThickness)           AS minIceThickness,
        MAX(iceThickness)           AS maxIceThickness,
        AVG(surfaceTemperature)     AS avgSurfaceTemperature,
        MIN(surfaceTemperature)     AS minSurfaceTemperature,
        MAX(surfaceTemperature)     AS maxSurfaceTemperature,
        MAX(snowAccumulation)       AS maxSnowAccumulation,
        AVG(externalTemperature)    AS avgExternalTemperature,
        COUNT(*)                    AS readingCount,
        System.Timestamp()          AS windowEndTime,
        CASE
            WHEN AVG(iceThickness) >= 30 AND AVG(surfaceTemperature) <= -2
                THEN 'Safe'
            WHEN AVG(iceThickness) >= 25 AND AVG(surfaceTemperature) <= 0
                THEN 'Caution'
            ELSE 'Unsafe'
        END AS safetyStatus
    FROM SensorData
    GROUP BY
        location,
        TumblingWindow(minute, 5)
)

SELECT
    CONCAT(location, '-', CAST(windowEndTime AS nvarchar(max))) AS id,
    location,
    avgIceThickness,
    minIceThickness,
    maxIceThickness,
    avgSurfaceTemperature,
    minSurfaceTemperature,
    maxSurfaceTemperature,
    maxSnowAccumulation,
    avgExternalTemperature,
    readingCount,
    windowEndTime,
    safetyStatus
INTO [SensorAggregations]
FROM Aggregated;

SELECT
    CONCAT(location, '-', CAST(windowEndTime AS nvarchar(max))) AS id,
    location,
    avgIceThickness,
    minIceThickness,
    maxIceThickness,
    avgSurfaceTemperature,
    minSurfaceTemperature,
    maxSurfaceTemperature,
    maxSnowAccumulation,
    avgExternalTemperature,
    readingCount,
    windowEndTime,
    safetyStatus
INTO [historical-data]
FROM Aggregated;