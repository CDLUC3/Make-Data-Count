# Make Data Count development notes

## 2017-11-20

- Review of issues
    - https://waffle.io/CDLUC3/Make-Data-Count?label=DLM%20Display
    -
    - Creating a COUNTER standard
    - Expose the COUNTER standard within a log-processing component similar
      to the DataONE log-processor
    - Given the Draft Spec:
        - https://docs.google.com/document/d/1_wtW3TYk7AzmOfm_qjctlpaWtg6aeDJi5pxil9TRAMc/edit
        - We need to be able to define a "Dataset" and how that relates to aggregation
    - Querying the MDC API (Hub service)
        - Data citation statistics being done by Scholix project
            - RDA working group
            - Will use legatto for harvesting
        - Realtime will no scale
        - Aggregated views (eg all accesses for a user) can be expensive
        - Need to build an intermediary cache (perhaps OLAP cube)
        - Depends on MN or CN level queries
    - Displaying citations
        - Need to decide how we display versions

- Review of mockups
  - Mockups in the nceas-design git repo: https://github.nceas.ucsb.edu/NCEAS/nceas-design/tree/master/MetacatUI/Metrics/2016
- Discussion of next steps
    - Rushi: Add descriptions to all tickets to ensure we're on the same page on tasks
    - Rushi: First iteration of mockups to incorporate feedback to DataONE
    - Review these during next week's call
