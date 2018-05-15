# Guide for the Event Query API 

This guide is intended to get you up-and-running with a real-world Event Query API example for data citations. We'll cover all of the essentials that you need to know, from authentication to retrieving results, to filtering records. For a full guide of the Event Query API please visit the [official guide](https://www.eventdata.crossref.org/guide/service/query-api/) as well as the [Crossref quick start guide](https://www.eventdata.crossref.org/guide/service/quickstart/). 


## What's the Event Query API?

The Event Query API is a service that collects and publishes events that happen on the web around DOIs. In the case of DataCite resources, these events regularly are links to/from DataCite to/from other scholarly resources. These links can be provided by three sources: DataCite, Crossref, and DataCite usage. 

- DataCite: Links from DataCite DOIs to Crossref DOIs. These are recorded in the metadata for DataCite's Registered Content. The data is ultimately supplied by DataCite members who are the publishers and 'owners' of the Registered Content.
- Crossref: Links from Crossref DOIs to DataCite DOIs. These are recorded in the metadata for Crossref's Registered Content. The data is ultimately supplied by Crossref members who are the publishers and 'owners' of the Registered Content.
- DataCite Usage: Links from MakeDataCount Usage Reports to DataCite DOIs. These are recorded in the MakeDataCount Hub API.  The data is ultimately supplied by DataCite clients.

Most applications will use an existing wrapper library in the language of your choice, but it's important to familiarize yourself with the underlying EventData Query API HTTP methods first.

There is no easier way to kick the tires than through cURL. If you are using an alternative client, note that you are required to send a valid User Agent header in your request.

In the rest of this guide, we will run an example using the DOI `10.5061/dryad.n81g1` and retrieve events/links from the `Datacite` source.

## Retrieving links by DOI name

To retrieve DOI links we need to call the `events` resource and filter by the *DataCite* `source` and the *DOI name*. To filter by DOI name in this case we will use the `subj-id` filter. 

```shell
    curl "https://query.eventdata.crossref.org/events?mailto=YOUR_EMAIL_HERE&&filter=source:datacite,subj-id:10.5061/dryad.n81g1" 
```

