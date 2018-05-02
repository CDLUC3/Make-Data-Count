# Quick Start

> **Note: Please read the Beta notice on the [Welcome](/) page. Until Event Data is in production mode, we do not recommend building any commercial or customer-based tools off the data**

After this page, please ensure you have read this guide thoroughly before using this data for anything serious! Additionally, you should consult the documentation for each Source you intend to use.

Most of the time you will want to grab the dataset in bulk, or for a paricular source, or a particular DOI prefix. You can then filter it, load it into your own data store, etc. Check the [Crossref blog](https://www.crossref.org/categories/event-data/) for ideas. We collect a few tens of thousands of Events per day, so that can weigh in at over 10MB of data per day. Bear this in mind if you point a browser at the URLs.

This quick start is going to show you how to fetch data and then do some rudimentary querying with it using the popular [JQ tool](https://stedolan.github.io/jq/).

Data is available on a per-day basis. To fetch 10,000 Events from Event Data, collected at any time:

    curl "https://query.eventdata.crossref.org/events?mailto=YOUR_EMAIL_HERE&rows=10000" > all-events.json

That returns 10,000 Events (out of a possible 1,363,971 at the time of writing).

If you're only interested in DataCite, you can filter that:

    curl "https://query.eventdata.crossref.org/events?mailto=YOUR_EMAIL_HERE&rows=10000&filter=source:DataCite" > datacite-events.json

If you're only interested in F1000 articles (4013 Events), you can filter by their prefix:

    curl "https://query.eventdata.crossref.org/events?mailto=YOUR_EMAIL_HERE&rows=10000&filter=source:datacite,prefix:10.21955" > datacite-f1000.json

Now you've got a few thousand Events to crunch.

We can pipe it through `jq` to format it nicely. I've cut its head off at 28 lines:


    $ jq . datacite-f1000.json | head -n 21
    {
      "status": "ok",
      "message-type": "event-list",
      "message": {
        "next-cursor": "0c68482f-1c36-4111-bee3-eb75395b8e0c",
        "total-results": 854523,
        "items-per-page": 10000,
        "events": [
          {
            "license": "https://creativecommons.org/publicdomain/zero/1.0/",
            "obj_id": "https://doi.org/10.3732/ajb.1600328",
            "occurred_at": "2017-03-10T00:54:36Z",
            "subj_id": "https://doi.org/10.5061/dryad.n81g1",
            "id": "b5ddb8c0-464c-4e5b-a53f-0c6f68a54d9a",
            "terms": "https://doi.org/10.13003/CED-terms-of-use",
            "message_action": "create",
            "source_id": "datacite",
            "timestamp": "2017-03-11T11:35:59Z",
            "relation_type_id": "is_referenced_by"
          },

Note the `cursor`. You can use these to navigate your query back and forward through time on the API.

I'm going to use JQ to select the `events`, then I'm going to return all of the distinct source names.

    jq '.events | map(.source_id) | unique ' 2017-02-21.json
    [
      "datacite",
      "twitter"
    ]

We were only collecting for those two sources on that day. Now let's group by the DOI and count how many Events we got for each DOI. Again, I've snipped a long output.

    $ jq '.events | group_by(.obj_id) | map ([.[0].obj_id, length]) ' 2017-02-21.json  | head -n 17
    [
      [
        "https://doi.org/10.1001/journalofethics.2017.19.2.pfor1-1702",
        1
      ],
      [
        "https://doi.org/10.1001/journalofethics.2017.19.2.stas1-1702",
        3
      ],
      [
        "https://doi.org/10.1001/virtualmentor.2010.12.9.imhl1-1009",
        11
      ],
      [
        "https://doi.org/10.1001/virtualmentor.2013.15.5.imhl1-1305",
        4
      ],
      [

That's all for now. The [Query API](query-api) page describes the Query API and connected services in depth.
