suppressPackageStartupMessages({
  library(gdalUtilities, include.only = "ogr2ogr", quietly = TRUE, warn.conflicts = FALSE)
  library(rmapshaper, include.only = "ms_simplify", quietly = TRUE, warn.conflicts = FALSE)
  library(sf, include.only = c("st_read", "st_write"), quietly = TRUE, warn.conflicts = FALSE)
  library(cli)
})

setwd("/home/bob/projects/noaa-alerts-sp-to-geojson")

cat(cli::col_blue("• Downloading https://tgftp.nws.noaa.gov/SL.us008001/DF.sha/DC.cap/DS.WWA/current_all.tar.gz…\n"))

system2("wget", args = c("--quiet", "https://tgftp.nws.noaa.gov/SL.us008001/DF.sha/DC.cap/DS.WWA/current_all.tar.gz"))

unlink("current-all.geojson", force = TRUE)

cat(cli::col_blue("• Converting to GeoJSON…\n"))

gdalUtilities::ogr2ogr(
  src_datasource_name = "/vsitar/current_all.tar.gz",
  dst_datasource_name = "current-all.geojson",
  f = "GeoJSON",
  t_srs = "crs:84"
)

cat(cli::col_blue("• Simplifying features…\n"))

sf::st_read(
  dsn = "current-all.geojson",
  quiet = TRUE
) |> 
  rmapshaper::ms_simplify() -> current_all

unlink("current-all.geojson", force = TRUE)
unlink("current_all.tar.gz.properties", force = TRUE)
unlink("current_all.tar.gz*", force = TRUE)

cat(cli::col_blue("• Exposing to web…\n"))

sf::st_write(
  obj = current_all, 
  dsn = "current-all.geojson",
  quiet = TRUE
)

file.rename(
  from = "current-all.geojson", 
  to = file.path("docs", "current-all.geojson")
) -> res

system('git checkout --orphan new-shapefile')
system("git add -A")
system(sprintf("git commit -m 'chore: update %s' -m 'core: prune repo'", Sys.time()))
system('git branch -D batman')
system('git branch -m batman')
system('git push -f origin batman')
system('git gc --aggressive --prune=all')