```json
    {
	"status": "ok",
	"message-type": "event-list",
	"message": {
		"next-cursor": "0f8f4dbe-6aa3-47d7-9659-25f60387d4c6",
		"total-results": 9,
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
			{
				"license": "https:\/\/creativecommons.org\/publicdomain\/zero\/1.0\/",
				"obj_id": "https:\/\/doi.org\/10.3732\/ajb.1600328",
				"occurred_at": "2017-03-10T00:54:36Z",
				"subj_id": "https:\/\/doi.org\/10.5061\/dryad.n81g1",
				"id": "723e3d04-da26-453b-9d88-079d7583139c",
				"terms": "https:\/\/doi.org\/10.13003\/CED-terms-of-use",
				"message_action": "create",
				"source_id": "datacite",
				"timestamp": "2017-03-11T11:43:29Z",
				"relation_type_id": "is_referenced_by"
			},
			{
				"license": "https:\/\/creativecommons.org\/publicdomain\/zero\/1.0\/",
				"obj_id": "https:\/\/doi.org\/10.3732\/ajb.1600328",
				"occurred_at": "2017-03-10T00:54:36Z",
				"subj_id": "https:\/\/doi.org\/10.5061\/dryad.n81g1",
				"id": "ae3ba9cb-7e8a-49cb-96cc-71f6b287b683",
				"terms": "https:\/\/doi.org\/10.13003\/CED-terms-of-use",
				"message_action": "create",
				"source_id": "datacite",
				"timestamp": "2017-03-11T14:30:59Z",
				"relation_type_id": "is_referenced_by"
			},
			{
				"license": "https:\/\/creativecommons.org\/publicdomain\/zero\/1.0\/",
				"obj_id": "https:\/\/doi.org\/10.5061\/dryad.n81g1\/1",
				"occurred_at": "2017-03-10T00:54:36Z",
				"subj_id": "https:\/\/doi.org\/10.5061\/dryad.n81g1",
				"id": "178f15f7-5048-4677-8e9f-97ee81186941",
				"terms": "https:\/\/doi.org\/10.13003\/CED-terms-of-use",
				"message_action": "create",
				"source_id": "datacite",
				"timestamp": "2017-03-11T14:56:17Z",
				"relation_type_id": "has_part"
			},
			{
				"license": "https:\/\/creativecommons.org\/publicdomain\/zero\/1.0\/",
				"obj_id": "https:\/\/doi.org\/10.3732\/ajb.1600328",
				"occurred_at": "2017-03-10T00:54:36Z",
				"subj_id": "https:\/\/doi.org\/10.5061\/dryad.n81g1",
				"id": "1424feb4-b085-4e9c-a9c0-fe32960aa612",
				"terms": "https:\/\/doi.org\/10.13003\/CED-terms-of-use",
				"message_action": "create",
				"source_id": "datacite",
				"timestamp": "2017-03-11T14:56:22Z",
				"relation_type_id": "is_referenced_by"
			},
			{
				"license": "https:\/\/creativecommons.org\/publicdomain\/zero\/1.0\/",
				"obj_id": "https:\/\/doi.org\/10.5061\/dryad.n81g1\/1",
				"occurred_at": "2017-03-10T00:54:36Z",
				"subj_id": "https:\/\/doi.org\/10.5061\/dryad.n81g1",
				"id": "92a4886d-3474-465f-ba3c-e49fb561ff67",
				"terms": "https:\/\/doi.org\/10.13003\/CED-terms-of-use",
				"message_action": "create",
				"source_id": "datacite",
				"timestamp": "2017-03-11T15:40:03Z",
				"relation_type_id": "has_part"
			},
			{
				"license": "https:\/\/creativecommons.org\/publicdomain\/zero\/1.0\/",
				"obj_id": "https:\/\/doi.org\/10.3732\/ajb.1600328",
				"occurred_at": "2017-03-10T00:54:36Z",
				"subj_id": "https:\/\/doi.org\/10.5061\/dryad.n81g1",
				"id": "8fc15593-a118-4bff-b994-966730f4c3b1",
				"terms": "https:\/\/doi.org\/10.13003\/CED-terms-of-use",
				"message_action": "create",
				"source_id": "datacite",
				"timestamp": "2017-03-11T15:40:04Z",
				"relation_type_id": "is_referenced_by"
			},
			{
				"license": "https:\/\/creativecommons.org\/publicdomain\/zero\/1.0\/",
				"obj_id": "https:\/\/doi.org\/10.3732\/ajb.1600328",
				"source_token": "28276d12-b320-41ba-9272-bb0adc3466ff",
				"occurred_at": "2017-03-10T00:54:36Z",
				"subj_id": "https:\/\/doi.org\/10.5061\/dryad.n81g1",
				"id": "66bff0fe-ffac-436a-8e42-4d2e9d85a9b8",
				"terms": "https:\/\/doi.org\/10.13003\/CED-terms-of-use",
				"message_action": "create",
				"source_id": "datacite",
				"timestamp": "2017-03-30T09:39:22Z",
				"relation_type_id": "is_referenced_by"
			},
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
		]
	}
    }
```

Mmmmm, tastes like JSON. There are a few important things to notice. First, the attribute `total-results` describes the number of events/links found in the DOI to other DOIs in the query. In this example for `10.5061/dryad.n81g1` that is 9. Second, is the `events` attribute which contains an array with the metadata for the 9 events/links found by the query. We will take a look at the attributes of the events in the next section. Having said that, at this point you now know how to use the EventData Query API to retrieve DOI-to-DOI events/links.

### Links Provided by DataCite Members in Event Data

