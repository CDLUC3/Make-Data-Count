# Citations Events


## Examples of the citation events

Citations events examples can be found in the [EventData Guide](https://www.eventdata.crossref.org/guide/sources/datacite/).


## How to obtain citation events

A guide on how to access events can be found in the [EventData Query API guide](https://www.eventdata.crossref.org/guide/service/query-api/).


# Citations Events Query API

The [Quick Start guide](quickstart) shows you how to get your hands dirty quickly. Come back and read this section afterwards!

In most cases you will want to retrieve a large batch of Events so you can perform further processing on them. The Query API provides access to all Events, with filters to restrict the results based on source, date-range, DOI etc. 

## Query Parameters

The following query parameters are available:

 - `rows` — the number of Events you want to retrieve per page. The default, and recommended, value is 10,000, which allows you to retrieve large numbers of Events quickly. There are typically between 10,000 and 100,000 Events collected per day.
 - `filter` — supply a filter that allows you to restrict results.
 - `cursor` — allows you to iterate through a search result set.
 - `from-updated-date` — a special filter that includes updated and deleted Events, to allow you to keep your dataset up to date.

## Tell us who you are

Please also send the `mailto` query parameter. **It is not compulsory**, but will help us understand how people are using the API and get in contact if we need to. We won't share your email address, and will only contact you in connection with API use. For example: 

    http://query.eventdata.crossref.org/events?mailto=example@example.org&filter=obj-id:10.5555/12345678&obj-id.domain:diabesity.ejournals.ca

If you are uncomfortable sending a contact email address, then don't. You can [read more about the rationale here](https://github.com/CrossRef/rest-api-doc#etiquette).

## Filter parameters

The `filter` parameter takes a `field:value,other-field:other-value` format, using colon (`:`) to separate keys and values and commas (`,`) to separate clauses. You can put keys or values in quotes if they contain colons, for example `subj-id:"http://example.com"`. The following fields are available. They can be used in any combination.

  - `from-occurred-date ` - as YYYY-MM-DD
  - `until-occurred-date ` - as YYYY-MM-DD
  - `from-collected-date` - as YYYY-MM-DD
  - `until-collected-date` - as YYYY-MM-DD
  - `subj-id` - quoted URL or a DOI
  - `obj-id` - quoted URL or a DOI
  - `subj-id.prefix` - DOI prefix like 10.5555, if Subject is a DOI
  - `obj-id.prefix` - DOI prefix like 10.5555, if Object is a DOI
  - `subj-id.domain` - domain of the subj_id e.g. en.wikipedia.org
  - `obj-id.domain` - domain of the obj_url e.g. en.wikipedia.org
  - `subj.url` - quoted full URL
  - `obj.url` - quoted full URL
  - `subj.url.domain` - domain of the optional subj.url, if present e.g. en.wikipedia.org
  - `obj.url.domain` - domain of the optional obj.url, if present e.g. en.wikipedia.org
  - `subj.alternative-id` - optional subj.alternative-id
  - `obj.alternative-id` - optional obj.alternative-id
  - `relation-type` - relation type ID
  - `source` - source ID

## Facets

Facets allow you to view a breakdown of the results that match your query. Using facets, you can answer questions like "of the search results, how many came from each source" or "of the search results, what were the top domains?". Facets can help you understand search results and to guide further investigation.

**The numbers that are returned are approximate not exact** and you should be careful what you do with them. Bear in mind, for example, that the same link may be observed more than once at different points in time. Facets represent "this many Events" not necessarily "this many links".

The following facets are available.

 - `source` - source ID
 - `relation-type` - relation type ID
 - `obj-id.prefix` - DOI prefix like 10.5555, if Object is a DOI
 - `subj-id.prefix` - DOI prefix like 10.5555, if Subject is a DOI
 - `subj-id.domain` - Domain of the `subj_id` URL
 - `obj-id.domain` - Domain of the `obj_id` URL
 - `subj.url.domain` - Domain of the `subj.url` URL. This may or may not be the same as the `subj_id`.
 - `obj.url.domain` - Domain of the `obj.url` URL. This may or may not be the same as the `obj_id`.

Each facet should be supplied with a limit (i.e. the top <i>n</i> results) or `*`, which is the maximum number supported. The syntax of a facet is `«facet»:«limit»`. For example

 - `source:*` means "show me the breakdown by source, up to the limit"
 - `subj-id.domain:*` means "show me the breakdown by the subject's domain name, up to the limit"
 - `subj-id.domain:10` means "show me the top 10 subj-id domains".

You many use any combination of facets, separated by commas. The following query means "show me the top 10 domains found in Events for the Newsfeed source":

    http://query.eventdata.crossref.org/events?mailto=YOUR_EMAIL_HERE&rows=0&filter=source:newsfeed&facet=subj-id.domain:10

The result, at the time of writing, incldues:

    facets: {
      subj-id-domain: {
        value-count: 10,
        values: {
          www.sciencenews.org: 11572,
          www.curiousmeerkat.co.uk: 7782,
          www.scientificamerican.com: 6768,
          www.euroscientist.com: 6191,
          www.sbpdiscovery.org: 5063,
          speakingofresearch.com: 5031,
          www.nationalelfservice.net: 4926,
          retractionwatch.com: 4848,
          cosmosmagazine.com: 4507,
          academic.oup.com: 4365
        }
      }
    }

The following query means "of all Newsfeed Events found from www.theguardian.com, show me the top DOI prefixes that Events refer to".

    http://query.eventdata.crossref.org/events?mailto=YOUR_EMAIL_HERE&rows=0&filter=source:newsfeed,subj-id.domain:www.theguardian.com&facet=obj-id.prefix:*

The result shows:

    facets: {
      obj-prefix: {
        value-count: 46,
        values: {
          10.1038: 418,
          10.5281: 255,
          10.1136: 45,
          10.1080: 36,
          10.1371: 27,
          10.1111: 27,
          10.2139: 25,
          10.1007: 19,
          10.1002: 16,
          10.3354: 9,
          10.5772: 8,
          10.1056: 7,
          10.3389: 5,
          10.1098: 4,
          10.7717: 3,
          10.1086: 3,
    ...
        }
      }
    }

Remember that these totals don't refer to unique links necessarily, so you should be cautious about using the numbers for anything other than exploration.

## Navigating results

Every API response includes a `cursor` field. If this is not `null`, you should append that cursor value to query to fetch the next page of results. Once you have fetched all results the returned cursor value will be `null`.

The total number of results matched by the query is also returned.

The order or Events returned in the result is not defined, but is stable. This means that if you iterate over a result set using the cursor you will retrieve all results for that query.

## Example queries

Ten Events from the Reddit source:

    https://query.eventdata.crossref.org/events?mailto=YOUR_EMAIL_HERE&rows=10&filter=source:reddit

Ten Events collected on the first of March 2017

    https://query.eventdata.crossref.org/events?mailto=YOUR_EMAIL_HERE&rows=10&filter=from-collected-date:2017-03-01,until-collected-date:2017-03-01

Ten Events collected in the month of March 2017

    https://query.eventdata.crossref.org/events?mailto=YOUR_EMAIL_HERE&rows=10&filter=from-collected-date:2017-03-01,until-collected-date:2017-03-31

Ten Events that occurred on or after the 10th of March 2017

    https://query.eventdata.crossref.org/events?mailto=YOUR_EMAIL_HERE&rows=10&filter=from-occurred-date:2017-03-10

Up to ten Events for the DOI https://doi.org/10.1186/s40536-017-0036-8

    https://query.eventdata.crossref.org/events?mailto=YOUR_EMAIL_HERE&rows=10&filter=obj-id:10.1186/s40536-017-0036-8

Ten Events for the DOI prefix 10.1186

    http://query.eventdata.crossref.org/events?mailto=YOUR_EMAIL_HERE&rows=10&filter=obj-id.prefix:10.1186

All Events ever! Note that you will need to use the cursor to iterate through the result set.

    http://query.eventdata.crossref.org/events?mailto=YOUR_EMAIL_HERE&rows=10000

Using the cursor returned from the first page (yours may be different) 

    http://query.eventdata.crossref.org/events?mailto=YOUR_EMAIL_HERE&rows=10000&cursor=17399fd9-319d-4b28-9727-887264a632b1

## Keeping up to date

Events can be marked as deleted or edited, as described in the [updates](../data/updates) page. By default the Query API won't serve Events that have been marked as deleted. 

If you want to check whether not not events have been updated (edited or deleted) you should supply the `from-updated-date` in `YYYY-MM-DD` format. The API will return only those Events that were updated on or after that day, **including those that were deleted**.

For example, on the 2nd of February 2017 you retrieve events from Twitter:

    http://query.eventdata.crossref.org/events?mailto=YOUR_EMAIL_HERE&rows=10&filter=source:twitter

You store the Events. One month later, you re-query for any Events that were updated since you last queried:

    http://query.eventdata.crossref.org/events?mailto=YOUR_EMAIL_HERE&rows=10&filter=source:twitter&from-update-date:2017-02-02

**We only edit Events when we absolutely need to** and the Query API will usually send an empty reply, confirming that you don't need to update your data. If it does, you should over-write your stored Events with the new ones. 

**If you retrieve Events and store them, you should regularly check up to see if they have been updated.** We don't anticipate this will happen very often, but when it does happen, it is important that you stay up-to-date. See the Best Practice section for guidance.

### Updates and Evidence

Every Evidence Record that results in an Event will contain a copy of that Event (minus the timestamp, which is applied later). If an update is made to an Event, it will not be recorded in the original Event Record.