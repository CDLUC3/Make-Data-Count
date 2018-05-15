This guide is intended to get you up-and-running with a real-world Event Query API example for data usage. We'll cover all of the essentials that you need to know, from authentication to retrieving results, to filtering records. 

## What's the Event Query API?

The Event Query API is a service that collects and publishes events that happen on the web around DOIs. In the case of DataCite resources, these events regularly are links to/from DataCite to/from other scholarly resources. These links can be provided by three sources: DataCite, Crossref, and DataCite usage. 

- DataCite: Links from DataCite DOIs to Crossref DOIs. These are recorded in the metadata for DataCite's Registered Content. The data is ultimately supplied by DataCite members who are the publishers and 'owners' of the Registered Content.
- Crossref: Links from Crossref DOIs to DataCite DOIs. These are recorded in the metadata for Crossref's Registered Content. The data is ultimately supplied by Crossref members who are the publishers and 'owners' of the Registered Content.
- DataCite Usage: Links from Data Usage Reports to DataCite DOIs. These are recorded in the MakeDataCount Hub API.  The data is ultimately supplied by DataCite clients.

In this guide, we will cover DataCite Usage exclusively.


Most applications will use an existing wrapper library in the language of your choice, but it's important to familiarize yourself with the underlying API HTTP methods first.

There's no easier way to kick the tires than through cURL. If you are using an alternative client, note that you are required to send a valid User Agent header in your request.

In the rest of this guide, we will run an example using the DOI `10.7291/d1q94r` and retrieving events/links from the `datacite usage` source.

## Retrieving relationships by DOI name

To retrieve DOI links we need to call the `events` resource and filter by the *DataCite Usage* `source` and the *DOI name*. To filter by DOI name in this case we will use the `DOI` filter. 

```shell
  curl "https://api.test.datacite.org/events?mailto=YOUR_EMAIL_HERE&source-id=datacite-usage,doi=10.5061/dryad.n81g1" 
```

```json
  {
    data: [{
      id: "8a7b0a30-6638-4544-8935-61e42c02fa61",
      type: "events",
      attributes: {
        subj-id: "https://metrics.test.datacite.org/reports/2018-3-Dash",
        obj-id: "https://doi.org/10.7291/d1q94r",
        message-action: "add",
        source-token: "28276d12-b320-41ba-9272-bb0adc3466ff",
        relation-type-id: "total-dataset-investigations-regular",
        source-id: "datacite-usage",
        total: 3,
        license: "https://creativecommons.org/publicdomain/zero/1.0/",
        occurred-at: "2128-04-09T00:00:00.000Z",
        timestamp: "2018-05-09T13:53:47Z",
        subj: {
          pid: "https://metrics.test.datacite.org/reports/2018-3-Dash",
          issued: "2128-04-09"
        },
        obj: {}
      }
    }],
    links: {
      self: "https://api.test.datacite.org/events?doi=10.7291%2Fd1q94r&page%5Bnumber%5D=1&page%5Bsize%5D=25&source-id=datacite-usage",
      first: "https://api.test.datacite.org/events?doi=10.7291%2Fd1q94r&page%5Bnumber%5D=1&page%5Bsize%5D=25&source-id=datacite-usage",
      prev: null,
      next: null,
      last: "https://api.test.datacite.org/events?doi=10.7291%2Fd1q94r&page%5Bnumber%5D=1&page%5Bsize%5D=25&source-id=datacite-usage"
    },
    meta: {
      total: 70,
      total-pages: 2,
      page: 1
    }
  }
```

Mmmmm, tastes like JSON. More importantly, this is a JSONAPI response. For more imformation about the JSOAPI specification please visit http://jsonapi.org/recommendations/. The JSONAPI responses have three main objects: `data`, `links` and `meta`. We will focus on the `data` object, as this object contains all the information we want and its provided from the `DataCite Usage` source. There are a few important things to notice. First, the attribute `data`  is an array and contains the metadata for all the usage metrics for the DOI found by the query. Usually, you will find a maximum of 8 events/links per DOI in this array. One for per each metric_type and access_method permutation. We will take a look at this further down in this guide. But first, we will take a look at the attributes of the events in the next section. Having said that, at this point you now know how to use the EventData Query API to retrieve Usage Reports-to-DOI events/links.


## Links Provided by MakeDataCount Hub in Event Data

