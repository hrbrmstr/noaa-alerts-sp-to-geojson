# noaa-alerts-sp-to-geojson

Grabs the NOAA alerts/warnings/watches/hazards shapefile and converts it to a small-(ish) GeoJSON every hour.

<https://hrbrmstr.github.io/noaa-alerts-sp-to-geojson/current-all.geojson>

## NOTE

The original process saved git history for each new conversion. That's not necessary since NOAA
maintains the history for the alerts. Rather than waste storage, the repo is pruned as each
new GeoJSON is converted.
