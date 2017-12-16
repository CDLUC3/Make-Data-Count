# _[Ticket 118: List of API needs](https://github.com/CDLUC3/Make-Data-Count/issues/118)_

Once the UI mockups are in progress, we can use those to design the queries that will be necessary to drive the API. This will include knowledge of grouping facets and aggregation needs. We can use the analysis to determine:
> What fields are needed in the usage and citation APIS?
> What filter queries are needed?
> What aggregations are needed?
> Performance requirements for a responsive UX?


**_Meeting discussion (12/07/2017)_**:

> Think of what information should be stored on the Client side. What would be the best way to store that information: whether to extend a model or develop a new model. Based on these details, design high-level technical diagrams for the Client side of the system. 

### _What fields are needed in the usage and the citations API?_
* Citations
* Downloads
* Views
* Time for each event
* Dataset identifier (unique PID)
* ~~User identifier (unique ID)~~


### _What filter queries are needed?_
* **Exact match** for the `dataset` unique identifier.
    * This query will be helpful to retreive the dataset contents as well as the DLM for that dataset.
* ~~**Exact match** for the `user identifier`.~~
    * ~~This query will be helpful to get the user's contribution over the years and statistics based on that.~~
* **Substring match** for the dataset query based on the `title` param.
    * This query will be helpful to return the search results for the dataset search.
* **Substring match** for the user query based on the `author-name` param.
    * This query will be helpful to return the search results for the user search.
* Date `-gt` and `-lt` for the dataset metrics count.

### _What aggregations are needed._
Definitions: 
1. Grouping: it allows to group search results by specified field. For example, if you group by the author field, then all documents with the same value in the author field fall into a single group. You will have a kind of tree as output.
2. Facets: this feature doesn't group documents, it just tells you how many documents fall in a specific value of a facet. For example, if you have a facet based on the author field, you will receive a list of all your authors, and for each author you will know how many documents belong to that specific author.
3. Aggregation: in statistics, aggregate data are data combined from several measurements. When data are aggregated, groups of observations are replaced with summary statistics based on those observations.

Usage:
* Perform grouping on the datasets published by a speific user. This will be helpful for user profile to show the user's contribution over the years.
* Similarly grouping can be performed for all datasets published by a specific repository.
* ...

### _Performance requirements for a responsive UX._
* Should be browser responsive. i.e. the design should be consistent at different browser widths (UI).
    * Bootstrap.
* Interactive, easy to use, self explanatory interface.
* `application/json` is a preferred response format (i.e. vs `text/xml`). 
    *  Most browser-based clients are already geared to convert JSON directly into Javascript objects, whereas for XML return types, we have to apply a `parse()` step and convert XML to JS objects.

### _What information should be stored on the client side._
>
> This is more specific to the members variables and methods of the **MetricsObject** class.
>

### _What would be the best way to store that information._
* ~~session~~
* ~~local~~
* ~~hub~~
* models

**_Extend a model or develop a new model:_**
>
> developing a new model: dataMetrics Model : refer to the 
>

### _Technical Diagrams_

**Question**: `.rst` format?!

[MetricsObject Class](https://raw.githubusercontent.com/CDLUC3/Make-Data-Count/master/docs/design/MetricsObject.png)
* [Extending a  backbone Model](http://backbonejs.org/#Model)

| Use-Case| Description |
|---|---|
|[Landing Page View](https://github.com/CDLUC3/Make-Data-Count/blob/master/docs/design/Landing_Page_View_UC.md)|Rendering dataset contents as well as DLM on a view |

































































































































































































































































































































































































































