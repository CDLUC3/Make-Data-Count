# Usage Events


## Examples of the usage events



```json
{
 "license": "https://creativecommons.org/publicdomain/zero/1.0/",
 "obj_id": "https://doi.org/10.2973/odp.proc.ir.155.1995",
 "source_token": "28276d12-b320-41ba-9272-bb0adc3466ff",
 "occurred_at": "2005-06-21T01:42:46Z",
 "subj_id": "https://metrics.datacite.org/reports/00-11-110",
 "id": "00070ea8-1dc6-4989-9c77-ee32e2818c14",
 "terms": "https://doi.org/10.13003/CED-terms-of-use",
 "message_action": "create",
 "subj": {
   "pid": "https://metrics.datacite.org/reports/00-11-110",
   "issued": "2017-05-14T05:04:37.000Z",
   "total": 23,
 "source_id": "datacite",
 "timestamp": "2017-04-01T08:22:01Z",
 "relation_type_id": "total-dataset-investigations-regular"
}
```

## How to obtain usage events

A guide on how to access events can be found in the [EventData Query API guide](https://www.eventdata.crossref.org/guide/service/query-api/). There is not relation-type-id for usage events, therefore please use the provided mockup data.






# Guide for the Event Query API for Usage Events

This guide is intended to get you up-and-running with real-world Event Query API example for DataCite resources. We'll cover the essentials you need to know, from authentication, to retrieving results, to filtering records. 


## What's the Event Query API ?

The Event Query API is a service that collects and publishes events that happen in the web around DOIs. In the case of datacite resources, these events regurlaly are links to/from DataCite to/from other Scholalry resources. These links can be provided by three sources: DataCite, Crossref and DataCite Usage. 

- DataCite: Links from DataCite DOIs to Crossref DOIs. These are recorded in the metadata for DataCite's Registered Content. The data is ultimatley supplied by DataCite members who are the publishers and 'owners' of the Registered Content.
- Crossref: Links from Crossref DOIs to DataCite DOIs. These are recorded in the metadata for Crosref's Registered Content. The data is ultimatley supplied by Crossref members who are the publishers and 'owners' of the Registered Content.
- DataCite Usage: Links from MakeDataCount Usage Reports to DataCite DOIs. These are recorded in the MakeDataCount Hub API.  The data is ultimatley supplied by DataCite clients.


Most applications will use an existing wrapper library in the language of your choice, but it's important to familiarize yourself with the underlying API HTTP methods first.

There's no easier way to kick the tires than through cURL. If you are using an alternative client, note that you are required to send a valid User Agent header in your request.


In the rest of this guide we will run an example using the DOI `10.7291/d1q94r` and retireving events/links from the `datacite usage` source.

## Retriving relationships by DOI name

To retrieve DOI links we need to call the `events` resource and filter by the *DataCite Usage* `source` and the *DOI name*. To filter by DOI name in this case we will use the `doi` filter. 


  curl "https://api.test.datacite.org/events?mailto=YOUR_EMAIL_HERE&source-id=datacite-usage,doi=10.5061/dryad.n81g1" 

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

Mmmmm, tastes like JSON. More importatly this is a JSONAPI response. The JSONAPI has three main objects: data, links and meta. We will focus in the `data` object, as this object contains all the information we want to know provided from the DataCite Usage source. There are a few important things to notice. First the attribute `total-results` describe the number of events/links found for the DOI to other DOIs in the query. In this example for `10.7291/d1q94r` that is 9. The second thing is the `events` attribute which contains an array with the metadata for the 9 events/links found by the query. We will take a look at the attributes of the events in the next section. Having said that, at this point you now know how to use the EventData Query API to retrieve DOI-to-DOI events/links.


## Links Provided by MakeDataCount Hub in Event Data

The full description of the DataCite source metatdata can be found [DataCite section](https://www.eventdata.crossref.org/guide/sources/datacite/) of the EventData guide. Please refer to that guide for a full description, here we will just cover the essential. 

The data from this sources is all events/links in DataCite metadata deposited by DataCite members. Where a relation is made between a DataCite DOI and a Crossref DOI, that link is sent in an Event. In the example for the DOI `10.7291/d1q94r`, an event looks like this:


    {
        "license": "https:\/\/creativecommons.org\/publicdomain\/zero\/1.0\/",
        "obj_id": "https:\/\/doi.org\/10.3732\/ajb.1600328",
        "source_token": "28276d12-b320-41ba-9272-bb0adc3466ff",
        "occurred_at": "2017-03-10T00:54:36Z",
        "subj_id": "https:\/\/doi.org\/10.5061\/dryad.n81g1",
        "id": "0f8f4dbe-6aa3-47d7-9659-25f60387d4c6",
        "terms": "https:\/\/doi.org\/10.13003\/CED-terms-of-use",
        "message_action": "create",
        "source_id": "datacite",
        "timestamp": "2017-05-18T04:26:42Z",
        "relation_type_id": "is_referenced_by"
    }

Each Event is a JSON-representable object. Events have a core set of fields as described below.

| Field              | Type        | Optional? | Description |
|--------------------|-------------|-----------|-------------|
| `subj_id`          | URI         | No  | Usage Report Persistent ID. |
| `obj_id`           | URI         | No  | Dataset Persistent ID (DataCite DOI). |
| `timestamp`        | Timestamp   | No  | Timestamp of when the Event was created. |
| `occurred_at`      | Timestamp   | No  | Timestamp of when the Event is reported to have occurred |
| `id`               | UUID        | No  | Unique ID for the Event |
| `source_id`        | string      | No  | A name for the source. In this case this is DataCite-Usage |
| `source_token`     | UUID        | No  | Unique ID that identifies the Agent that generated the Event. |
| `relation_type_id` | string      | No  | Type of the relationship between the subject and object. The types found in the MakeDataCount Schema |

In the example above, we can see that the event represents a relationship between a DataCite DOI and a Crossref DOI, that this relationship was create by a DataCite member, (as the source-id in `datacite` and the subject in the relation if the DataCite DOI), in `2017-03-10` but it was captured by EventData Service in `2017-05-18`. Additionally we know that the relation indicated that the work in the DataCite DOI `10.7291/d1q94r` is referenced by the Crossref DOI `2018-3-Dash`. 


## Filtering events/links by type

Once you obtain a set of events/links you might want to filtering them by type. This is importat as not all relationship are mean the same. For example for the DOI `10.7291/d1q94r`, we would like to get all the relationship where anorther academic resource references `10.7291/d1q94r` but not relatiopships in which  `10.7291/d1q94r` is part of another work. That can be achieved by filterting by the `relation-type` to obtain relatioship that indicate references by other works, in this case `is_referenced_by`. Lie so:

    curl "https://query.eventdata.crossref.org/events?mailto=kgarza@datacite.org&filter=source:datacite,subj-id:10.7291/d1q94r,relation-type:is_referenced_by"

    {
	"status": "ok",
	"message-type": "event-list",
	"message": {
		"next-cursor": "0f8f4dbe-6aa3-47d7-9659-25f60387d4c6",
		"total-results": 7,
		"items-per-page": 1000,
		"events": [
			{
				"license": "https:\/\/creativecommons.org\/publicdomain\/zero\/1.0\/",
				"obj_id": "https:\/\/doi.org\/10.3732\/ajb.1600328",
				"occurred_at": "2017-03-10T00:54:36Z",
				"subj_id": "https:\/\/doi.org\/10.5061\/dryad.n81g1",
				"id": "b5ddb8c0-464c-4e5b-a53f-0c6f68a54d9a",
				"terms": "https:\/\/doi.org\/10.13003\/CED-terms-of-use",
				"message_action": "create",
				"source_id": "datacite",
				"timestamp": "2017-03-11T11:35:59Z",
				"relation_type_id": "is_referenced_by"
			},

This is a very similar query to the one above but you will see there are 2 hits less than before(`total-results`: 7). This is because there were two relationship with the type `has_part`, which have been filtered out.

## Authentication: Tell us who you are

Please also send the `mailto` query parameter. **It is not compulsory**, but will help us understand how people are using the API and get in contact if we need to. We won't share your email address, and will only contact you in connection with API use. For example: 

    http://query.eventdata.crossref.org/events?mailto=example@example.org&filter=obj-id:10.5555/12345678&obj-id.domain:diabesity.ejournals.ca

If you are uncomfortable sending a contact email address, then don't. You can [read more about the rationale here](https://github.com/CrossRef/rest-api-doc#etiquette).



Woot! Now you know the basics of the EventData Query API!

- Retrieving DataCite DOIs evetns/links
- Filtering by DataCite source and relationship types


Keep learning with the [EventData API official guide](https://www.eventdata.crossref.org/guide/service/query-api/) as well as the [Crossref quick start guide](https://www.eventdata.crossref.org/guide/service/quickstart/). 
