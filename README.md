### [phylogeo](http://zachcp.github.com/phylogeo/)

####Geographic Mapping of Ecological Datasets

The phylogeo package is intented to allow the rapid geographic exploration of [phyloseq] (https://github.com/joey711/phyloseq) objects. The package currently only has two functions: `map_phyloseq()` will place points on a map and `map_network()` will palce poitn son a map AND draw network information about the distance between the samples.

To install, phyloseq must be first be installed. phylogeo can then be installed using `devtools`:

```
install.packages("devtools")
library("devtools")
install_github("phyloseq", "joey711")
install_github("phylogeo", "zachcp")
```

Maps like this one can be made with phyloseq-geo ![ExampleMap](https://dl.dropboxusercontent.com/u/1803062/examplemap.png)

