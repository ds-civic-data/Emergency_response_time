## Proposal

### Theme

We will be studying Portland street trees.  We hope to figure out if the "right" types of trees have been used in recent planting efforts.  These include large, native, evergreen trees.

### Questions

How many street trees are large? Native? Evergreen?

Have the recent plantings been of the "right" type of tree?  If not, how can planting efforts be improved?

Is tree type related to location?

### Relevant work/resources

* [Urban Forest](https://www.portlandonline.com/portlandplan/?a=288088&c=52254) (city's canopy goals)

* [Citywide Systems & Infrastructure](https://www.portlandonline.com/portlandplan/index.cfm?c=52254&a=288093)

* [Portland Plant List](https://www.portlandoregon.gov/citycode/article/322280) (Ch. 4 has great information on nuisance plants)

* [Portland Nuisance Tree List](https://www.portlandoregon.gov/trees/article/514066)

* [Portland Street Tree Inventory Report](https://www.portlandoregon.gov/parks/article/638773)

### Contacts

### Describe the data

#### Source with citation
#### Data structure / size

The data contains 52,673 rows, each corresponding to a Portland tree.  The columns correspond to different pieces of information about the tree's planting - date, location, species, etc.

#### Observational unit

Each observational unit is one planting of a Portland street tree.

#### Types of variables

| Desc | Column | Type | Range/Levels |
|-|:-:|:-:|:-:|
| Latitude | xcoord | num | 7617163-7694346 |
| Longitude | ycoord | num | 656186.7-729717.2 |
| Planting year | year | int | 1989-2018 |
| Common name | name | factor | - |
| Canopy size | size | factor | S, M, L |
| Canopy radius | canopy_rad | int | 20-60 |
| Canopy area | canopy_area | num | 1257-11310 |
| Native? | native | logical | T/F |
| Nuisance? | nuisance | logical | T/F |
| Edible? | edible | factor | fruit, nuts, none |
| Tree family | family | factor | - |
| Species | species | factor | - |
| Tree origin | origin | factor | - |
| Functional group | funct | factor | BD, BE, CD, CE |
| Planting group | group | factor | contractor, park, street, yard |

### Vision for deliverable

#### Visualizations
#### Models
#### Data
#### Format

The project deliverable will most likely be a whitepaper containing informative maps of Portland relating to the presence of non-native or nuisance trees.  It may end up being a Shiny app, however.