The full description of the DataCite source metadata can be found [DataCite section](https://www.eventdata.crossref.org/guide/sources/datacite/) of the EventData guide. Please refer to that guide for a full description, here we will just cover the essential. 

The data from this sources is all events/links in DataCite metadata deposited by DataCite members. Where a relation is made between a DataCite DOI and a Crossref DOI, that link is sent in an Event. In the example for the DOI `10.5061/dryad.n81g1`, an event looks like this:


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

Each Event/link is a JSON-representable object. Events have a core set of fields as described below.

| Field              | Type        | Optional? | Description |
|--------------------|-------------|-----------|-------------|
| `subj_id`          | URI         | No  | Subject Persistent ID. |
| `obj_id`           | URI         | No  | Object Persistent ID. |
| `timestamp`        | Timestamp   | No  | Timestamp of when the Event was created. |
| `occurred_at`      | Timestamp   | No  | Timestamp of when the Event is reported to have occurred |
| `id`               | UUID        | No  | Unique ID for the Event |
| `source_id`        | string      | No  | A name for the source. In this case this is DataCite |
| `source_token`     | UUID        | No  | Unique ID that identifies the Agent that generated the Event. |
| `relation_type_id` | string      | No  | Type of the relationship between the subject and object. The types found in the DataCite schema |

In the example above, we can see that the event represents a relationship between a DataCite DOI and a Crossref DOI, that this relationship created by a DataCite member, (as the source-id in `datacite` and the subject in the relationship if the DataCite DOI), in `2017-03-10` but it was captured by EventData Service in `2017-05-18`. Additionally, we know that the relation indicated that the work in the DataCite DOI `10.5061/dryad.n81g1` is referenced by the Crossref DOI `10.3732/ajb.1600328`. 


## Filtering events/links by type

Once you obtain a set of events/links you might want to filter them by type. This is important, as not all relationship have the same meaning. For example for the DOI `10.5061/dryad.n81g1`, we would like to get all the relationship where another academic resource references `10.5061/dryad.n81g1` but not relationships in which  `10.5061/dryad.n81g1` is part of another work. That can be achieved by filtering by the `relation-type` to obtain a relationship that indicates references by other works, in this case `is_referenced_by`. Like so:

```shell
    curl "https://query.eventdata.crossref.org/events?mailto=example@example.org&filter=source:datacite,subj-id:10.5061/dryad.n81g1,relation-type:is_referenced_by"
````
```json
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
```

This is a very similar query to the one above but you will see there are 2 hits less than before(`total-results`: 7). This is because there were two relationships with the type `has_part`, which have been filtered out.

### Which relationship type should be filtered to measure data citations?

Here it is a list of the relation types that should be filtered in order to compute Data Citations. First there a set of relation types that should be filtered out independently of the source; see table 1. 

| Always Exclude |
| -----|
| isContinuedBy |
| Continues |
| isDescribed by |
| Describes |
| HasMetadata |
| IsMetadataFor |
| HasVersion |
| IsVersionOf |
| IsNewVersionOf |
| IsPreviousVersionOf |
| IsPartOf |
| HasPart |
| IsDocumentedBy |
| Documents |
| IsVariantFormOf |
| IsOriginalFormOf |
| IsIdenticalTo |
| IsReviewedBy |
| Reviews |
| IsDerivedFrom |

Depending on the source there would be different relation types to filter out, see table 2. For example, if the source is `DataCite` 

|   Source  |  Include  | Filter-Out  |
|  ------  |--------     |-------------    |
| DataCite   |     |    |
|    |  IsCitedBy   |   Cites |
|    |  IsSupplementTo   | IsSupplementedBy   |
|    |  IsReferencedBy   |  References  |
|    |  IsCompiledBy   | Compiles   |
|    |  IsSourceOf   |  Requires  |
|    |  IsRequiredBy   |    |
|    |     |    |
| Crossref   |     |    |
|    |  Cites   | IsCitedBy   |
|    |  IsSupplementedBy   |  IsSupplementTo  |
|    |   Compiles  |  IsReferencedBy  |
|    |   Requires  |  IsCompiledBy  |
|    |  References   | IsSourceOf   |
|    |     |  IsRequiredBy  |


## Authentication: Tell us who you are

Please also send the `mailto` query parameter. **It is not compulsory**, but will help us understand how people are using the API and get in contact if we need to. We won't share your email address, and will only contact you in connection with API use. For example: 

```shell
    http://query.eventdata.crossref.org/events?mailto=example@example.org&filter=obj-id:10.5555/12345678&obj-id.domain:diabesity.ejournals.ca
```

If you are uncomfortable sending a contact email address, then don't. You can [read more about the rationale here](https://github.com/CrossRef/rest-api-doc#etiquette).



Woot! Now you know the basics of the EventData Query API!

- Retrieving DataCite DOI events/links
- Filtering by DataCite source and relationship types


Keep learning with the [EventData API official guide](https://www.eventdata.crossref.org/guide/service/query-api/) as well as the [Crossref quick start guide](https://www.eventdata.crossref.org/guide/service/quickstart/).