The full description of the DataCite Usage source metadata can be found [DataCite Usage section](https://www.eventdata.crossref.org/guide/sources/datacite/) of the EventData guide. Please refer to that guide for a full description, here we will just cover the essential. 

The data from this source includes all events/links in Data Usage Reports deposited by DataCite members. Where a relation is made between a DataCite DOI and a Data Usage Report, that link is sent in an Event. In the example for the DOI `10.7291/d1q94r`, an event looks like this:

```json
    data: [{
      id: "8a7b0a30-6638-4544-8935-61e42c02fa61",
      type: "events",
      attributes: {
        subj-id: "https://metrics.test.datacite.org/reports/2018-3-Dash",
        obj-id: "https://doi.org/10.7291/d1q94r",
        message-action: "add",
        source-token: "28276d12-b320-41ba-9272-bb0adc3466ff",
        relation-type-id: "total-dataset-investigations-regular",
        source-id: "datacite-usage",
        total: 3,
        license: "https://creativecommons.org/publicdomain/zero/1.0/",
        occurred-at: "2128-04-09T00:00:00.000Z",
        timestamp: "2018-05-09T13:53:47Z",
        subj: {
          pid: "https://metrics.test.datacite.org/reports/2018-3-Dash",
          issued: "2128-04-09"
        },
        obj: {}
      }
    }],
```

Each Event is a JSON-representable object. Events have a core set of fields as described below.

| Field              | Type        | Optional? | Description |
|--------------------|-------------|-----------|-------------|
| `subj_id`          | URI         | No  | Usage Report Persistent ID. |
| `obj_id`           | URI         | No  | Dataset Persistent ID (DataCite DOI). |
| `subj`          | JSON Object | Yes  | Subject metadata. |
| `obj`          | JSON Object | Yes  | Subject metadata. |
| `timestamp`        | Timestamp   | No  | Timestamp of when the Event was created. |
| `occurred_at`      | Timestamp   | No  | Timestamp of when the Event is reported to have occurred |
| `id`               | UUID        | No  | Unique ID for the Event |
| `total`               | integer        | No  | Number of total counts |
| `source_id`        | string      | No  | A name for the source. In this case, this is DataCite-Usage |
| `source_token`     | UUID        | No  | Unique ID that identifies the Agent that generated the Event. |
| `relation_type_id` | string      | No  | Type of the relationship between the subject and object. The types found in the Data Usage Report Schema |

In the example above, we can see that the event represents a relationship between a DataCite DOI and a Data Usage Report, that this relationship was created in `2017-03-10` but it was captured by EventData Service in `2017-05-18`. Additionally, we know that the relation type indicated that the link between the  DataCite DOI `10.7291/d1q94r` and the Usage Report represent the type of metric and type of access to the Resource represented by the DataCite DOI, that is `total-dataset-investigations-regular`. And that there is a `total` of 3 counts for this type of metric and access type.

### Relation Types

There eight relation types between usage reports and DataCite DOIs. These relation types are the permutations of  metric_type and access_method.

| Relation Type              | Type        | Description |
|--------------------|-------------|---------------------|
| total-dataset-investigations-regular          | Integer         | Counts for total-dataset-investigations using the regular access method |
| total-dataset-investigations-machine          | Integer         | Counts for total-dataset-investigations using the machine access method |
| total-dataset-requests-regular          | Integer         | Counts for total-dataset-requests using the regular access method |
| total-dataset-request-machine          | Integer         | Counts for total-dataset-requests using the machine access method |
| unique-dataset-investigations-regular          | Integer         | Counts for unique-dataset-investigations using the regular access method |
| unique-dataset-investigations-machine          | Integer         | Counts for unique-dataset-investigations using the machine access method |
| unique-dataset-requests-regular          | Integer         | Counts for unique-dataset-requests using the regular access method |
| unique-dataset-request-machine          | Integer         | Counts for unique-dataset-requests using the machine access method |

## Authentication: Tell us who you are

Please also send the `mailto` query parameter. **It is not compulsory**, but will help us understand how people are using the API and get in contact if we need to. We won't share your email address, and will only contact you in connection with API use. For example: 

```shell
curl "https://api.test.datacite.org/events?mailto=YOUR_EMAIL_HERE&source=datacite-usage&subj-id=10.7291/d1q94r&relation-type=total-dataset-investigations-regular"
```

If you are uncomfortable sending a contact email address, then don't. You can [read more about the rationale here](https://github.com/CrossRef/rest-api-doc#etiquette).



Woot! Now you know the basics of the EventData Query API!

- Retrieving DataCite DOIs events/links for Usage
- Filtering by DataCite Usage source and relationship types


Keep learning with the [EventData API official guide](https://www.eventdata.crossref.org/guide/service/query-api/) as well as the [Crossref quick start guide](https://www.eventdata.crossref.org/guide/service/quickstart/).