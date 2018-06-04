# Implementing the COUNTER Code of Practice for Research Data in Repositories

## Getting Started

The [COUNTER Code of Practice for Research Data](https://docs.google.com/document/d/1T5YipZckpyu6ol4IqUw4vNK6uZCLsNpcFwD46R492BE/edit?usp=sharing) (CoP) is a community developed recommendation for standardized data usage metrics. The below guide outlines how to implement this guide at the repository level, as done by the California Digital Library Dash platform. For a general overview on the project and recommendation:

* View [this webinar](https://vimeo.com/233738008) and in particular the section where Martin Fenner talks about the CoP (starting at around 8 minutes).

* Read through the [CoP](https://docs.google.com/document/d/1T5YipZckpyu6ol4IqUw4vNK6uZCLsNpcFwD46R492BE/edit?usp=sharing) preprint at [https://peerj.com/preprints/26505/](https://peerj.com/preprints/26505/)

* See examples of logging and log processing infrastructure at a large scale, check out documents from DataONE ([Log Aggregation Overview](https://releases.dataone.org/online/api-documentation-v2.0.1/design/LogAggregator.html), [Event Logging and Reporting,  ](https://releases.dataone.org/online/api-documentation-v2.0.1/design/logging.html)[DataONE Usage Statistics](https://releases.dataone.org/online/api-documentation-v2.0.1/design/UsageStatistics.html))

## Background and Context for the COUNTER CoP

The CoP provides guidance for logging and log processing data at the repository level and how to send the processed logs to DataCite. Parts of the CoP refer to the [SUSHI protocol](https://www.niso.org/standards-committees/sushi) which exposes data by setting up a server with a number of filtering, date range and other options.  SUSHI (Standardized Usage Statistics Harvesting Initiative) is a separate, previously existing [NISO standard](https://www.niso.org/standards-committees/sushi) being followed by the community.

## Tracking and logging information against the CoP

The CoP suggests the following items that can be tracked, although some items may be optional if the repository system implementation doesn't support them.

1. Date and time

2. Request IP address

3. Session cookie ID: an ID kept in a session cookie which only lives as long as the browser/session is open

4. User cookie ID: an ID that identifies a user session that may persist past the closing of the browser window to future visits

5. Username or user ID: identifies a user of the system because they have logged in or identified themselves

6. The requested URL

7. The DOI Identifier which uniquely identifies this dataset

8. Size (only needed for *requests* which download a dataset and not for *investigations* which display landing pages or metadata about a dataset)

9. The user-agent string being sent by the client

Only successful requests (HTTP status codes 200 and 304) should be counted. CDL has chosen to log only successful items (and thus the status code isn't shown in our specialized COUNTER logs).

## Descriptive Metadata Requirements for the CoP

The CoP requires submitting descriptive metadata along with statistics for datasets. The descriptive metadata may either be logged at the time a dataset is accessed or have metadata enrichment take place as part of the log processing before making usage data available.  To save time and simplify log processing we suggest logging descriptive metadata along with the more technical metadata if it is already present in your repository application at the time of logging.

The descriptive metadata we're logging are shown below.  Items with an asterisk are mandatory while other metadata items are optional, yet are present in our system so are also logged.

* Title*

* Publisher*

* Publisher ID, such as from [ISNI](http://www.isni.org/) or [GRID](https://grid.ac/)*

* Creators

* Publication Date

* Version of Dataset

* Other ID for the dataset (if there is one)

* URL (the same URL that DataCite will resolve to)

* Year of Publication

For specifics about the logging format CDL is using and that works with the [counter-processor](https://github.com/CDLUC3/counter-processor), please see the [readme](https://github.com/CDLUC3/counter-processor/blob/master/README.md) and [sample log](https://github.com/CDLUC3/counter-processor/blob/master/sample_logs/counter_2018-05-08.log) in that Github repository.

One obvious choice for logging in a different way would be to avoid logging repetitive descriptive metadata in log files and instead bringing the descriptive metadata in during log processing and enrichment by doing lookups against the DataCite DOIs containing the metadata information. Metadata lookups from external sources would reduce log file sizes at the expense of some additional enrichment complexity.

If logging in a different way, the counter-processor will not work with other log files formats unless it is either modified or the log files are transformed into the format it understands.

## Log Processing and Enrichment

Additional processing is required in order to get data suitable for obtaining statistics for the CoP.  The enrichment steps are described below.

### Classifying logged URLs as either an investigation or a request

The [Counter-Processor](https://github.com/CDLUC3/counter-processor) from CDL does this by way of regular expressions that check against the URL path. (NOTE:  See the Counter CoP section 3.3.4 "Metric Types")

### Classifying the User as a Robot or Not by the User-Agent

For those unfamiliar, a [user-agent](https://www.w3.org/2005/MWI/BPWG/techs/User-Agent_String.html) string is sent as a header by web browsers, most machine agents and also robots. At the most basic level, the user-agent names the agent (software) being used to retrieve a URL. Many robot (crawler) agents such as Googlebot or Internet Archive's Heritrix crawler follow a best practice to include an informational or contact URL in the string, also.

A [counter robots](https://github.com/atmire/COUNTER-Robots) list exists, but it mixes both robots and other machine agents (such as programming tools) in one list and so it isn't extremely useful for separating the types of access. The list needs to distinguish between robots and other machine agents.

CDL divided this existing list into [robots](https://github.com/CDLUC3/Make-Data-Count/blob/master/user-agents/lists/robot.txt) and [machine agents](https://github.com/CDLUC3/Make-Data-Count/blob/master/user-agents/lists/machine.txt) lists [in a github repository](https://github.com/CDLUC3/Make-Data-Count/tree/master/user-agents/lists). There is one text file for robots and one text file for machine agents. These lists are simply regular expressions separated by newlines in each text file. The Counter Processor retrieves these lists and uses them to classify log lines by the user-agent in each line.

### Obtaining Country-Code for IP addresses

CDL uses a service called [freegeoip.net](http://freegeoip.net/) for IP to location lookups.  It is free, has code available on GitHub, is community supported and allows a generous number of API calls per hour (10,000) to their already existing API server.  If more queries are needed it could be hosted on a local server instead.  This service provides country, state and often city/locality IP address geolocation.  Right now we're only recording country-level information but may record more granular information in the future.

The Counter Processor reduces hits to this web service by checking if an IP address has been previously located and copies the geolocation from the previous lookup in the database if it is available.

### COUNTER Session ID Generation

The CoP has a number of rules for tracking user-sessions which don't match up with traditional sessions in a web application or web application framework, though they may include those concepts in their session calculation.

The CoP section 7.2 identifies ways to eliminate double-clicks for the same url by the same user-session within 30 seconds.  When doubles are detected within 30 seconds, the earlier items should be ignored or removed from the statistics.

A summary of how to identify duplicate users for the double-click calculation in descending preference is:

* By a unique username or identifier for a logged in user.

* By user cookie that identifies a user and may persist across browsing sessions.

* By session cookie which identifies a browsing session.

* By IP Address + user-agent-string + timeslice.  A timeslice uniquely identifies a clock hour of time.  For example "2018-04-21 22" (yyyy-mm-dd hh).

Similarly, the CoP seeks to identify unique dataset visits and unique dataset volume.  The uniqueness identifier is described in the CoP section 7.3 and is similar, though slightly different than the double-click identification.

The way to identify unique user sessions for this in descending order of preference is:

* By unique logged in user identification + timeslice.

* By user cookie + timeslice.

* By session cookie + timeslice.

* By IP Address + user-agent-string + timeslice.

See the last bullet in the double-click identification section above which talks about timeslices.

## Statistics Generation and Transfer

The [Counter Processor](https://github.com/CDLUC3/counter-processor) processes and enriches log files and populates the results into a Sqlite database. From the database, the script is able to obtain monthly statistics and output them into a JSON format suitable for sending to a server running DataCite's [Sashimi API for Data Level Metrics](https://github.com/datacite/sashimi). The Sashimi API documents operations and the JSON format the server supports.

The Counter Processor [readme documentation](https://github.com/CDLUC3/counter-processor/blob/master/README.md) gives specifics about how to configure and run the script in order to generate and submit monthly reports.

Although final reports are sent monthly, reporting data may be sent on a daily basis in order to update ongoing totals throughout the month.  The Counter Processor is designed so that it can send partial data for a month still in progress on a daily basis. After a month has ended it will then send a final report for the previous month.

## Obtaining Citation and Usage Data from EventData APIs

Two different EventData APIs expose citation and usage data for datasets.  The APIs are similar, though the request and return formats and parameters are not interchangeable. Datacite gives helpful documentation for starting with both the [Citation](https://support.datacite.org/v1.1/docs/eventdata-query-api-guide) and the [Data Usage](https://support.datacite.org/v1.1/docs/eventdata-query-api-for-usage) APIs. Crossref provides a more in-depth [Quickstart Guide](https://www.eventdata.crossref.org/guide/service/quickstart/) that contains more detailed examples that will be useful to read over for the Citation API.

### Getting Cumulative Data

For our initial release of a minimum viable product (MVP) we were interested in getting cumulative totals to show as views, downloads and citations in the Dash interface.

The following table summarizes which APIs we're using to obtain each count and a summary of ways in which we are requesting and processing and filtering the data to obtain the count.

<table>
  <tr>
    <td></td>
    <td>Views</td>
    <td>Downloads</td>
    <td>Citations</td>
  </tr>
  <tr>
    <td>API Used</td>
    <td>Data Usage</td>
    <td>Data Usage</td>
    <td>Citation</td>
  </tr>
  <tr>
    <td>API Base URL</td>
    <td>https://api.datacite.org/events</td>
    <td>https://api.datacite.org/events</td>
    <td>https://api.eventdata.crossref.org/v1/events</td>
  </tr>
  <tr>
    <td>Request parameters</td>
    <td>mailto=<email>
source-id=datacite-usage
obj-id=<doi>i</td>
    <td>mailto=<email>
source-id=datacite-usage
obj-id=<doi></td>
    <td>mailto=<email>
rows=10000

source=datacite
subj-id=<doi>

source=crossref
obj-id=<doi></td>
  </tr>
  <tr>
    <td>Processing</td>
    <td>Sum for all months for ['attributes']['total'] where ['attributes']['relation-type-id'] is unique-dataset-investigations-regular or unique-dataset-investigations-machine </td>
    <td>Sum for all months for ['attributes']['total'] where ['attributes']['relation-type-id'] is  unique-dataset-requests-regular or unique-dataset-requests-machine</td>
    <td>Combine, filter and deduplicate two queries and then get count of records. One query is for source=datacite and the other for source=crossref (more info below)</td>
  </tr>
</table>


### Details for Getting Cumulative Usage Data

The *view* (investigation) and *download* (request) numbers are both returned from the same Data Usage API and with the same source-id.  These totals can be obtained from one series of requests.

The API currently only returns monthly statistics with no visible way to get a grand total, so results for all months must be obtained and summed together appropriately on the client side.

A single month may return 8 relation records for a single DOI.  The 4 relations we're interested in to get totals for are *unique-dataset-investigations-regular*, *unique-dataset-investigations-machine*, *unique-dataset-requests-regular* and *unique-dataset-requests-machine*.

The page['size'] parameter did not allow more than 25 records to be returned per request (though it did successfully allow setting a smaller page size).  Each page of results includes a Hypertext Application Language (HAL) *next* link which leads to an additional page of results if it is present and non null.  It's possible to get all results page by page, by following all the *next* links until the last page of results is reached.

The views displayed in the UI come from the sum of the totals for all months for the relations *unique-dataset-investigations-regular* and *unique-dataset-investigations-machine*.

The downloads displayed in the UI come from the sum of the totals for all months for the relations *unique-dataset-requests-regular* and *unique-dataset-requests-machine*.

### Details for Getting Citation Counts

Currently we're displaying a citation count (display of full citations is coming soon).

Getting citations for a DOI requires using the Citation API.  It involves two queries for different sources.  The first query asks for DataCite events with the subj-id matching the DOI.  The second query asks for Crossref events with the obj-id matching the DOi.

By setting the page size to a suitably large number (like 10,000) we likely do not need to retrieve multiple pages to get a reasonable result set.

After results for both sources are retrieved, the following relation types are kept as citations for the dataset.

<table>
  <tr>
    <td>DataSite Relation Types</td>
    <td>Crossref Relation Types</td>
  </tr>
  <tr>
    <td>Is_cited_by
Is_supplement_to
Is_referenced_by
Is_compiled_by
Is_source_of
is_required_by</td>
    <td>cites
Is_supplemented_by
compiles
requires
references</td>
  </tr>
</table>


A reference to a dataset may appear in both sources (DataCite and Crossref) for the same item. For example, the dataset may indicate it it cited by a certain paper and the paper may indicate it cites the dataset.  Because of possible duplication, any duplicate citations need to be deduplicated and eliminated when merging results in order to avoid redundant citations.

Once deduplicated, the count of citations can be obtained by counting the citations remaining in the set.

### Caching Citation and Usage Data Counts

The COUNTER usage data we submit to DataCite is only updated on a nightly basis and citations are often not as frequently changed as usage.  Because these counts are not frequently updated it doesn't make sense to do somewhat expensive queries against the EventData APIs every time a dataset is accessed.

To reduce unnecessary queries against the EventData APIs we cache these counts in a database and only re-query the EventData APIs once a day for updated figures.  We return the result from the cache (or by a new query that is then cached) when a dataset landing page is accessed.  Datasets that are not accessed during a day do not need to have their displayed totals updated again until they are accessed again some other day.

An alternate model might be to query all DOIs for datasets on a nightly basis as part of a batch process and write the totals to a cache each night from which the totals are updated in a user interface.


