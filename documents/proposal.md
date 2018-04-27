## Proposal

### Theme

We will be studying Portland street trees.  We hope to figure out if the "right" types of trees have been used in recent planting efforts.  These include large, native, evergreen trees.  We also want to learn about the planting trends across different demographics.

### Questions

**What is the planting trend across different demographic areas?**

Has planting increased over time overall?  What about in low and high income areas?

Are the same types of trees being planted?  Do the proportions of native/evergreen/large trees differ across different incomes?

**Do planted trees persist?**

Are the trees in the planting dataset still alive?

What types and species of trees last longer, and which ones have died out?

### Relevant work/resources

* [Urban Forest](https://www.portlandonline.com/portlandplan/?a=288088&c=52254) (city's canopy goals)

* [Citywide Systems & Infrastructure](https://www.portlandonline.com/portlandplan/index.cfm?c=52254&a=288093)

* [Portland Plant List](https://www.portlandoregon.gov/citycode/article/322280) (Ch. 4 has great information on nuisance plants)

* [Portland Nuisance Tree List](https://www.portlandoregon.gov/trees/article/514066)

* [Portland Street Tree Inventory Report](https://www.portlandoregon.gov/parks/article/638773)

### Contacts

* [Portland Parks & Recreation](https://www.portlandoregon.gov/parks/)

* [Friends of Trees](https://friendsoftrees.org/)

### Data

To answer our first question, we are using three datasets - a database of street tree plantings, information on median income in Portland by census tract, and a spatial dataset of the census tracts.

#### Tree Planting Data

This dataset was compiled by Portland Parks & Recreation. It contains tree planting data from several different organizations, but most of it comes from the nonprofit Friends of Trees. 

There are two components to this data.  The first is a table of plantings with each row corresponding to a planting of a specific stree tree.  It includes variables for the tree's location, planting date, species, and other information.  The second component is the spatial version of that table.

For our project, the most important variables will be:

* Location: in latitude/longitude coordinates

* Year: a numeric variable for the tree's planting year

* Name/species: categorical variables to identify a tree

* Size: a categorical variable with values small, medium, and large - we'll use this to approximate canopy radius and area for a tree

* Functional group: a categorical variable describing whether a tree is broadleaf or conifer, and deciduous or evergreen

* Index: a numeric variable giving an idea of the general quality of a tree

#### Income Data

~

#### Census Tract Data

Source: [RLIS Discovery](http://rlisdiscovery.oregonmetro.gov/?action=viewDetail&layerID=2588)

This is a shapefile of all the Portland census tracts.  We will be joining it with the census income data and the spatial tree data to create informative maps of Portland street trees and perform analyses across geographical boundaries.

To answer our second question, we'll need a fourth dataset: a current list of Portland street trees.  We will be able to join this with the planting dataset to figure out which trees persist.

#### Current Street Tree Data

~

### Vision for deliverable

#### Visualizations
#### Models
#### Data
#### Format

The project deliverable will most likely be a whitepaper containing informative maps of Portland relating to the plantings of different types of trees.  It will also include information on low-income areas of Portland.
