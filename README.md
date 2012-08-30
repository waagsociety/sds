sds
===

Personal Shared Data Storage

*What is it?*

The SDS is a (web) service for personal data storage which allows for making parts of the data public and keeping parts private. In a future version these two access levels will be expanded to allow for more fine-grained control of levels of access.
Development of the SDS was inspired by 'digital vault' and 'vendor relationship management' ideas, crowd-sourced data gathering, 'citizens' science' projects and the open data discussion in general. 
The SDS is a first step in combining the world of open, public data (not necessarily only government data) with personal and private (or corporate) data. Through offering a single API it becomes easier for application developers to allow for rich functionality where both private and public data are combined in one application; with enhanced benefits for the user as well as the developer and the public in general.
A simple example will make this more clear: suppose a taxi service (mobile) application.
- There's a function to call a local cab, based on best price, company and driver rating.
- For this, there would be a social component where rides, drivers, experience, price and more could be rated and commented upon.
- There may also be a component where rides are recorded with date, departure, destination and purpose, for personal records and/or billing purposes.
In this case there's data with a public interest, as well as data that you would not necessarily want to share, but would still want to be able to access at a later point.

*How does it work?*

The SDS is implemented on a CouchDB database. Everything is stored per person, per context, the non-public documents in encrypted form. These documents are encrypted using AES-256; key management is handled in such a way that the storage server never stores the keys in an unencrypted form; a document is stored with its decoding key encrypted with public key of all potential readers (or classes of readers).
This means that nobody can decode the data other than the intended parties, including the administrator of the server, and data is safe even if the server is compromised. If a key were to be recovered, using brute force methods or other means, the data that would be compromised is limited to a single document; there's no master key.
This also means that the responsibility for management of the private keys for a particular user lies with that user, loss of these keys means loss of data, no back-doors. Clearly application developers need to be aware of this issue and address the user experience (without compromising safety).
Extra services may be developed on the SDS level to assist developers with this process.

The data model is free form, as is usual with document stores. The SDS itself, of course, does have a structure. 
Data is stored in 'contexts'. Every context can enforce a certain structure, which the context owner specifies as a javascript validation function. This would be a 'minimal' structure, extra fields are always possible and do not necessarily need validation. In the extreme case the validation function could just be empty. In that case the existence of certain fields is not guaranteed, of course, and applications using these contexts need to be written to be functional in such an environment. 
Every context also has a 'publish' function. By default all data is private; the publish javascript function extracts that data that is available for public consumption (or, in a coming update, for specific uses such as the app developer -- through the app PP key pair -- or specific other classes of users). 
Each context can host multiple applications. These apps have their own PP key pair, and share the context data environment. Since the data is free form, they may still provide specific functionality, they do share the contexts validation and publish functions.

