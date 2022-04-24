# Grand Prix Stats

Grand Prix Stats data processors and generators.

## Contents

This Swift Package contains several modules for data processing, and generation
of the Grand Prix Stats static website, as well as other visualizations.

| Module            | Type       | Description |
| ----------------- | ---------- | ----------- |
| Database          | library    | Database access, currently MySQL only. |
| GPSModels         | library    | Collection of data models used to load data from the database and serialize output for API, website, and SwiftUI visualizations. |
| GrandPrixStatsCLI | executable | Command line tool to migrate databases, process data, and generate website and visualizations. |
| Rasterizer        | library    | Utility module to rasterize SwiftUI views into images. |
| Visualizations    | library    | Collection of SwiftUI views to render visualizations as static images for posting on social media and such. |

