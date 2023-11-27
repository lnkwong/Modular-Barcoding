# Modular-Barcoding

1. Use module_chooser.r to generate modules from any dataset. There are 4 functions provided:

     1. moduh - this will create modules, using height to cut the tree, with a default h=0.8. h0 can be used to change the height. Example usage: moduh("data",h0=0.85). Leave out the ".txt".
  
     2. moduk - same as moduh, but uses number of clusters to cut the tree, with a default k=5. Example usage: moduk("data",k0=10)
  
     3. modureh - input a [data]_rank_Dist_Output.txt file generated from moduh/moduk, to recut the tree using a different height. Since creation of the Dist file is the longest step, this saves having to regenerate it every time. Example usage: modureh("data"). Leave out the "'_rank_Dist_Output.txt"
  
     4. modurek - same as modureh, but uses number of clusters to cut the tree.

2. Use medcenter.r to generate a median-centered, unlogged output reflecting fold-change values around the median. The output will also list the median and mean values across all samples at the rightmost columns. There are 2 functions provided:

     1. medcen - use this on log2 data. Example usage: medcen("data"). Leave out the ".txt"

     2. medcenu - use this on unlogged data

4. Use module_corr.r to generate a data matrix containing 3 types of information: 1) the median-centered data, 2) the "collapsed" values for each module, and 3) the correlation of each gene to the collapsed value of each module. The input data must have the module annotation for each gene in the second column. See module_corr_usage.pdf for further details.

5. Use Heatmap macros.xlsm within Excel to automatically color cells based on the fold-change, either unlogged or log2. Use Alt-F11 to select and run a macro.
